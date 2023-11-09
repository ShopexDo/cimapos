import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/model/response/order_model.dart';
import 'package:six_pos/helper/date_converter.dart';
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/screens/order/invoice_screen.dart';
import 'package:six_pos/view/screens/user/widget/custom_divider.dart';
class OrderCardWidget extends StatelessWidget {
  final Orders order;
  const OrderCardWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [

      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text('${order.id}', style: fontSizeRegular.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: Dimensions.FONT_SIZE_LARGE,
          )),
          SizedBox(height: 5),

          Text('${DateConverter.dateTimeStringToMonthAndTime(order.createdAt)}',
            style: fontSizeRegular),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
            child: CustomDivider(color: Theme.of(context).hintColor),
          ),

          IntrinsicHeight(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('order_summary'.tr, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
                SizedBox(height: 5),

                Text(
                  '${'order_amount'.tr}: ${PriceConverter.priceWithSymbol(order.orderAmount) ?? 0}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                SizedBox(height: 5),

                Text(
                  '${'tax'.tr}: ${PriceConverter.priceWithSymbol(
                    double.tryParse(order.totalTax.toString()),
                  ) ?? 0}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                SizedBox(height: 5),

                Text(
                  '${'extra_discount'.tr}: ${PriceConverter.priceWithSymbol(double.parse(order.extraDiscount.toString())) ?? 0}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                SizedBox(height: 5),

                Text(
                  '${'coupon_discount'.tr}: ${PriceConverter.priceWithSymbol(
                    double.tryParse(order.couponDiscountAmount.toString()),
                  )}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                SizedBox(height: 5),

              ],),

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

                    Text(order.account != null ? order.account.account : 'customer balance',
                      style: fontSizeRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),
                  ],),

                  CustomButton(
                    buttonText: 'invoice'.tr,
                    width: 120,
                    height: 40,
                    icon: Icons.event_note_outlined,
                    onPressed: () => Get.to(()=> InVoiceScreen(orderId: order.id)),
                  ),
                ],),
            ],),),

          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        ],),),

      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),
    ],));
  }
}
