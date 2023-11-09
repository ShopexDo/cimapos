import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_date_picker.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class AddBalanceDialog extends StatefulWidget {
  final Customers customer;
  const AddBalanceDialog({Key key, this.customer}) : super(key: key);

  @override
  State<AddBalanceDialog> createState() => _AddBalanceDialogState();
}

class _AddBalanceDialogState extends State<AddBalanceDialog> {
  TextEditingController addBalanceAmountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addBalanceDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: GetBuilder<CustomerController>(
          builder: (customerController) {
            return Container(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              height: 320,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [

                Row(
                  children: [
                    Expanded(
                      child: CustomFieldWithTitle(
                        customTextField: CustomTextField(hintText: 'balance_hint'.tr,
                          controller:addBalanceAmountController,
                          inputType: TextInputType.number,
                        ),
                        title: 'balance'.tr,
                        requiredField: false,
                      ),
                    ),

                    Expanded(
                      child: GetBuilder<TransactionController>(
                          builder: (transactionController) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                              child: Container(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('balance_receive_account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
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
                            );
                          }
                      ),
                    ),


                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomFieldWithTitle(
                        customTextField: CustomTextField(hintText: 'description_hint'.tr,
                          controller: descriptionController,
                        ),
                        title: 'description'.tr,
                        requiredField: false,
                      ),
                    ),

                    Expanded(
                      child: CustomDatePicker(
                        title: 'date'.tr,
                        text: customerController.startDate != null ?
                        customerController.dateFormat.format(customerController.startDate).toString() : 'select_start_date'.tr,
                        image: Images.calender,
                        selectDate: () => customerController.selectDate("start", context),
                      ),
                    ),


                  ],
                ),




                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(children: [
                    Expanded(child: CustomButton(buttonText: 'cancel'.tr,
                        buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                        onPressed: ()=>Get.back())),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(child: CustomButton(buttonText: 'submit'.tr,onPressed: (){

                      String addBalanceAmount = addBalanceAmountController.text;
                      String description = descriptionController.text;
                      String date = customerController.dateFormat.format(customerController.startDate).toString();
                      int accountId = Get.find<TransactionController>().fromAccountIndex;

                      if(addBalanceAmount.isEmpty ){
                        showCustomSnackBar('amount_cant_empty'.tr);
                      }else if(date.isEmpty ){
                        showCustomSnackBar('date_cant_empty'.tr);
                      }else{
                        customerController.updateCustomerBalance(widget.customer.id, accountId, double.parse(addBalanceAmount), date,description);
                      }


                    },)),
                  ],),
                )
              ],),);
          }
      ),
    );
  }
}


