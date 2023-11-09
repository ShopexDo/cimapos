import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/unit_controller.dart';
import 'package:six_pos/data/model/response/unit_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/unit/widget/add_new_unit_screen.dart';
class UnitCardWidget extends StatelessWidget {
  final Units unit;
  const UnitCardWidget({Key key, this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_BORDER),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Row(children: [
          Expanded(child: Text(unit.unitType, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),


          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          InkWell(
            onTap: ()=> Get.to(AddNewUnit(unit: unit)),
            child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                child: Image.asset(Images.edit_icon)),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


          GetBuilder<UnitController>(
            builder: (unitController) {
              return InkWell(
                onTap: (){
                  showAnimatedDialog(context,
                      CustomDialog(
                        delete: true,
                        icon: Icons.exit_to_app_rounded, title: '',
                        description: 'are_you_sure_you_want_to_delete_unit'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue:() {
                          unitController.deleteUnit(unit.id);
                        },
                        onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                    child: Image.asset(Images.delete_icon)),
              );
            }
          ),


        ],),
      ),
    );
  }
}
