import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/model/response/quote_model.dart';
import 'package:cimapos/helper/date_converter.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/screens/order/bill_screen.dart';
import 'package:cimapos/view/screens/user/widget/custom_divider.dart';
import 'package:cimapos/view/base/animated_custom_dialog.dart';
import 'package:cimapos/view/screens/quote/widget/confirm_bill_dialog.dart';
import 'package:cimapos/controller/quote_controller.dart';
import 'package:cimapos/view/screens/order/invoice_screen.dart';
import 'package:cimapos/view/screens/quote/pos_screen.dart';

class QuoteCardWidget extends StatelessWidget {
  final Quotes quote;
  const QuoteCardWidget({Key key, this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: GetBuilder<QuoteController>(
      builder: (quoteController) {
        return Column(children: [

          Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        '${quote.id}',
                        style: fontSizeRegular.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${DateConverter.dateTimeStringToMonthAndTime(quote.createdAt)}',
                        style: fontSizeRegular,
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      if (quote.state == 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange, // Color del badge
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Pendiente',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12, // Tamaño de fuente del badge
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue, // Color del badge
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Facturado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12, // Tamaño de fuente del badge
                            ),
                          ),
                        ),
                      if (quote.state == 0) SizedBox(height: 3), // Espacio entre el badge y el botón
                      if (quote.state == 0)
                        SizedBox(
                          height: 25, // Altura del botón
                          width: 80, // Ancho del botón
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // showAnimatedDialog(context,
                              //   ConfirmBillDialog(
                              //       onYesPressed: () {
                              //         // Get.find<QuoteController>().getQuoteList('1', reload: true);
                              //         quoteController.approvedQuote(quote.id).then((value){
                              //           if (value.isOk) {
                              //             print(value.body['order_id']);
                              //             Get.find<QuoteController>().getQuoteList('1', reload: true);
                              //             Get.to(()=> InVoiceScreen(orderId: value.body['order_id']));
                              //           }
                              //         });
                              //       }
                              //   ),
                              //   dismissible: false,
                              //   isFlip: false);
                              Get.to(()=> PosScreen(fromMenu: true, quoteId: quote.id, quoteAmount: quote.quoteAmount, totalTax: quote.totalTax, customerId: quote.client.id, customerName: quote.client.name, customerPhone: quote.client.mobile));
                              // Get.to(()=> PosScreen());
                            },
                            style: OutlinedButton.styleFrom(
                              primary: Colors.green, // Color de contorno del botón
                              side: BorderSide(color: Colors.green), // Color del contorno del botón
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Ajusta el padding
                            ),
                            icon: Icon(
                              Icons.check_circle,
                              size: 16, // Tamaño del ícono
                              color: Colors.green, // Color del ícono
                            ),
                            label: Text(
                              'Facturar',
                              style: TextStyle(
                                fontSize: 10, // Tamaño de fuente del texto
                                color: Colors.green, // Color del texto
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomDivider(color: Theme.of(context).hintColor),
              ),

              IntrinsicHeight(child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Text('quote_summary'.tr, style: fontSizeRegular.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        )),
                        SizedBox(height: 5),

                        Text(
                          '${'quote_amount'.tr}: ${PriceConverter.priceWithSymbol(quote.quoteAmount) ?? 0}',
                          style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '${'tax'.tr}: ${PriceConverter.priceWithSymbol(
                            double.tryParse(quote.totalTax.toString()),
                          ) ?? 0}',
                          style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '${'extra_discount'.tr}: ${PriceConverter.priceWithSymbol(double.parse(quote.extraDiscount.toString())) ?? 0}',
                          style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '${'coupon_discount'.tr}: ${PriceConverter.priceWithSymbol(
                            double.tryParse(quote.couponDiscountAmount.toString()),
                          )}',
                          style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('payment_method'.tr, style: fontSizeRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                            )),
                            SizedBox(height: 5),

                            Text(quote.account != null ? quote.account.account : 'customer balance',
                              style: fontSizeRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              ),
                            ),
                          ],),

                          CustomButton(
                            buttonText: 'detail'.tr,
                            width: 120,
                            height: 40,
                            icon: Icons.event_note_outlined,
                            onPressed: () => Get.to(()=> BillScreen(quoteId: quote.id)),
                          ),
                        ],
                      ),
                    ],
                ),
              ),

              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            ],),),

          Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),
        ],);
      }),
    );
  }
}
