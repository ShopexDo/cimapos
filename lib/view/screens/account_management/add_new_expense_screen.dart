import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/controller/expense_controller.dart';
import 'package:six_pos/controller/income_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/expenseModel.dart';
import 'package:six_pos/data/model/response/income_model.dart';
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


class AddNewExpenseScreen extends StatefulWidget {
  final bool fromIncome;
  final Expenses expense;
  const AddNewExpenseScreen({Key key, this.expense, this.fromIncome = false}) : super(key: key);

  @override
  State<AddNewExpenseScreen> createState() => _AddNewExpenseScreenState();
}

class _AddNewExpenseScreenState extends State<AddNewExpenseScreen> {


  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseDateController = TextEditingController();


  FocusNode accountDescriptionNode = FocusNode();
  FocusNode accountBalanceNode = FocusNode();
  FocusNode accountNumberNode = FocusNode();

  bool update;
  @override
  void initState() {
    super.initState();
    update = widget.expense !=null;
    if(update){
      expenseDescriptionController.text = widget.expense.description;
      expenseAmountController.text = widget.expense.amount.toString();
      expenseDateController.text = widget.expense.date;
    }
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
          expenseDateController.text = formattedDate;

        });
      }
    }
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: GetBuilder<ExpenseController>(
          builder: (expenseController) {
            return Column(children: [
              CustomHeader(title: widget.fromIncome? 'add_income'.tr : 'add_expense'.tr, headerImage: Images.coupon),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    GetBuilder<TransactionController>(
                        builder: (accountController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(

                                  value: accountController.fromAccountIndex,
                                  items: accountController.fromAccountIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text( value != 0?
                                        accountController.accountList[(accountController.fromAccountIds.indexOf(value))].account: 'select'.tr ));}).toList(),
                                  onChanged: (int value) {
                                    accountController.setAccountIndex(value,'from', true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
                        }
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
                          controller: expenseDateController,
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
                ),
              ),

              expenseController.isLoading?
              Container(height: 30,width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                ),
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(buttonText:update? 'update'.tr : 'save'.tr,onPressed: (){
                  String description = expenseDescriptionController.text.trim();
                  String balance = expenseAmountController.text.trim();
                  String expenseDate = selectedDate.toString();
                  int accountIdNumber = Get.find<AccountController>().accountIndex;


                  if(description.isEmpty){
                    showCustomSnackBar('expense_description_required'.tr);
                  }else if(balance.isEmpty){
                    showCustomSnackBar('expense_balance_required'.tr);
                  }else if(double.parse(balance) < 0){
                    showCustomSnackBar('balance_should_be_greater_than_0'.tr);
                  }else if(expenseDate.isEmpty){
                    showCustomSnackBar('expense_date_required'.tr);
                  }else{


                    if(widget.fromIncome){
                      Incomes income = Incomes(
                        accountId: accountIdNumber,
                        description: description,
                        amount: double.parse(balance),
                        date: expenseDate
                      );
                      Get.find<IncomeController>().addIncome(income);
                    }else{
                      Expenses expense = Expenses(
                        id: update? widget.expense.id: null,
                        accountId: accountIdNumber,
                        description:  description,
                        amount: double.parse(balance),
                        date: expenseDate,
                      );
                      expenseController.addExpense(expense, update);
                    }

                  }


                },),
              ),
            ]);
          }
      ),
    );
  }
}
