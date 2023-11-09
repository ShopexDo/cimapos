import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/sub_category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/category/widget/add_new_sub_category.dart';
class SubCategoryCardWidget extends StatelessWidget {
  final SubCategories subCategory;
  const SubCategoryCardWidget({Key key, this.subCategory}) : super(key: key);

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

          Expanded(child: Text(subCategory.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),

          // GetBuilder<CategoryController>(
          //     builder: (categoryController) {
          //       return Switch(
          //           value: subCategory.status == 1,
          //           activeColor: ColorResources.primaryColor,
          //           onChanged: (value) => categoryController.subCategoryStatusOnOff(subCategory.id, subCategory.status == 1? 0 : 1 ));
          //     }
          // ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          InkWell(
            onTap: ()=> Get.to(AddNewSubCategory(subCategory: subCategory)),
            child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                child: Image.asset(Images.edit_icon)),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


          GetBuilder<CategoryController>(
            builder: (categoryController) {
              return InkWell(
                onTap: (){
                  showAnimatedDialog(context,
                      CustomDialog(
                        delete: true,
                        icon: Icons.exit_to_app_rounded, title: '',
                        description: 'are_you_sure_you_want_to_delete_sub_category'.tr, onTapFalse:() => Get.back(),
                        onTapTrue:() {
                          categoryController.deleteSubCategory(subCategory.id);
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
