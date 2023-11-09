import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/brand_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/brand_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/brand/widget/add_new_brand_screen.dart';
class BrandCardWidget extends StatelessWidget {
  final Brands brand;
  const BrandCardWidget({Key key, this.brand}) : super(key: key);

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
                image: '${Get.find<SplashController>().baseUrls.brandImageUrl}/${brand.image}',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                  fit: BoxFit.cover,height: Dimensions.PRODUCT_IMAGE_SIZE,),
              ),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          Expanded(child: Text(brand.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),

          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          InkWell(
            onTap: ()=> Get.to(AddNewBrand(brand: brand,)),
            child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                child: Image.asset(Images.edit_icon)),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


          GetBuilder<BrandController>(
            builder: (brandController) {
              return InkWell(
                onTap: (){
                  showAnimatedDialog(context,
                      CustomDialog(
                        delete: true,
                        icon: Icons.exit_to_app_rounded, title: '',
                        description: 'are_you_sure_you_want_to_delete_brand'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue:() {
                          brandController.deleteBrand(brand.id);
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
