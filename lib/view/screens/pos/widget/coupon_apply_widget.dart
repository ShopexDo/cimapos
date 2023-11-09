import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class CouponDialog extends StatelessWidget {
  const CouponDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: GetBuilder<CartController>(
          builder: (cartController) {
            return Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              height: 250,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Text('coupon'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                ),
                CustomFieldWithTitle(
                  customTextField: CustomTextField(hintText: 'coupon_code_hint'.tr,
                    controller:cartController.couponController,
                  ),
                  title: 'coupon_code'.tr,
                  requiredField: true,
                ),


                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(children: [
                    Expanded(child: CustomButton(buttonText: 'cancel'.tr,
                        buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                        onPressed: ()=>Get.back())),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(child: CustomButton(buttonText: 'apply'.tr,onPressed: (){
                      if(cartController.couponController.text.trim().isNotEmpty){
                        cartController.getCouponDiscount(cartController.couponController.text.trim(),Get.find<CustomerController>().customerList[(Get.find<CustomerController>().customerIds.indexOf(Get.find<CustomerController>().customerIndex))].id, cartController.amount  );
                      }

                      Get.back();
                    },)),
                  ],),
                )
              ],),);
          }
      ),
    );
  }
}
