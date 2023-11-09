import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_category_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/screens/brand/brand_screen.dart';
import 'package:six_pos/view/screens/category/category_screen.dart';
import 'package:six_pos/view/screens/coupon/coupon_screen.dart';
import 'package:six_pos/view/screens/product_setup_screen/product_setup_screen.dart';
import 'package:six_pos/view/screens/unit/unit_list_screen.dart';


class ProductSetupMenuScreen extends StatelessWidget {
  final bool isFromDrawer;
  const ProductSetupMenuScreen({Key key, this.isFromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .12;
    return Scaffold(
      appBar: isFromDrawer? CustomAppBar(): null,
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(children: [

          CustomCategoryButton(buttonText: 'categories'.tr,icon: Images.categories,
            isSelected: false,isDrawer: false, padding: width,onTap: ()=> Get.to(CategoryScreen()),
          ),

          CustomCategoryButton(buttonText: 'brands'.tr,
            icon: Images.brand,isSelected: false,
            onTap: ()=> Get.to(BrandListViewScreen()),
            padding: width,isDrawer: false,),

          CustomCategoryButton(buttonText: 'product_units'.tr,
            icon: Images.product_unit,isSelected: false,
            onTap: ()=> Get.to(UnitListViewScreen()),
            padding: width,isDrawer: false,),

          CustomCategoryButton(buttonText: 'product_setup'.tr,
            icon: Images.product_setup,isSelected: false,
            onTap: ()=>  Get.to(ProductSetupScreen()),
            padding: width,isDrawer: false,),

          CustomCategoryButton(buttonText: 'coupons'.tr,
            icon: Images.coupon,isSelected: false,
            onTap: ()=> Get.to(CouponScreen()),
            padding: width,isDrawer: false,)

        ],),
      ),
    );
  }
}
