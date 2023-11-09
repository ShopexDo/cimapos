import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/theme_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_divider.dart';


class CustomerSearchDialog extends StatelessWidget {
  const CustomerSearchDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (searchCustomer){
      return searchCustomer.searchedCustomerList != null && searchCustomer.searchedCustomerList.length !=0?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: Container(
          height: 200,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 400],
                  spreadRadius: .5, blurRadius: 12, offset: Offset(3,5))]

          ),
          child: ListView.builder(
              itemCount: searchCustomer.searchedCustomerList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return GetBuilder<CartController>(
                  builder: (cart) {
                    return InkWell(
                      onTap: (){
                        searchCustomer.setCustomerInfo(searchCustomer.searchedCustomerList[index].id,
                            searchCustomer.searchedCustomerList[index].name,
                            searchCustomer.searchedCustomerList[index].mobile,
                            searchCustomer.searchedCustomerList[index].balance,
                            true);
                        searchCustomer.searchCustomerController.text = searchCustomer.searchedCustomerList[index].name;
                        cart.customerWalletController.text = searchCustomer.searchedCustomerList[index].balance.toString();
                        print('------customer wallet balance------${searchCustomer.searchedCustomerList[index].balance}');
                        Get.find<TransactionController>().addCustomerBalanceIntoAccountList(Accounts(id: 0, account: 'customer balance'));
                        //searchCustomer.setCustomerIndex(searchCustomer.searchedCustomerList[index].id, true);
                        searchCustomer.searchCustomer('xfbdhfdbgdfsbgsdfbgsgbsgfbsgbsfdgbsdgbsdgbsdf');

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${searchCustomer.searchedCustomerList[index].name}', style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                              SizedBox(height: Dimensions.PADDING_SIZE_MEDIUM_BORDER,),
                              CustomDivider(height: .5,color: Theme.of(context).hintColor),
                            ],
                          )),
                    );
                  }
                );

              }),
        ),
      ):SizedBox.shrink();
    });
  }
}
