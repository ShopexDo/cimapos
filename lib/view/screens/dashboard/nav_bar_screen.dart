import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/controller/menu_controller.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/dashboard/widget/gradient_border.dart';


class NavBarScreen extends StatefulWidget {
  NavBarScreen({Key key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  void _loadData(){
    Get.find<CategoryController>().getCategoryList(1, reload: true);
    Get.find<SplashController>().getProfileData();
    Get.find<CustomerController>().getCustomerList(1, reload: true);
    Get.find<TransactionController>().getTransactionAccountList(1);
    Get.find<ProductController>().getLimitedStockProductList(1, reload: true);
    Get.find<AccountController>().getRevenueDataForChart(2022);
    Get.find<SplashController>().getDashboardRevenueData('overall');
    Get.find<AccountController>().getAccountList(1, reload: true);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: GetBuilder<BottomMenuController>(builder: (menuController) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar:  CustomAppBar(isBackButtonExist: false),
              backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              endDrawer: CustomDrawer(),
              body: PageStorage(bucket: bucket, child: menuController.currentScreen),
              floatingActionButton: UnicornOutlineButton(strokeWidth: 0, radius: 50,
                gradient: LinearGradient(colors: [ColorResources.gradientColor,
                  ColorResources.gradientColor.withOpacity(0.5),
                  ColorResources.secondaryColor.withOpacity(0.3),
                  ColorResources.gradientColor.withOpacity(0.05),
                  ColorResources.gradientColor.withOpacity(0),],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter),


                child: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, elevation: 1,
                  onPressed: (){
                  Get.find<CartController>().scanProductBarCode();
                  },


                    child: Padding(padding: const EdgeInsets.all(15.0),
                        child: Image.asset(Images.scanner)))),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Container(height: 60,
                decoration: BoxDecoration(color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.14),
                    blurRadius: 80, offset: const Offset(0, 20)),
                  BoxShadow(color: Theme.of(context).cardColor,
                      blurRadius: 0.5, offset: const Offset(0, 0)),],
              ),



                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customBottomItem(tap: () => menuController.selectHomePage(),
                      icon: menuController.currentTab == 0 ? Images.dashboard : Images.dashboard,
                      name: 'dashboard'.tr, selectIndex: 0,),
                    customBottomItem(tap: () => menuController.selectPosScreen(),
                      icon: menuController.currentTab == 1 ? Images.pos : Images.pos, name: 'pos'.tr, selectIndex: 1),
                    const SizedBox(height: 20, width: 20),
                    customBottomItem(tap: () => menuController.selectItemsScreen(),
                      icon: menuController.currentTab == 2 ? Images.item : Images.item, name: 'items'.tr, selectIndex: 2,
                    ),
                    customBottomItem(tap: () => menuController.selectStockOutProductList(),
                      icon: menuController.currentTab == 3 ? Images.stock : Images.stock, name: 'limited_stock'.tr, selectIndex: 3,
                    ),
                  ],
                ),
              ),
            );
          }),
        );


  }

  Future<bool> _onWillPop(BuildContext context) async {
    showAnimatedDialog(context,
        CustomDialog(
          icon: Icons.exit_to_app_rounded, title: 'exit'.tr,
          description: 'do_you_want_to_exit_the_app'.tr, onTapFalse:() => Navigator.of(context).pop(false),
          onTapTrue:() {
            SystemNavigator.pop();
            },
          onTapTrueText: 'yes'.tr, onTapFalseText: 'no'.tr,
        ),
        dismissible: false,
        isFlip: true);
    return true;
  }

  Widget customBottomItem({String icon, String name, VoidCallback tap, int selectIndex}) {
    return InkWell(onTap: tap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.NAVBAR_ICON_SIZE, width: Dimensions.NAVBAR_ICON_SIZE,
            child: Image.asset(icon, fit: BoxFit.contain, color: Get.find<BottomMenuController>().currentTab == selectIndex
                  ? Theme.of(context).primaryColor : ColorResources.nevDefaultColor,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(name, style: TextStyle(color: Get.find<BottomMenuController>().currentTab == selectIndex
              ? Theme.of(context).primaryColor : ColorResources.nevDefaultColor, fontSize: Dimensions.NAVBAR_FONT_SIZE, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}


