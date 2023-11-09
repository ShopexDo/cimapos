import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/body/place_order_body.dart';
import 'package:six_pos/data/model/body/place_bill_body.dart';
import 'package:six_pos/data/model/body/place_quote_body.dart' as quote;
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/data/model/response/cart_model.dart';
import 'package:six_pos/data/model/response/temporary_cart_for_customer.dart' as customer;
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_divider.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/view/screens/pos/widget/cart_pricing_widget.dart';
import 'package:six_pos/view/screens/pos/widget/confirm_purchase_dialog.dart';
import 'package:six_pos/view/screens/pos/widget/confirm_quote_dialog.dart';
import 'package:six_pos/view/screens/pos/widget/coupon_apply_widget.dart';
import 'package:six_pos/view/screens/pos/widget/customer_search_dialog.dart';
// import 'package:six_pos/view/screens/pos/widget/extra_discount_and_coupon_dialog.dart';
import 'package:six_pos/view/screens/pos/widget/extra_discount_dialog.dart';
import 'package:six_pos/view/screens/pos/widget/item_card_widget.dart';
import 'package:six_pos/view/screens/user/add_new_suppliers_and_customers.dart';
import 'package:flutter/scheduler.dart';


class PosScreen extends StatefulWidget {
  final bool fromMenu;
  final int quoteId;
  final double quoteAmount;
  final double totalTax;
  final int customerId;
  final String customerName;
  final String customerPhone;
  const PosScreen({Key key, this.fromMenu = false, this.quoteId, this.quoteAmount, this.totalTax, this.customerId, this.customerName, this.customerPhone}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final ScrollController _scrollController = ScrollController();
  double subTotal = 0, productDiscount = 0, total = 0, payable = 0, couponAmount = 0, extraDiscount = 0, productTax = 0, xxDiscount = 0, totalGeneralTax = 0;


  int userId = 0;
  String customerName = '';

  @override
  void initState() {
    super.initState();
    Get.find<CartController>().collectedCashController.text = '0';
    Get.find<CartController>().extraDiscountController.text = '0';
    if(Get.find<CartController>().customerSelectedName == ''){
      Get.find<CartController>().searchCustomerController.text = '';
      // Get.find<CartController>().setCustomerInfo( 0,  'walking customer', 'NULL', true);
    }
     
    double parametroDouble = widget.quoteAmount ?? 0.0;
    // total = parametroDouble;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.find<CartController>().setAmount(parametroDouble);
      Get.find<CartController>().setExtraDiscount();
      Get.find<CartController>().setReturnAmountToZero();
      Get.find<CartController>().setCustomerInfo(widget.customerId, widget.customerName, widget.customerPhone, 0.0, true);
    });
  }

  @override
  Widget build(BuildContext context) {


    var rng = Random();
    for (var i = 0; i < 10; i++) {
      print(rng.nextInt(10000));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),resizeToAvoidBottomInset: false,
      // appBar: widget.fromMenu? CustomAppBar():null,
      body: Container(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            return true;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: GetBuilder<CartController>(
                builder: (cartController) {

                  productDiscount = 0;
                  total = 0;
                  productTax = 0;
                  totalGeneralTax = widget.totalTax;
                  subTotal = widget.quoteAmount;
                  // if(cartController.customerCartList.isNotEmpty){
                  //   subTotal = cartController.amount;
                  //   for(int i=0; i< cartController.customerCartList[cartController.customerIndex].cart.length; i++ ){
                  //     productDiscount  = cartController.customerCartList[cartController.customerIndex].cart[i].product.discountType == 'amount'?
                  //     productDiscount + (cartController.customerCartList[cartController.customerIndex].cart[i].product.discount) * (cartController.customerCartList[cartController.customerIndex].cart[i].quantity) :
                  //     productDiscount + (((cartController.customerCartList[cartController.customerIndex].cart[i].product.discount/100)*
                  //         cartController.customerCartList[cartController.customerIndex].cart[i].product.sellingPrice)) * (cartController.customerCartList[cartController.customerIndex].cart[i].quantity);
                  //     productTax = productTax + (((cartController.customerCartList[cartController.customerIndex].cart[i].product.tax/100)*
                  //         cartController.customerCartList[cartController.customerIndex].cart[i].product.sellingPrice)) * (cartController.customerCartList[cartController.customerIndex].cart[i].quantity);

                  //   }
                  // }


                  // if( cartController.customerCartList.isNotEmpty){
                  //   couponAmount = cartController.customerCartList[cartController.customerIndex].couponAmount?? 0;
                  //   xxDiscount = cartController.customerCartList[cartController.customerIndex].extraDiscount?? 0;
                  // }

                  xxDiscount = cartController.extraDiscountAmount;
                  extraDiscount =  double.parse(PriceConverter.discountCalculationWithOutSymbol(context, subTotal, xxDiscount, cartController.selectedDiscountType));
                  total = subTotal - productDiscount - couponAmount - extraDiscount + totalGeneralTax;
                  payable = total;

                  return Column(children: [
                    CustomHeader(title: 'billing_section'.tr, headerImage: Images.billing_section),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    GetBuilder<CartController>(
                      builder: (customerController) {

                        return Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: customerController.searchCustomerController,
                                        onChanged: (value){
                                          customerController.searchCustomer(value);
                                        },
                                        suffixIcon: Images.search_icon,
                                        suffix: true,
                                        hintText: 'Buscar..',
                                      ),
                                    ),

                                  ],
                                ),

                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Stack(
                                children: [
                                  CustomButton(buttonText: 'add_customer'.tr,
                                    buttonColor: Theme.of(context).secondaryHeaderColor,
                                    onPressed: ()=> Get.to(()=> AddNewSuppliersOrCustomer(isCustomer: true,)),),

                                  CustomerSearchDialog(),
                                ],
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              // CustomButton(buttonText: 'new_order'.tr,
                              //   onPressed: (){
                              //   String customerId = '${customerController.customerId}';
                              //   customer.TemporaryCartListModel customerCart = customer.TemporaryCartListModel(
                              //     cart: [],
                              //     userIndex: customerId != '0' ?  int.parse(customerId) : rng.nextInt(10000),
                              //     userId: customerId != '0' ?  int.parse(customerId) : int.parse(customerId),
                              //     customerName: customerId == '0'? 'wc-${rng.nextInt(10000)}':'${customerController.customerSelectedName} ${customerController.customerSelectedMobile}',
                              //     customerBalance: customerController.customerBalance,
                              //   );
                              //    Get.find<CartController>().addToCartListForUser(customerCart, clear: true);

                              //   },),

                            ],)),
                            // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Expanded(child: Column(children: [
                              Text('${'current_customer_status'.tr} :', style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),

                              customerController.customerCartList != null?
                              Container(height: 50,child: Column(children: [

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  // child: Text('${customerController.customerSelectedName??''}',
                                  //   style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                                  child: Text(
                                    '${customerController.customerSelectedName ?? ''}',
                                    style: TextStyle(
                                      fontSize: 12, // Cambia el tamaño de fuente a 18
                                      color: Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ),
                                ),



                                // Text('${customerController.customerSelectedMobile != 'NULL'? customerController.customerSelectedMobile??'':''}',
                                //   style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                                Text(
                                  '${customerController.customerSelectedMobile != 'NULL' ? customerController.customerSelectedMobile ?? '' : ''}',
                                  style: TextStyle(
                                    fontSize: 12, // Cambia el tamaño de fuente a 16
                                    color: Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ])):SizedBox(),


                              // SizedBox(height: Dimensions.PADDING_SIZE_CUSTOMER_BOTTOM),
                              // CustomButton(buttonText: 'clear_all_cart'.tr,textColor: Theme.of(context).primaryColor,isClear: true,
                              // buttonColor: Theme.of(context).hintColor,
                              // onPressed: (){
                              //   Get.find<CartController>().removeAllCartList();
                              // }),
                            ],)),
                          ],),);
                      }
                    ),
                    // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),


                    // GetBuilder<CartController>(
                    //     builder: (customerCartController) {
                    //       return customerCartController.customerCartList.length > 0 ?
                    //       Padding(
                    //         padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                    //         child: Container(
                    //           height: 50,
                    //           padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                    //           decoration: BoxDecoration(color: Theme.of(context).cardColor,
                    //               border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                    //               borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                    //           child: DropdownButton<int>(
                    //             value: customerCartController.customerIds[cartController.customerIndex],
                    //             items: customerCartController.customerIds.map((int value) {
                    //               print('mono=======------${customerCartController.customerIds}/$value/${customerCartController.customerIndex}');
                    //               return DropdownMenuItem<int>(
                    //                   value: value,
                    //                   child:  Text(customerCartController.customerCartList[(customerCartController.customerIds.indexOf(value))].customerName??'',
                    //                     style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                    //               );
                    //             }).toList(),
                    //             onChanged: (int value) async {
                    //               //print('--id---${Get.find<CustomerController>().customerList[(customerCartController.customerIds.indexOf(value))].id}');
                    //               await customerCartController.setCustomerIndex(cartController.customerIds.indexOf(value), true);
                    //               customerCartController.setCustomerInfo(customerCartController.customerCartList[customerCartController.customerIndex].userId,
                    //                   customerCartController.customerCartList[(customerCartController.customerIndex)].customerName, '',
                    //                   customerCartController.customerCartList[(customerCartController.customerIndex)].customerBalance, true);
                    //               Get.find<TransactionController>().addCustomerBalanceIntoAccountList(Accounts(id: 0, account: 'customer_balance'.tr));
                    //               Get.find<TransactionController>().setAccountIndex(1,'from', true);
                    //               customerCartController.getReturnAmount(payable);



                    //             },
                    //             isExpanded: true, underline: SizedBox(),),),
                    //       ):SizedBox();
                    //     }
                    // ),

                    // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                    // Container(
                    //   padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).primaryColor.withOpacity(.06),
                    //   ),
                    //   child: Row(children: [

                    //     Expanded(
                    //         flex:6,
                    //         child: Text('item_info'.tr)),
                    //     Expanded(
                    //         flex:2,
                    //         child: Text('qty'.tr)),
                    //     Expanded(
                    //         flex:2,
                    //         child: Text('price'.tr)),


                    //   ],),
                    // ),
                    // cartController.customerCartList.length > 0 ? GetBuilder<CartController>(builder: (custController) {
                    //   return ListView.builder(
                    //       itemCount: cartController.customerCartList[custController.customerIndex].cart.length,
                    //       shrinkWrap: true,
                    //       physics: NeverScrollableScrollPhysics(),
                    //       itemBuilder: (itemContext, index){
                    //         return ItemCartWidget(cartModel: cartController.customerCartList[custController.customerIndex].cart[index], index:  index);
                    //       });
                    // }) : SizedBox(),


                    Container(child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.FONT_SIZE_DEFAULT),
                        child: Row(children: [
                          Expanded(child: Text('bill_summery'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),)),
                          Container(width: 120,height: 40,child: CustomButton(buttonText: 'edit_discount'.tr,onPressed: (){
                            showAnimatedDialog(context,
                                ExtraDiscountDialog(),
                                dismissible: false,
                                isFlip: false);
                          },)),
                        ],),
                      ),
                      PricingWidget(title: 'subtotal'.tr, amount: '${PriceConverter.priceWithSymbol(subTotal)}'),
                      PricingWidget(title: 'product_discount'.tr, amount: '${PriceConverter.priceWithSymbol(productDiscount)}'),
                      // PricingWidget(title: 'coupon_discount'.tr, amount: '${PriceConverter.priceWithSymbol(couponAmount)}',isCoupon: true,onTap: (){
                      //   showAnimatedDialog(context,
                      //       CouponDialog(),
                      //       dismissible: false,
                      //       isFlip: false);
                      // },),
                      PricingWidget(title: 'extra_discount'.tr, amount: '${PriceConverter.discountCalculation(context,
                          subTotal,
                          cartController.extraDiscountAmount,
                          cartController.selectedDiscountType)}'),
                      PricingWidget(title: 'vat'.tr, amount: '${PriceConverter.priceWithSymbol(totalGeneralTax)}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: CustomDivider(height: .4,color: Theme.of(context).hintColor.withOpacity(1),),
                      ),

                      PricingWidget(title: 'total'.tr, amount: '${PriceConverter.priceWithSymbol(total)}',isTotal: true),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text('payment_via'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                      ),


                      GetBuilder<TransactionController>(
                          builder: (accountController) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                              child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

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
                                          child: Text(
                                          accountController.accountList[(accountController.fromAccountIds.indexOf(value))].account));}).toList(),
                                    onChanged: (int value) {
                                      accountController.setAccountIndex(value,'from', true);
                                      cartController.collectedCashController.clear();
                                      cartController.getReturnAmount(payable);
                                    },
                                    isExpanded: true, underline: SizedBox(),),),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              ],),),
                            );
                          }
                      ),

                      GetBuilder<TransactionController>(
                        builder: (transactionController) {
                          print('============xyz=========>${transactionController.selectedFromAccountId}');
                          return Container(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Expanded(
                                child: Text(transactionController.selectedFromAccountId == 0 ? 'customer_balance'.tr :
                                transactionController.selectedFromAccountId == 1 ?'collected_cash'.tr : 'transaction_reference'.tr,
                                    style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                              ),

                              Row(children: [
                                transactionController.selectedFromAccountId == 0 ? SizedBox():Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                GetBuilder<CartController>(
                                  builder: (customerController) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color:transactionController.selectedFromAccountId == 0 ? Theme.of(context).hintColor :
                                        Theme.of(context).secondaryHeaderColor, width: transactionController.selectedFromAccountId == 0 ? 0: 1),
                                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER),
                                      ),
                                      child: SizedBox(height:40,width:100,
                                        child: CustomTextField(hintText: 'balance_hint'.tr,
                                            isEnabled: transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0? false: true,
                                          controller: transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0 ? cartController.customerWalletController : cartController.collectedCashController,
                                          inputType: transactionController.selectedFromAccountId == 1?TextInputType.number: TextInputType.text,
                                          onChanged: (value){
                                          cartController.getReturnAmount(payable);
                                          },
                                        ),
                                      ),);
                                  }
                                )
                              ])
                            ],),
                          );
                        }
                      ),
                      GetBuilder<TransactionController>(
                        builder: (transactionController) {
                          return transactionController.selectedFromAccountId == 0 || transactionController.selectedFromAccountId == 1 ? Container(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,
                                Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Text(transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0? 'remaining_balance'.tr :
                              transactionController.selectedFromAccountId == 1 ?'returned_amount'.tr : '', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Text('${PriceConverter.priceWithSymbol(cartController.returnToCustomerAmount)}', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                              )
                            ],),
                          ):SizedBox();
                        }
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        child: CustomDivider(height: .4,color: Theme.of(context).hintColor.withOpacity(1),),
                      ),

                      GetBuilder<TransactionController>(
                        builder: (transactionController) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,
                                Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            height: 50,child: Row(children: [
                            Expanded(child: CustomButton(buttonText: 'cancel'.tr,isClear: true, textColor: Theme.of(context).primaryColor,
                              buttonColor: Theme.of(context).hintColor, onPressed: (){
                                subTotal = 0; productDiscount = 0; total = 0; payable = 0; couponAmount = 0; extraDiscount = 0; productTax = 0;
                                cartController.customerCartList[Get.find<CartController>().customerIndex].cart.clear();
                              cartController.removeAllCart();
                            },)),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                            // Expanded(child: CustomButton(buttonText: 'quote'.tr,
                            //   buttonColor: Theme.of(context).secondaryHeaderColor, onPressed: (){
                              
                            //   if(cartController.customerCartList[Get.find<CartController>().customerIndex].cart.isEmpty){
                            //     showCustomSnackBar('please_select_at_least_one_product'.tr);
                            //   }
                            //   // else if(transactionController.selectedFromAccountId == 1 && cartController.collectedCashController.text.trim().isEmpty){
                            //   //   showCustomSnackBar('please_pay_first'.tr);
                            //   // }else if(transactionController.selectedFromAccountId == 1 &&  double.parse(cartController.collectedCashController.text.trim()) < total){
                            //   //   showCustomSnackBar('please_pay_full_amount'.tr);
                            //   // }
                            //   else{
                            //     showAnimatedDialog(context,
                            //         ConfirmQuoteDialog(
                            //             onYesPressed: cartController.isLoading? null : () {
                            //               List<quote.Cart> carts = [];
                            //               productDiscount = 0;
                            //               productTax = 0;
                            //               for (int index = 0; index < cartController.customerCartList[cartController.customerIndex].cart.length; index++) {
                            //                 CartModel cart = cartController.customerCartList[cartController.customerIndex].cart[index];
                            //                 carts.add(quote.Cart(
                            //                   cart.product.id.toString(),
                            //                   cart.price.toString(),
                            //                   cart.product.discountType == 'amount'?
                            //                   productDiscount + cart.product.discount??0 : productDiscount + ((cart.product.discount/100)*cart.product.sellingPrice),
                            //                   cart.quantity,
                            //                   productTax + ((cart.product.tax/100) * cart.product.sellingPrice),
                            //                 ));
                            //               }

                            //               quote.PlaceQuoteBody _placeQuoteBody = quote.PlaceQuoteBody(
                            //                 cart: carts,
                            //                 couponDiscountAmount: cartController.couponCodeAmount,
                            //                 couponCode: cartController.couponController.text,
                            //                 orderAmount: cartController.amount,
                            //                 userId: cartController.customerId,
                            //                 // collectedCash: transactionController.selectedFromAccountId == 0? double.parse(cartController.customerWalletController.text.trim()) :
                            //                 // transactionController.selectedFromAccountId == 1?  double.parse(cartController.collectedCashController.text.trim()) :  0.0,
                            //                 collectedCash: 0.0,
                            //                 extraDiscountType: cartController.selectedDiscountType,
                            //                 extraDiscount: cartController.extraDiscountController.text.trim().isEmpty? 0.0 : double.parse(PriceConverter.discountCalculationWithOutSymbol(context, subTotal, cartController.extraDiscountAmount, cartController.selectedDiscountType)),
                            //                 returnedAmount: cartController.returnToCustomerAmount,
                            //                 type: Get.find<TransactionController>().selectedFromAccountId,
                            //                 transactionRef: transactionController.selectedFromAccountId != 0 && transactionController.selectedFromAccountId != 1 ? cartController.collectedCashController.text.trim():'',
                            //               );
                            //               if(!cartController.singleClick){
                            //                 cartController.placeQuote(_placeQuoteBody).then((value){
                            //                   if(value.isOk){
                            //                     couponAmount = 0;
                            //                     extraDiscount = 0;
                            //                   }
                            //                 });
                            //               }

                            //             }
                            //         ),
                            //         dismissible: false,
                            //         isFlip: false);
                            //   }
                            // },)),
                            // SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                            Expanded(child: CustomButton(buttonText: 'bill'.tr, onPressed: (){
                              print(cartController.extraDiscountAmount);
                              print(cartController.amount);
                              // if(cartController.customerCartList[Get.find<CartController>().customerIndex].cart.isEmpty){
                              //   showCustomSnackBar('please_select_at_least_one_product'.tr);
                              // }
                              if(transactionController.selectedFromAccountId == 1 && cartController.collectedCashController.text.trim().isEmpty){
                                showCustomSnackBar('please_pay_first'.tr);
                              }else if(transactionController.selectedFromAccountId == 1 &&  double.parse(cartController.collectedCashController.text.trim()) < total){
                                showCustomSnackBar('please_pay_full_amount'.tr);
                              }
                              else{
                                showAnimatedDialog(context,
                                    ConfirmPurchaseDialog(
                                        onYesPressed: cartController.isLoading? null : () {

                                          PlaceBillBody _placebillBody = PlaceBillBody(
                                            quoteId: widget.quoteId,
                                            couponDiscountAmount: cartController.couponCodeAmount,
                                            couponCode: cartController.couponController.text,
                                            orderAmount: cartController.amount,
                                            userId: cartController.customerId,
                                            collectedCash: transactionController.selectedFromAccountId == 0? double.parse(cartController.customerWalletController.text.trim()) :
                                            transactionController.selectedFromAccountId == 1?  double.parse(cartController.collectedCashController.text.trim()) :  0.0,
                                            extraDiscountType: cartController.selectedDiscountType,
                                            extraDiscount: cartController.extraDiscountController.text.trim().isEmpty? 0.0 : double.parse(PriceConverter.discountCalculationWithOutSymbol(context, subTotal, cartController.extraDiscountAmount, cartController.selectedDiscountType)),
                                            returnedAmount: cartController.returnToCustomerAmount,
                                            type: Get.find<TransactionController>().selectedFromAccountId,
                                            transactionRef: transactionController.selectedFromAccountId != 0 && transactionController.selectedFromAccountId != 1 ? cartController.collectedCashController.text.trim():'',
                                          );
                                          if(!cartController.singleClick){
                                            cartController.approvedQuote(_placebillBody).then((value){
                                              if(value.isOk){
                                                couponAmount = 0;
                                                extraDiscount = 0;
                                              }
                                            });
                                          }
                                        }
                                    ),
                                    dismissible: false,
                                    isFlip: false);
                              }
                            })),

                          ],),);
                        }
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_REVENUE_BOTTOM,),
                    ],),),
                  ],);
                }
              ) )
            ],
          ),
        ),
      ),
    );
  }
}


