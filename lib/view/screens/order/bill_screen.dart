import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/quote_controller.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/helper/date_converter.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_divider.dart';
import 'package:cimapos/view/base/custom_drawer.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/screens/pos_printer/bill_print.dart';
import 'package:cimapos/view/screens/pos_printer/pdf_bill_generator.dart';
import 'widget/invoice_element_view.dart';

class BillScreen extends StatefulWidget {
  final int quoteId;
  const BillScreen({Key key, this.quoteId}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  Future<void> _loadData() async {
    await Get.find<QuoteController>().getQuoteData(widget.quoteId);
  }
  double totalPayableAmount = 0;


  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: GetBuilder<SplashController>(
        builder: (shopController) {

          return SingleChildScrollView(
            child: GetBuilder<QuoteController>(
              builder: (invoiceController) {
                if(invoiceController.invoice != null &&  invoiceController.invoice.quoteAmount != null){
                  totalPayableAmount = invoiceController.invoice.quoteAmount +
                      invoiceController.totalTaxAmount -
                      invoiceController.invoice.extraDiscount- invoiceController.invoice.couponDiscountAmount;
                }
                return Column(children: [
                  CustomHeader(title: 'quote'.tr, headerImage: Images.people_icon),

                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.to(BillPrintScreen(
                                configModel: shopController.configModel,
                                bill: invoiceController.invoice,
                                quoteId: widget.quoteId,
                                discountProduct: invoiceController.discountOnProduct,
                                total: totalPayableAmount,
                              ));
                            },
                            child: Center(
                              child: Row(
                                children: [
                                  Container(child: Icon(Icons.event_note_outlined, color: Theme.of(context).cardColor, size: 15)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_MEDIUM_BORDER),
                                  Text('print'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Container(
                          width: 90,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                            color: Colors.red,
                          ),
                          child: InkWell(
                            onTap: () {
                              print(invoiceController.invoice);
                              Get.to(PDFBillGenerator.generatePDF(
                                configModel: shopController.configModel,
                                bill: invoiceController.invoice,
                                quoteId: widget.quoteId,
                                discountProduct: invoiceController.discountOnProduct,
                                total: totalPayableAmount,
                              ));
                            },
                            child: Center(
                              child: Row(
                                children: [
                                  Container(child: Icon(Icons.picture_as_pdf, color: Theme.of(context).cardColor, size: 15)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_MEDIUM_BORDER),
                                  Text('pdf', style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Text(shopController.configModel.businessInfo.shopName,
                      style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.FONT_SIZE_OVER_OVER_LARGE,),),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),



                    Text(shopController.configModel.businessInfo.shopAddress,
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                    Text(shopController.configModel.businessInfo.shopPhone,
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                    Text(shopController.configModel.businessInfo.shopEmail,
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(shopController.configModel.businessInfo.vat?? 'vat',
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                  ],),


                  GetBuilder<QuoteController>(
                    builder: (quoteController) {

                      return quoteController.invoice != null &&  quoteController.invoice.quoteAmount != null ?
                        Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        child: Column(children: [
                          CustomDivider(color: Theme.of(context).hintColor),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${'quote'.tr.toUpperCase()} # ${widget.quoteId}', style: fontSizeBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_LARGE)),

                            Text('payment_method'.tr, style: fontSizeBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ],),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${DateConverter.dateTimeStringToMonthAndTime(quoteController.invoice.createdAt)}',
                                style: fontSizeRegular),

                            Text('${'paid_by'.tr} ${invoiceController.invoice.account != null ? invoiceController.invoice.account.account : 'customer balance'}', style: fontSizeRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            )),
                          ],),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          CustomDivider(color: Theme.of(context).hintColor),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                          InvoiceElementView(serial: 'sl'.tr, title: 'product_info'.tr, quantity: 'qty'.tr, price: 'price'.tr, isBold: true),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          Container(
                            child: ListView.builder(
                              itemBuilder: (con, index){

                                return Container(height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text((index+1).toString()),
                                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                        Expanded(
                                            child: Text(jsonDecode(quoteController.invoice.details[index].productDetails)['name'],
                                              maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                          child: Text(quoteController.invoice.details[index].quantity.toString()),
                                        ),

                                        Text('${PriceConverter.priceWithSymbol(quoteController.invoice.details[index].price)}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: quoteController.invoice.details.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                            child: CustomDivider(color: Theme.of(context).hintColor),
                          ),


                          Container(child: Column(children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('subtotal'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverter.priceWithSymbol(quoteController.invoice.quoteAmount)),
                            ],),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('product_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverter.priceWithSymbol(invoiceController.discountOnProduct)),
                            ],),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            //   Text('coupon_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                            //   Text(PriceConverter.priceWithSymbol(quoteController.invoice.couponDiscountAmount)),
                            // ],),
                            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('extra_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverter.priceWithSymbol(quoteController.invoice.extraDiscount)),
                            ],),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('tax'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverter.priceWithSymbol(invoiceController.totalTaxAmount)),
                            ],),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          ],),),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: CustomDivider(color: Theme.of(context).hintColor),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text('total'.tr,style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE),),
                            Text(PriceConverter.priceWithSymbol(totalPayableAmount),
                                style: fontSizeBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ],),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),


                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          //   Text('change'.tr,style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                          //   Text(PriceConverter.priceWithSymbol(quoteController.invoice.collectedCash - totalPayableAmount),
                          //       style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                          // ],),
                          // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),



                          Column(children: [
                            Text('terms_and_condition'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                            Text('terms_and_condition_details'.tr, maxLines:2,textAlign: TextAlign.center,
                              style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),),
                          ],),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                            child: CustomDivider(color: Theme.of(context).hintColor),
                          ),

                          Column(children: [
                            Text('${'powered_by'.tr} ${shopController.configModel.businessInfo.shopName}', style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                            Text('${'shop_online'.tr} ${shopController.configModel.businessInfo.shopName}', maxLines:2,textAlign: TextAlign.center,
                              style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),),
                          ],),

                          SizedBox(height: Dimensions.PADDING_SIZE_CUSTOMER_BOTTOM),

                        ],),
                      ):SizedBox();
                    }
                  ),
                ],);
              }
            ),
          );
        }
      ),
    );
  }
}
