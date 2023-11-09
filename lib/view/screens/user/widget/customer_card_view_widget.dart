import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/base/custom_ink_well.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/account_management/transaction_list_screen.dart';
import 'package:six_pos/view/screens/order/order_screen.dart';
import 'package:six_pos/view/screens/user/add_new_suppliers_and_customers.dart';
import 'package:six_pos/view/screens/user/widget/add_balance_dialog.dart';
import 'package:six_pos/view/screens/user/widget/custom_divider.dart';

class CustomerCardViewWidget extends StatelessWidget {
  final Customers customer;
  const CustomerCardViewWidget({Key key, this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),
        child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: [
          Row(
            children: [
              CustomImage(
                image: '${'https://test.6am.one/6pos/storage/app/public/customer'}/${customer.image}',
                width: 50, height: 50, fit: BoxFit.cover, placeholder: Images.profile_place_holder,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(customer.name),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text('${'total_orders'.tr} : ${customer.orderCount}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                    Text('${'balance'.tr} : ${customer.balance}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                ],),
              ),
              customer.id == 0? SizedBox():
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: CustomInkWell(child: Image.asset(Images.edit_icon, height: 30), onTap: () {
                  Get.to(AddNewSuppliersOrCustomer(customer: customer, isCustomer: true,));
                },),
              ),

              customer.id == 0? SizedBox():
              GetBuilder<CustomerController>(
                builder: (customerController) {
                  return CustomInkWell(child: Image.asset(Images.delete_icon, height: 30), onTap: () {
                    showAnimatedDialog(context,
                        CustomDialog(
                          delete: true,
                          icon: Icons.exit_to_app_rounded, title: '',
                          description: 'are_you_sure_you_want_to_delete_customer'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                          onTapTrue:() {
                            customerController.deleteCustomer(customer.id);
                          },
                          onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                        ),
                        dismissible: false,
                        isFlip: true);

                  },);
                }
              ),
            ],
          ),

          CustomDivider(color: Theme.of(context).hintColor),

          Row(children: [
            Container(child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding( padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Text('contact_information'.tr, style: fontSizeMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              ),

              Padding( padding: EdgeInsets.only(bottom: 2),
                child: Text(customer.email??'', style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                )),
              ),

              Padding( padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(customer.mobile, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                )),
              ),
            ],),),

            Spacer(),
            Container(child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
              InkWell(
                onTap: ()=> Get.to(TransactionListScreen(fromCustomer: true,customerId: customer.id)),
                child: Row(children: [
                  Text('${'transactions'.tr}', style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.item))
                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



              InkWell(
                onTap: ()=> Get.to(OrderScreen(isCustomer: true, customerId: customer.id)),
                child: Row(children: [
                  Text('${'orders'.tr}',style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.stock,color: Theme.of(context).secondaryHeaderColor,))
                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              customer.id != 0?
              InkWell(
                onTap: (){
                  showAnimatedDialog(context,
                      AddBalanceDialog(customer: customer,),
                      dismissible: false,
                      isFlip: false);
                },

                child: Row(children: [
                  Text('${'add_balance'.tr}',style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.dollar,color: Theme.of(context).primaryColor,))
                ],),
              ):SizedBox(),
            ],),)
          ],)
        ]),
      ),

    ],);
  }
}
