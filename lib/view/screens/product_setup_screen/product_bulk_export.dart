
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/product_controller.dart';
import 'package:cimapos/util/app_constants.dart';
import 'package:cimapos/util/color_resources.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:url_launcher/url_launcher.dart';



class ProductBulkExport extends StatefulWidget {
  const ProductBulkExport({Key key}) : super(key: key);

  @override
  State<ProductBulkExport> createState() => _ProductBulkExportState();
}

class _ProductBulkExportState extends State<ProductBulkExport> {
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
    return Scaffold(
      appBar: CustomAppBar(),
      body: GetBuilder<ProductController>(
        builder: (exportController) {
          return Column(children: [

            CustomHeader(title: 'bulk_export'.tr, headerImage: Images.import),

            InkWell(
              onTap: () async {
                final baseUrl = await AppConstants.getSavedBaseUrl();
                print('bangla vai-----${baseUrl}${AppConstants.BULK_EXPORT_PRODUCT}----------');
               _launchUrl(Uri.parse('${baseUrl}${AppConstants.BULK_EXPORT_PRODUCT}'));

              },
              child: Container(child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 100,child: Image.asset(Images.download)),
                  Text('click_download_button'.tr, textAlign: TextAlign.center,
                    style: fontSizeRegular.copyWith(color: ColorResources.DOWNLOAD_FORMAT.withOpacity(.5)),),
                ],)),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(buttonText: 'download'.tr, onPressed: () async {
                final baseUrl = await AppConstants.getSavedBaseUrl();
                _launchUrl(Uri.parse('${baseUrl}${AppConstants.BULK_EXPORT_PRODUCT}'));
              },),
            ),

          ],);
        }
      ),
    );
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}