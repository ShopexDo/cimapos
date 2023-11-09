import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/coupon_controller.dart';
import 'package:six_pos/data/model/response/coupon_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';


class SearchedCouponItemWidget extends StatelessWidget {
  final Coupons coupon;
  const SearchedCouponItemWidget({Key key, this.coupon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<CouponController>(
          builder: (couponController) {
            return Container(child: Row(children: [
              Text('${'coupon_title'.tr} : ${coupon.title}', style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                maxLines: 1,overflow: TextOverflow.ellipsis,),
              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
              Expanded(child: Text('${'coupon_code'.tr} : ${coupon.couponCode}', style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                maxLines: 1,overflow: TextOverflow.ellipsis,))
            ]));
          }
      ),
    );
  }
}
