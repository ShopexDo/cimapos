import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/supplier_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class SupplierNewPurchaseDialog extends StatefulWidget {
  final double dueAmount;
  final bool fromPay;
  final Suppliers supplier;
  const SupplierNewPurchaseDialog({Key key, this.fromPay = false, this.dueAmount, this.supplier}) : super(key: key);

  @override
  State<SupplierNewPurchaseDialog> createState() => _SupplierNewPurchaseDialogState();
}

class _SupplierNewPurchaseDialogState extends State<SupplierNewPurchaseDialog> {
  TextEditingController purchaseAmountController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.fromPay){
      purchaseAmountController.text = widget.dueAmount.toString();
    }else{

    }

  }




  @override
  Widget build(BuildContext context) {


    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: GetBuilder<SupplierController>(
          builder: (supplierController) {
            return Container(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              height: 310,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [

                Row(
                  children: [
                    Expanded(
                      child: CustomFieldWithTitle(
                        customTextField: CustomTextField(hintText: 'purchased_amount_hint'.tr,
                          controller:purchaseAmountController,
                          inputType: TextInputType.number,
                          isEnabled: widget.fromPay? false : true,
                        ),
                        title:widget.fromPay? 'total_due'.tr : 'purchased_amount'.tr,
                        requiredField: false,
                      ),
                    ),

                     Expanded(
                      child: CustomFieldWithTitle(
                        customTextField: CustomTextField(hintText: 'paid_amount_hint'.tr,
                          onChanged: (e){
                          dueAmountController.text = (double.parse(purchaseAmountController.text.toString()) - double.parse(paidAmountController.text.toString())).toString() ;
                          },
                          controller:paidAmountController,
                          inputType: TextInputType.number,

                        ),
                        title: 'paid_amount'.tr,
                        requiredField: false,

                      ),
                    ),
                  ],
                ),


                Row(
                  children: [
                    Container(width: 130,
                      child: CustomFieldWithTitle(
                        customTextField: CustomTextField(hintText: '0',
                          controller: dueAmountController,
                          isEnabled: false,
                        ),
                        title: widget.fromPay? 'remaining_due'.tr :'due_amount'.tr,
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
                                  Text('account_to'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
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

                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(children: [
                    Expanded(child: CustomButton(buttonText: 'cancel'.tr,
                        buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                        onPressed: ()=>Get.back())),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(child: CustomButton(buttonText: 'submit'.tr,onPressed: (){

                      String purchaseAmount = purchaseAmountController.text?? 0;
                      String paidAmount = paidAmountController.text?? 0;
                      String dueAmount = dueAmountController.text?? 0;

                      if(purchaseAmount.isEmpty ){
                        showCustomSnackBar('purchase_amount_cant_empty'.tr);
                      }else if(paidAmount.isEmpty){
                        showCustomSnackBar('pay_minimum_0'.tr);
                      }else if(double.parse(paidAmount) > double.parse(purchaseAmount)){
                        showCustomSnackBar('cant_pay_more_than_purchase_amount'.tr);
                      }else if(double.parse(purchaseAmount) < 0.0 ){
                        showCustomSnackBar('purchase_amount_cant_negative'.tr);
                      }else if(double.parse(paidAmount) < 0.0 ){
                        showCustomSnackBar('paid_amount_cant_negative'.tr);
                      }else{
                        widget.fromPay?
                        supplierController.supplierPayment(widget.supplier.id, widget.dueAmount, double.parse(paidAmount), double.parse(dueAmount), Get.find<TransactionController>().selectedFromAccountId):
                        supplierController.supplierNewPurchase(widget.supplier.id, double.parse(purchaseAmount), double.parse(paidAmount), double.parse(dueAmount), Get.find<TransactionController>().selectedFromAccountId);
                        // Get.back();
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
