import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/cart_controller.dart';
import 'package:cimapos/util/color_resources.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_field_with_title.dart';
import 'package:cimapos/view/base/custom_text_field.dart';
class ExtraDiscountAndCouponDialog extends StatelessWidget {
  const ExtraDiscountAndCouponDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: GetBuilder<CartController>(
        builder: (cartController) {
          return Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            height: 350,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [


              Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Text('extra_discount'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor)),
            ),

              GetBuilder<CartController>(
              builder: (cartController) {
                return Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('discount_type'.tr,
                      style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      ),
                      child: DropdownButton<String>(
                        value: cartController.discountTypeIndex == 0 ?'monto'  :  'porcentaje',
                        items: <String>['monto','porcentaje'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cartController.setSelectedDiscountType(value);
                          cartController.setDiscountTypeIndex(value == 'monto' ? 0 : 1, true);

                        },
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),
                  ]),
                );
              }
            ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              CustomFieldWithTitle(
              customTextField: CustomTextField(hintText: 'discount_hint'.tr,
                controller: cartController.extraDiscountController,
                inputType: TextInputType.number,
              ),
              title: 'discount_percentage'.tr,
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

                    cartController.applyCouponCodeAndExtraDiscount();
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
