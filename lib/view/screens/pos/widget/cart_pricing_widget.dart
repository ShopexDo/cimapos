import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
class PricingWidget extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;
  final bool isCoupon;
  final Function onTap;
  const PricingWidget({Key key, this.title, this.amount, this.isTotal = false, this.isCoupon = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,
          Dimensions.PADDING_SIZE_EXTRA_SMALL, Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Row(children: [

        Text(title, style: fontSizeRegular.copyWith(color: isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight: isTotal? FontWeight.w700: FontWeight.w500,
            fontSize: isTotal? Dimensions.FONT_SIZE_LARGE: Dimensions.PADDING_SIZE_DEFAULT),),
        Spacer(),
        isCoupon?
        InkWell(
          onTap: onTap,
            child: Icon(Icons.edit)):SizedBox(),

        Text(amount, style: fontSizeRegular.copyWith(color: isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight: isTotal? FontWeight.w700: FontWeight.w500,
            fontSize: isTotal? Dimensions.FONT_SIZE_LARGE: Dimensions.PADDING_SIZE_DEFAULT),),

      ],),
    );
  }
}