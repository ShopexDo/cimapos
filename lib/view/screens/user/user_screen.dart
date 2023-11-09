import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_category_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/screens/user/supplier_or_customer_list.dart';
import 'package:six_pos/view/screens/user/add_new_suppliers_and_customers.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: ListView(children: [

        CustomCategoryButton(
          buttonText: 'supplier_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> SupplierOrCustomerList()),
        ),

        CustomCategoryButton(
          buttonText: 'add_new_supplier'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddNewSuppliersOrCustomer()),
        ),

        CustomCategoryButton(
          buttonText: 'customer_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> SupplierOrCustomerList(isCustomer: true)),
        ),

        CustomCategoryButton(
          buttonText: 'add_new_customer'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddNewSuppliersOrCustomer( isCustomer: true,)),
        ),


      ]),

    );
  }
}
