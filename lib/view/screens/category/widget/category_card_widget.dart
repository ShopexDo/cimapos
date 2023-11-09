import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/category_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/category/widget/add_new_category.dart';
class CategoryCardWidget extends StatelessWidget {
  final Categories category;
  final int index;
  const CategoryCardWidget({Key key, this.category, this.index}) : super(key: key);

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
          Container(
            height: Dimensions.PRODUCT_IMAGE_SIZE,
            width: Dimensions.PRODUCT_IMAGE_SIZE,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder, fit: BoxFit.cover,
                height: Dimensions.PRODUCT_IMAGE_SIZE,
                image: '${Get.find<SplashController>().baseUrls.categoryImageUrl}/${category.image}',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                    fit: BoxFit.cover,height: Dimensions.PRODUCT_IMAGE_SIZE,),
              ),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          Expanded(child: Text(category.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),

          GetBuilder<CategoryController>(
            builder: (categoryController) {
              return Switch(
                  value: category.status == 1,
                  activeColor: ColorResources.primaryColor,
                  onChanged: (value) => categoryController.categoryStatusOnOff(category.id, category.status == 1? 0 : 1, index));
            }
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          InkWell(
            onTap: ()=> Get.to(AddNewCategory(category: category,)),
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
                        description: 'are_you_sure_you_want_to_delete_category'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue:() {
                          categoryController.deleteCategory(category.id);
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
