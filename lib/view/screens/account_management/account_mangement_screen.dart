import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_category_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/screens/account_management/account_list_screen.dart';
import 'package:six_pos/view/screens/account_management/add_account_screen.dart';
import 'package:six_pos/view/screens/account_management/add_new_expense_screen.dart';
import 'package:six_pos/view/screens/account_management/add_new_transfer_screen.dart';
import 'package:six_pos/view/screens/account_management/transaction_list_screen.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: ListView(children: [

        CustomCategoryButton(
          buttonText: 'account_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> AccountListScreen(fromAccount: true,)),
        ),

        CustomCategoryButton(
          buttonText: 'add_account'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddAccountScreen()),
        ),

        CustomCategoryButton(
          buttonText: 'expense_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> AccountListScreen()),
        ),

        CustomCategoryButton(
          buttonText: 'add_new_expanse'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddNewExpenseScreen()),
        ),

        CustomCategoryButton(
          buttonText: 'income_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> AccountListScreen(isIncome: true)),
        ),

        CustomCategoryButton(
          buttonText: 'add_new_income'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddNewExpenseScreen(fromIncome: true,)),
        ),

        CustomCategoryButton(
          buttonText: 'add_new_transfer'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: _width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> AddNewTransferScreen()),
        ),

        CustomCategoryButton(
          buttonText: 'transaction_list'.tr,
          icon: Images.categories,
          isSelected: false,
          isDrawer: false,
          padding: _width,
          onTap: ()=> Get.to(()=> TransactionListScreen()),
        ),

      ]),

    );
  }
}
