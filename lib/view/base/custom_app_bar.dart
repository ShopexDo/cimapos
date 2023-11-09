import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/menu_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_ink_well.dart';
import 'package:six_pos/view/screens/dashboard/nav_bar_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  CustomAppBar({this.isBackButtonExist = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      titleSpacing: 0, elevation: 5,
      leadingWidth: isBackButtonExist?50:120,
      leading: isBackButtonExist ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        child: CustomInkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_sharp, color: Theme.of(context).primaryColor, size: 25),) ,
      ) : Padding(
        padding: const EdgeInsets.only(left: Dimensions.FONT_SIZE_EXTRA_SMALL),
        child: InkWell(
            onTap: ()=>  Get.find<BottomMenuController>().selectHomePage(),
            child: Image.asset(Images.logo_with_name, width: 120, height: 30)),
      ),
      title:Text(''),
      actions: [
        GetBuilder<CartController>(
          builder: (cartController) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  Get.to(NavBarScreen());
                  Get.find<BottomMenuController>().selectPosScreen();
                },
                icon: Stack(clipBehavior: Clip.none, children: [
                  Image.asset(
                    Images.cart,
                    height: Dimensions.ICON_SIZE_DEFAULT,
                    width: Dimensions.ICON_SIZE_DEFAULT,
                    color: Theme.of(context).primaryColor,
                  ),
                  Positioned(top: -4, right: -4,
                    child: CircleAvatar(radius: 7, backgroundColor: Theme.of(context).secondaryHeaderColor,
                      child: Text('${cartController.customerCartList.isNotEmpty?cartController.customerCartList[cartController.customerIndex].cart.length : 0}', style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor,
                          fontSize: Dimensions.FONT_SIZE_SMALL)), ),
                  ),
                ],),
              ),
            );
          }
        ),

        Builder( builder: (context) {
          return IconButton( onPressed:()=> Scaffold.of(context).openEndDrawer(),
            icon: Icon(Icons.menu_outlined, color: Theme.of(context).primaryColor),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, GetPlatform.isDesktop ? 70 : 50);
}