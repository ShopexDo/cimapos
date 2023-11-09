
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_category_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/screens/coupon/add_coupon_screen.dart';
import 'package:six_pos/view/screens/coupon/coupon_list_screen.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .12;
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Column(children: [

        InkWell(
          onTap: () => Get.to(() => CouponListScreen()),
          child: CustomCategoryButton(
            padding: width,
            buttonText: 'coupon_list'.tr,
            icon: Images.coupon_list_icon,
          ),
        ),

        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        InkWell(
          onTap: () => Get.to(() => AddCouponScreen()),
          child: CustomCategoryButton(
            padding: width,
            buttonText: 'add_new_coupon'.tr,
            icon: Images.add_category_icon,
          ),
        ),

    ],),);
  }
}
