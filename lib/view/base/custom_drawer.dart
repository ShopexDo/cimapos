import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/menu_controller.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_category_button.dart';
import 'package:cimapos/view/base/sign_out_confirmation_dialog.dart';
import 'package:cimapos/view/screens/account_management/account_mangement_screen.dart';
import 'package:cimapos/view/screens/dashboard/nav_bar_screen.dart';
import 'package:cimapos/view/screens/langulage/change_language.dart';
import 'package:cimapos/view/screens/product_setup_screen/product_setup_menu_screen.dart';
import 'package:cimapos/view/screens/order/order_screen.dart';
import 'package:cimapos/view/screens/quote/quote_screen.dart';
import 'package:cimapos/view/screens/shop/shop_settings.dart';
import 'package:cimapos/view/screens/user/user_screen.dart';
import 'package:cimapos/view/screens/info/info_screen.dart';

import 'animated_custom_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Theme.of(context).cardColor,
      child: GetBuilder<SplashController>(
        builder: (configController) {
          return Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              height: 200,
              child: Column(children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top),
                Container(width: 80,height: 80, child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: FadeInImage.assetNetwork(
                      placeholder:  Images.placeholder,
                      height: 80, width: 80, fit: BoxFit.cover,
                      image: '${configController.baseUrls.shopImageUrl}/${ configController.profileModel != null ?configController.profileModel.image??'': ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                        height: 80, width: 80, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),),

                Text('${configController.profileModel.fName} ${configController.profileModel.lName}'.tr,
                  style: fontSizeRegular.copyWith(
                  color: Theme.of(context).cardColor,
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),),

                Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('${configController.profileModel.email}', style: fontSizeRegular.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),),
                ),
              ]),
            ),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
                CustomCategoryButton(
                  icon: Images.shop_setting_image,
                  buttonText: 'dashboard'.tr, onTap: (){
                    Get.back();
                    Get.to(()=> NavBarScreen());
                    Get.find<BottomMenuController>().selectHomePage();
                },
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.pos,
                  buttonText: 'pos_section'.tr, onTap: (){
                  Get.back();
                  Get.to(()=> NavBarScreen());
                  Get.find<BottomMenuController>().selectPosScreen();
                },
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.product_setup,
                  buttonText: 'product_setup'.tr, onTap: ()=> Get.to(()=> ProductSetupMenuScreen(isFromDrawer: true)),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.item,
                  buttonText: 'orders'.tr, onTap: ()=> Get.to(()=> OrderScreen(fromNavBar: false)),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.quote,
                  buttonText: 'quotes'.tr, onTap: ()=> Get.to(()=> QuoteScreen(fromNavBar: false)),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.account_management,
                  buttonText: 'accounts_management'.tr, onTap: ()=> Get.to(()=> AccountManagementScreen()),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.profile_place_holder,
                  buttonText: 'users'.tr, onTap: ()=> Get.to(()=> UserScreen()),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.shop_icon,
                  buttonText: 'shop_settings'.tr, onTap: ()=> Get.to(()=> ShopSettings()),
                ),
                Divider(height: 3, color: Theme.of(context).cardColor),

                CustomCategoryButton(
                  icon: Images.language_logo,
                  buttonText: 'change_language'.tr, onTap: ()=> Get.to(()=> ChooseLanguageScreen()),
                ),

                CustomCategoryButton(
                  icon: Images.info,
                  buttonText: 'info'.tr, onTap: ()=> Get.to(()=> InfoScreen()),
                ),

                CustomCategoryButton(
                  icon: Images.logout,
                  buttonText: 'log_out'.tr, onTap: () => showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true)),

              ]),
            ),
          ]);
        }
      ),
    );
  }
}
