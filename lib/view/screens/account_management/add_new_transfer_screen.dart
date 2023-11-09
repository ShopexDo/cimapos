import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/transaction_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';


class AddNewTransferScreen extends StatefulWidget {
  const AddNewTransferScreen({Key key}) : super(key: key);

  @override
  State<AddNewTransferScreen> createState() => _AddNewTransferScreenState();
}

class _AddNewTransferScreenState extends State<AddNewTransferScreen> {


  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController transferDateController = TextEditingController();


  FocusNode accountDescriptionNode = FocusNode();
  FocusNode accountBalanceNode = FocusNode();
  FocusNode accountNumberNode = FocusNode();

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2022, 1),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          transferDateController.text = formattedDate;

        });
      }
    }
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: GetBuilder<TransactionController>(
          builder: (transactionController) {
            return SingleChildScrollView(
              child: Column(children: [
                CustomHeader(title: 'add_new_transfer'.tr, headerImage: Images.coupon),

                Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                    child: Container(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          children: [
                            Text('account_from'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                            Text(' *', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                          ],
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor,
                              border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                          child: DropdownButton<int>(

                            value: transactionController.fromAccountIndex,
                            items: transactionController.fromAccountIds.map((int value) {
                              return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text( value != 0?
                                  transactionController.accountList[(transactionController.fromAccountIds.indexOf(value))].account: 'select'.tr ));}).toList(),
                            onChanged: (int value) {
                              transactionController.setAccountIndex(value,'from', true);
                            },
                            isExpanded: true, underline: SizedBox(),),),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      ],),),
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                    child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        children: [
                          Text('account_to'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                          Text(' *', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                            border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                        child: DropdownButton<int>(

                          value: transactionController.toAccountIndex,
                          items: transactionController.toAccountIds.map((int value) {
                            return DropdownMenuItem<int>(
                                value: value,
                                child: Text( value != 0?
                                transactionController.accountList[(transactionController.toAccountIds.indexOf(value))].account: 'select'.tr ));}).toList(),
                          onChanged: (int value) {
                            transactionController.setAccountIndex(value,'to', true);
                          },
                          isExpanded: true, underline: SizedBox(),),),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    ],),),
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                      hintText: 'description'.tr,
                      controller: expenseDescriptionController,
                      inputAction: TextInputAction.next,
                      focusNode: accountDescriptionNode,
                      nextFocus: accountBalanceNode,),
                    title: 'description'.tr,
                    requiredField: true,
                  ),



                  CustomFieldWithTitle(
                    customTextField: CustomTextField(
                        hintText: 'init_balance_hint'.tr,
                        controller: expenseAmountController,
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number),
                    title: 'amount'.tr,
                    requiredField: true,
                  ),

                  InkWell(
                    onTap: ()=> _selectDate(context),
                    child: CustomFieldWithTitle(
                      customTextField: CustomTextField(
                        hintText: '2022-05-17'.tr,
                        controller: transferDateController,
                        suffix: true,
                        suffixIcon: Images.calender,
                        isEnabled: false,
                        inputAction: TextInputAction.done,

                      ),
                      title: 'date'.tr,
                      requiredField: true,
                    ),
                  ),
                ]),

                transactionController.isLoading?
                Container(height: 30,width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(buttonText: 'save'.tr,onPressed: (){


                    print('');

                    String description = expenseDescriptionController.text.trim();
                    String balance = expenseAmountController.text.trim();
                    String expenseDate = transferDateController.text.toString();
                    int fromAccountId = transactionController.selectedFromAccountId;
                    int toAccountId = transactionController.selectedToAccountId;


                    if(description.isEmpty){
                      showCustomSnackBar('expense_description_required'.tr);
                    }else if(fromAccountId == toAccountId){
                      showCustomSnackBar('cant_transfer_same_account'.tr);
                    }else if(balance.isEmpty){
                      showCustomSnackBar('expense_balance_required'.tr);
                    }else if(expenseDate.isEmpty){
                      showCustomSnackBar('expense_date_required'.tr);
                    }else{
                      Transfers transfer = Transfers(
                        description:  description,
                        amount: double.parse(balance),
                        date: expenseDate,
                      );
                      transactionController.addTransaction(transfer, fromAccountId, toAccountId);

                    }


                  },),
                ),
              ]),
            );
          }
      ),
    );
  }
}
