
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/coupon_controller.dart';
import 'package:six_pos/data/model/response/coupon_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/coupon/add_coupon_screen.dart';

class CouponCardWidget extends StatelessWidget{
  final int index;
 final Coupons coupon;
 CouponCardWidget({this.coupon, this.index});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_MEDIUM_BORDER),
      child: Container(
        child: Stack(
          children: [
            Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_DEFAULT,
                Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                  Row(children: [
                    Text(coupon.title, style: fontSizeBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text("(" + "code".tr + ":" + "${coupon.couponCode})",
                      maxLines: 1,overflow: TextOverflow.ellipsis,
                      style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.primaryColor.withOpacity(0.8),),),

                  ],),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Text('discount_type'.tr + ' : ' + coupon.discountType,
                    style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.primaryColor.withOpacity(0.8))),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('validity'.tr + ' : ' + coupon.expireDate,
                        style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.primaryColor.withOpacity(0.8))),

                      Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                          GetBuilder<CouponController>(
                              builder: (couponController) => Switch(
                                  value: coupon.status == 1,
                                  activeColor: ColorResources.primaryColor,
                                  onChanged: (value) => couponController.toggleCouponStatus(coupon.id, coupon.status == 1? 0 : 1 ,index))),

                          InkWell(onTap: (){
                            Get.to(() => AddCouponScreen(coupon: coupon,));
                          },
                              child: Container(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
                                  width: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
                                  child: Image.asset(Images.edit_icon))),

                          GetBuilder<CouponController>(
                            builder: (couponController) {
                              return InkWell(onTap: (){
                                showAnimatedDialog(context,
                                    CustomDialog(
                                      delete: true,
                                      icon: Icons.exit_to_app_rounded, title: '',
                                      description: 'are_you_sure_you_want_to_delete_coupon'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                                      onTapTrue:() {
                                        couponController.deleteCoupon(coupon.id);
                                      },
                                      onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                                    ),
                                    dismissible: false,
                                    isFlip: true);
                              },
                                  child: Container(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                      width: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                      child: Image.asset(Images.delete_icon)));
                            }
                          ),

                        ],),),
                    ],
                  ),


                  Row(children: [
                    Text('min_purchase'.tr + ' : ' + coupon.minPurchase,
                      style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.primaryColor.withOpacity(0.8))),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text('max_discount'.tr + ' : ' + coupon.maxDiscount,
                      style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.primaryColor.withOpacity(0.8))),
                  ],),
                ],)),
              ],),
            ),
          ],
        )
      ),
    );
  }
}
