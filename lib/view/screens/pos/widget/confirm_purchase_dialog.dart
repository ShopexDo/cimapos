import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_button.dart';
class ConfirmPurchaseDialog extends StatelessWidget {
  final Function onYesPressed;
  const ConfirmPurchaseDialog({Key key, @required this.onYesPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
        child: Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
        height: 210,
          child: Column(children: [
          Container(width: 70,height: 70,
            child: Image.asset(Images.confirm_purchase),),
          Text('confirm_purchase'.tr),
          Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Container(height: 40,
            child: Row(children: [
              Expanded(child: CustomButton(buttonText: 'cancel'.tr,
                  buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                  onPressed: ()=>Get.back())),
              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
              Expanded(child: CustomButton(buttonText: 'yes'.tr,onPressed: (){
                onYesPressed();
                Get.back();
              },)),
            ],),
          ),
        )

      ],),
    ));
  }
}
