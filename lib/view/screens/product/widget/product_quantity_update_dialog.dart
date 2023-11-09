import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class ProductQuantityUpdateDialog extends StatelessWidget {
  final Function onYesPressed;
  const ProductQuantityUpdateDialog({Key key, @required this.onYesPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
        child: GetBuilder<ProductController>(
          builder: (productController) {
            return Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
              height: 230,
              child: Column(children: [

                CustomFieldWithTitle(
                  customTextField: CustomTextField(hintText: 'product_quantity_hint'.tr,
                      controller: productController.productQuantityController
                  ),
                  title: 'update_product_quantity'.tr,
                  requiredField: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Container(height: 40,
                    child: Row(children: [
                      Expanded(child: CustomButton(buttonText: 'cancel'.tr,
                          buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                          onPressed: ()=>Get.back())),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                      Expanded(child: CustomButton(buttonText: 'yes'.tr,onPressed: (){
                        String quantity = productController.productQuantityController.text;
                        if(quantity.isEmpty){
                          showCustomSnackBar('quantity_cant_empty'.tr);
                        }else if(int.parse(quantity)< 1){
                          showCustomSnackBar('quantity_should_be_greater_than_0'.tr);
                        }
                          else{
                          onYesPressed();
                          Get.back();
                        }

                      },)),
                    ],),
                  ),
                )

              ],),
            );
          }
        ));
  }
}
