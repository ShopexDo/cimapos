import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/shop/widgets/info_field_view.dart';

class ShopSettings extends StatefulWidget {
  const ShopSettings({Key key}) : super(key: key);

  @override
  State<ShopSettings> createState() => _ShopSettingsState();
}

class _ShopSettingsState extends State<ShopSettings> with TickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<SplashController>().getTimeZoneList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),

      appBar: CustomAppBar(),

      body: GetBuilder<SplashController>(
        builder: (shopController) {
          return Column( children: [
            CustomHeader(title: 'shop_settings'.tr, headerImage: Images.shop_setting_image),
            Center(
              child: Container(
                width: 1170,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  controller: _tabController,
                  labelColor: Theme.of(context).secondaryHeaderColor,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).secondaryHeaderColor,
                  indicatorWeight: 3,
                  unselectedLabelStyle: fontSizeRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: fontSizeRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(text: 'general_info'.tr),
                    Tab(text: 'business_info'.tr),
                  ],
                ),
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                InfoFieldVIew(configModel: shopController.configModel,),
                InfoFieldVIew(isBusinessInfo: true, configModel: shopController.configModel,),
              ],
            )),
          ]);
        }
      ),
    );
  }
}

