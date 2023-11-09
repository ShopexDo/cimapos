import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/controller/cart_controller.dart';

class ConfirmBillDialog extends StatelessWidget {
  final Function onYesPressed;
  const ConfirmBillDialog({Key key, @required this.onYesPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
        child: Container(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
        height: 510,
          child: Column(children: [
          Container(width: 70,height: 70,
            child: Image.asset(Images.confirm_purchase),),
          Text('Realmente desea facturar esta cotización?'),
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
        // GetBuilder<CartController>(
        //   builder: (customerController) {
        //     return Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
        //       child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
        //         Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: [
        //                 Expanded(
        //                   child: CustomTextField(
        //                     controller: customerController.searchCustomerController,
        //                     onChanged: (value){
        //                       customerController.searchCustomer(value);
        //                     },
        //                     suffixIcon: Images.search_icon,
        //                     suffix: true,
        //                     hintText: 'Buscar..',
        //                   ),
        //                 ),

        //               ],
        //             ),
        //         ],)),
        //       ],),
        //     );
        //   }
        // ),
      ],),
    ));
  }
}
