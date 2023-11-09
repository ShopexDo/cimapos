import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
class ProductBulkImport extends StatefulWidget {
  const ProductBulkImport({Key key}) : super(key: key);

  @override
  State<ProductBulkImport> createState() => _ProductBulkImportState();
}

class _ProductBulkImportState extends State<ProductBulkImport> {

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    File uploadedFileName;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          CustomHeader(title: 'bulk_import'.tr, headerImage: Images.import),

          GetBuilder<ProductController>(
            builder: (importController) {
              return Column(
                children: [
                  Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('instructions'.tr, style: fontSizeBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                     SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                     Text('instructions_details'.tr),


                     SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

                     Row(children: [
                       Container(child: Image.asset(Images.import),width: Dimensions.ICON_SIZE_SMALL),
                       SizedBox(width: Dimensions.ICON_SIZE_SMALL),
                       Text('import'.tr, style: fontSizeBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: ColorResources.getTitleColor())),
                       Spacer(),
                      InkWell(
                        onTap : () async {
                          final status = await Permission.storage.request();
                          if(status.isGranted){

                            importController.getSampleFile().then((value) async {

                              _launchUrl(Uri.parse('${importController.bulkImportSampleFilePath}'));
                            });

                          }else{
                            print('=====permission denied=====');
                          }

                        },
                        child: Container(child: Row(children: [
                          Text('download_format'.tr, style: fontSizeRegular.copyWith(color: ColorResources.DOWNLOAD_FORMAT)),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Container(child: Image.asset(Images.download_format),width: Dimensions.ICON_SIZE_SMALL),
                        ],),),
                      )
                     ],),
                   ],
                  ),),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  InkWell(
                    onTap: ()async{
                      FilePickerResult result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xlsm', 'xlsb', 'xltx'],
                      );
                      if (result != null) {
                        File file = File(result.files.single.path);
                        PlatformFile fileNamed = result.files.first;
                        uploadedFileName = file;
                        importController.setSelectedFileName(file);
                        print('===>${fileNamed.name} and $uploadedFileName');

                      } else {

                      }
                    },
                    child: Builder(
                      builder: (context) {
                        print('===File name>$uploadedFileName');
                        return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: 100,child: Image.asset(Images.upload)),
                            importController.selectedFileForImport !=null ?
                            Text('${'product_bulk_format.xlsx'}', style: fontSizeRegular.copyWith(color: ColorResources.DOWNLOAD_FORMAT.withOpacity(.5)),)
                            :Text('upload_file'.tr, style: fontSizeRegular.copyWith(color: ColorResources.DOWNLOAD_FORMAT.withOpacity(.5)),),
                          ],);
                      }
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_LARGE),
                    child: CustomButton(buttonText: 'submit'.tr, onPressed: () async {
                      if(importController.selectedFileForImport != null){
                        importController.bulkImportFile();
                      }else{
                        showCustomSnackBar('select_file_first'.tr);
                      }

                    },),
                  ),
                ],
              );
            }
          )
        ],
      ),
    );
  }

}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}
