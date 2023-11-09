import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_category_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/screens/category/category_list_view_screen.dart';
import 'package:six_pos/view/screens/category/sub_category_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(1, reload: true);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .15 ;
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: Column(children: [


        CustomCategoryButton(buttonText: 'categories'.tr,icon: Images.categories,
            isSelected: false,isDrawer: false, padding: width,onTap: ()=> Get.to(CategoryListViewScreen()),
        ),

        CustomCategoryButton(buttonText: 'sub_categories'.tr,
          icon: Images.categories,isSelected: false,
          padding: width,isDrawer: false, onTap: () => Get.to(SubCategoryListViewScreen())),

      ],),
    );
  }
}
