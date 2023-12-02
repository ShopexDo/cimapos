
import 'dart:isolate';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/product_controller.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/data/model/response/product_model.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/app_constants.dart';
import 'package:cimapos/util/color_resources.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_drawer.dart';
import 'package:cimapos/view/base/custom_field_with_title.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:cimapos/view/base/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
class BarCodeGenerateScreen extends StatefulWidget {
  final Products product;
  const BarCodeGenerateScreen({Key key, this.product}) : super(key: key);

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  TextEditingController quantityController = TextEditingController();
  int barCodeQuantity = 4;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    quantityController.text = '4';
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
      endDrawer:  CustomDrawer(),
      body: GetBuilder<ProductController>(
        builder: (barCodeController) {
          return Column(children: [
            CustomHeader(title: 'bar_code_generator'.tr, headerImage: Images.bar_code_generate),
            Container(child: Column(children: [

              Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(children: [
                Row(children: [
                  Text('${'code'.tr} : '),
                  Text('${widget.product.productCode}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor))],),

                Row(children: [
                  Text('${'product_name'.tr} : '),
                  Expanded(
                    child: Text('${widget.product.title}', maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                  )],),
              ],),),


              CustomFieldWithTitle(
                isSKU: true,
                limitSet: true,
                setLimitTitle: 'maximum_quantity_270'.tr,
                customTextField: CustomTextField(hintText: 'sku_hint'.tr,
                controller: quantityController),
                title: 'qty'.tr,
                requiredField: true,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                SizedBox(width: Dimensions.FONT_SIZE_SMALL),
                Expanded(child: CustomButton(buttonText: 'generate'.tr,
                onPressed: (){
                  if(int.parse(quantityController.text)>270 || int.parse(quantityController.text) ==0){
                    showCustomSnackBar('please_enter_from_1_to_270'.tr);
                  }else{
                    barCodeController.setBarCodeQuantity(int.parse(quantityController.text));
                  }

                })),
                SizedBox(width: Dimensions.FONT_SIZE_SMALL),
                Expanded(child: CustomButton(buttonText: 'download'.tr,
                    onPressed : () async {
                       final baseUrl = await AppConstants.getSavedBaseUrl();
                      _launchUrl(Uri.parse('${baseUrl}${AppConstants.BAR_CODE_DOWNLOAD}?id=${widget.product.id}&quantity=${int.parse(quantityController.text)}'));

                      // final status = await Permission.storage.request();
                      // if(status.isGranted){
                      //
                      //   barCodeController.barCodeDownload(widget.product.id,int.parse( quantityController.text)).then((value) async {
                      //     Directory directory = Directory('/storage/emulated/0/Download');
                      //     if (!await directory.exists()) directory = await getExternalStorageDirectory();
                      //     barCodeController.downloadFile(barCodeController.printBarCode,directory.path);
                      //   });
                      //
                      // }else{
                      //   print('=====permission denied=====');
                      // }

                    }
                    ,buttonColor: ColorResources.COLOR_PRINT)),
                SizedBox(width: Dimensions.FONT_SIZE_SMALL),
                Expanded(child: CustomButton(buttonText: 'reset'.tr,onPressed: (){
                  quantityController.text = '4';
                  barCodeController.setBarCodeQuantity(4);
                },
                buttonColor: ColorResources.getResetColor(),textColor: ColorResources.getTextColor(),isClear: true)),
                SizedBox(width: Dimensions.FONT_SIZE_SMALL),


              ],)
            ],),),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: GridView.builder(
                itemCount: barCodeController.barCodeQuantity,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1/1,
                  ), itemBuilder: (barcode, index){
                    return Column(
                      children: [
                        Text('${Get.find<SplashController>().configModel.businessInfo.shopName}',
                          style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                        Text('${widget.product.title}', maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),),
                        Text('${PriceConverter.priceWithSymbol(widget.product.sellingPrice)}'),
                        BarcodeWidget(
                          data: 'code : ${widget.product.productCode}',style: fontSizeRegular.copyWith(),
                          barcode: Barcode.code128(),

                        ),
                      ],
                    );
              }),
            ))
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
