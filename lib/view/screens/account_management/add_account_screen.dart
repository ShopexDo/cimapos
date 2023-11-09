import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';

class AddAccountScreen extends StatefulWidget {
  final Accounts account;
  const AddAccountScreen({Key key, this.account}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {

  TextEditingController accountTitle = TextEditingController();
  TextEditingController accountDescription = TextEditingController();
  TextEditingController accountBalance = TextEditingController();
  TextEditingController accountNumber = TextEditingController();

  FocusNode accountTitleNode = FocusNode();
  FocusNode accountDescriptionNode = FocusNode();
  FocusNode accountBalanceNode = FocusNode();
  FocusNode accountNumberNode = FocusNode();


  bool update;
  @override
  void initState() {
    super.initState();
    update = widget.account != null;

    if(update){
      accountTitle.text = widget.account.account;
      accountDescription.text = widget.account.description;
      accountBalance.text = widget.account.balance.toString();
      accountNumber.text = widget.account.accountNumber;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: GetBuilder<AccountController>(
        builder: (accountController) {
          return Column(children: [
            CustomHeader(title: 'add_account'.tr, headerImage: Images.coupon),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                      hintText: 'ex_new_year_discount'.tr,
                        focusNode: accountTitleNode,
                        nextFocus: accountDescriptionNode,
                        inputAction: TextInputAction.next,
                        controller: accountTitle),
                    title: 'account_title'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                      hintText: 'description'.tr,
                      controller: accountDescription,
                      inputAction: TextInputAction.next,
                      focusNode: accountDescriptionNode,
                      nextFocus: accountBalanceNode,),
                    title: 'description'.tr,
                    requiredField: true,
                  ),



                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                        hintText: 'init_balance_hint'.tr,
                        controller: accountBalance,
                        inputAction: TextInputAction.next,
                        isEnabled: update? false : true,
                        inputType: TextInputType.number),
                    title: 'initial_balance'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                      hintText: 'acc_hint'.tr,
                      controller: accountNumber,
                      inputAction: TextInputAction.done,
                    ),
                    title: 'account_number'.tr,
                    requiredField: true,
                  ),
                ]),
              ),
            ),

            accountController.isLoading?
            Container(height: 30,width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).cardColor,
              ),
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(buttonText: update? 'update'.tr : 'save'.tr,onPressed: (){

                String title = accountTitle.text.trim();
                String description = accountDescription.text.trim();
                String balance = accountBalance.text.trim();
                String accountNum = accountNumber.text.trim();


                if(title.isEmpty){
                  showCustomSnackBar('account_title_required'.tr);
                }else if(description.isEmpty){
                  showCustomSnackBar('account_description_required'.tr);
                }else if(balance.isEmpty){
                  showCustomSnackBar('account_balance_required'.tr);
                }else if(double.parse(balance) < 0){
                  showCustomSnackBar('balance_should_be_greater_than_0'.tr);
                }
                else if(accountNum.isEmpty){
                  showCustomSnackBar('account_number_required'.tr);
                }else{
                  Accounts account =Accounts(
                    id: update? widget.account.id : null,
                    account: title,
                    description:  description,
                    balance: double.parse(balance),
                    accountNumber: accountNum,

                  );
                  accountController.addAccount(account,update);


                }


              },),
            ),
          ]);
        }
      ),
    );
  }
}
