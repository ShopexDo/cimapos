import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/coupon_controller.dart';
import 'package:six_pos/data/model/response/coupon_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_date_picker.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';

class AddCouponScreen extends StatefulWidget {
  final Coupons coupon;
  const AddCouponScreen({Key key, this.coupon}) : super(key: key);

  @override
  State<AddCouponScreen> createState() => _AddNewCouponScreenState();
}

class _AddNewCouponScreenState extends State<AddCouponScreen> {
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _couponCodeFocusNode = FocusNode();
  FocusNode _limitForSameUserFocusNode = FocusNode();
  FocusNode _minPurchaseFocusNode = FocusNode();
  FocusNode _maxPurchaseFocusNode = FocusNode();
  FocusNode _discountAmountFocusNode = FocusNode();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _couponCodeController = TextEditingController();
  TextEditingController _limitForSameUserController  = TextEditingController();
  TextEditingController _minPurchaseController = TextEditingController();
  TextEditingController _maxPurchaseController = TextEditingController();
  TextEditingController _discountAmountController = TextEditingController();
  bool update;
  String selectedCouponType, selectedDiscountType = 'Default';

  @override
  initState(){
    super.initState();
    update = widget.coupon != null;
    if(widget.coupon != null){
      print('======coupon title====>${widget.coupon.id}');
      _titleController.text = widget.coupon.title;
      _couponCodeController.text = widget.coupon.couponCode;
      _limitForSameUserController.text = widget.coupon.userLimit.toString();
      _minPurchaseController.text = widget.coupon.minPurchase.toString();
      _maxPurchaseController.text = widget.coupon.maxDiscount.toString();
      _discountAmountController .text = widget.coupon.discount.toString();
      selectedDiscountType = widget.coupon.discountType;
      selectedCouponType = widget.coupon.couponType;

      DateTime start =  DateTime.parse(widget.coupon.startDate);
      DateTime end =  DateTime.parse(widget.coupon.startDate);

      Get.find<CouponController>().setDate('start', start) ;
      Get.find<CouponController>().setDate('end', end) ;

      Get.find<CouponController>().setDiscountTypeIndex(widget.coupon.discountType == 'percent'? 0:1, false) ;



    }

  }

  @override
  void dispose(){
    _titleController.dispose();
    _couponCodeController.dispose();
    _limitForSameUserController.dispose();
    _minPurchaseController.dispose();
    _maxPurchaseController.dispose();
    _discountAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      body: GetBuilder<CouponController>(
        builder:(couponController) => Column(children: [

          CustomHeader(title: !update? 'add_coupon'.tr : 'update_coupon'.tr, headerImage: Images.coupon_list_icon),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [

                CustomFieldWithTitle(
                  title: 'title'.tr,
                  requiredField: true,
                  customTextField: CustomTextField(
                    hintText: 'new_year_discount'.tr,
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    nextFocus: _couponCodeFocusNode,
                    inputType: TextInputType.text,
                  ),
                ),

                CustomFieldWithTitle(
                  title: 'coupon_code'.tr,
                  requiredField: true,
                  customTextField: CustomTextField(
                    hintText: 'new_year'.tr,
                    controller: _couponCodeController,
                    focusNode: _couponCodeFocusNode,
                    inputType: TextInputType.text,
                  ),
                ),

              Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('coupon_type'.tr,
                    style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    ),
                    child: DropdownButton<String>(
                      value: couponController.dropDownPosition == 0 ? 'Default' : 'First order',
                      items: <String>['Default', 'First order'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        couponController.setDropDownPosition(value == 'Default' ? 0 : 1);
                        selectedCouponType = value;
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                ]),
              ),

                CustomFieldWithTitle(
                  title: 'limit_for_same_user'.tr,
                  requiredField: true,
                  customTextField: CustomTextField(
                    hintText: 'limit_user_hint'.tr,
                    controller: _limitForSameUserController,
                    focusNode: _limitForSameUserFocusNode,
                    inputType: TextInputType.number,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: CustomDatePicker(
                        title: 'start_date'.tr,
                        text: couponController.startDate != null ?
                        couponController.dateFormat.format(couponController.startDate).toString() : 'select_start_date'.tr,
                        image: Images.calender,
                        requiredField: true,
                        selectDate: () => couponController.selectDate("start", context),
                      ),
                    ),

                    Expanded(
                      child: CustomDatePicker(
                        title: 'end_date'.tr,
                        text: couponController.endDate != null ?
                        couponController.dateFormat.format(couponController.endDate).toString() : 'select_end_date'.tr,
                        image: Images.calender,
                        requiredField: true,
                        selectDate: () => couponController.selectDate("end", context),
                      ),
                    ),

                  ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: CustomFieldWithTitle(
                        title: 'min_purchase'.tr,
                        requiredField: true,
                        customTextField: CustomTextField(
                          hintText: 'min_purchase_hint'.tr,
                          controller: _minPurchaseController,
                          focusNode: _minPurchaseFocusNode,
                          nextFocus: _maxPurchaseFocusNode,
                          inputType: TextInputType.text,
                        ),
                      ),
                    ),

                    Expanded(
                      child: CustomFieldWithTitle(
                        title: 'max_discount'.tr,
                        requiredField: true,
                        customTextField: CustomTextField(
                          hintText: 'max_discount_hint'.tr,
                          controller: _maxPurchaseController,
                          focusNode: _maxPurchaseFocusNode,
                          inputType: TextInputType.text,
                        ),
                      ),
                    ),

                  ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('discount_type'.tr,
                            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            ),
                            child: DropdownButton<String>(
                              value: couponController.discountTypeIndex == 0 ? 'percent' : 'amount',
                              items: <String>['percent', 'amount'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                couponController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                                selectedDiscountType = value;
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    Expanded(
                      child: CustomFieldWithTitle(
                        title: 'discount_amount'.tr,
                        requiredField: true,
                        customTextField: CustomTextField(
                          hintText: 'discount_amount_hint'.tr,
                          controller: _discountAmountController,
                          focusNode: _discountAmountFocusNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.number,
                        ),
                      ),
                    ),

                  ],),
              ],),
            ),
          ),

          couponController.isAdded?
          Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width/2-30,
                    vertical: Dimensions.PADDING_SIZE_LARGE),
                child: Container(alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  width: 30,height: 30,child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),),
              ),
            ],
          ): CustomButton(
            margin: EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_DEFAULT,
              right: Dimensions.PADDING_SIZE_DEFAULT,
              bottom: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            buttonText: update? 'update'.tr : 'save'.tr,
            onPressed: (){
              String title = _titleController.text.trim();
              String couponCode = _couponCodeController.text.trim();
              String limitForSameUser = _limitForSameUserController.text.trim();
              String startDate = update? widget.coupon.startDate : couponController.dateFormat.format(couponController.startDate).toString();
              String endDate = update? widget.coupon.expireDate : couponController.dateFormat.format(couponController.endDate).toString();
              String minPurchase = _minPurchaseController.text.trim();
              String maxPurchase = _maxPurchaseController.text.trim();
              String discountAmount = _discountAmountController.text.trim();
              bool compare = couponController.startDate.isBefore(couponController.endDate) || couponController.startDate.isAtSameMomentAs(couponController.endDate);




              if(title.isEmpty){
                showCustomSnackBar('enter_title'.tr);
              }else if(couponCode.isEmpty){
                showCustomSnackBar('enter_coupon_code'.tr);
              }else if(limitForSameUser.isEmpty){
                showCustomSnackBar('enter_limit_for_user'.tr);
              }else if(int.parse(limitForSameUser) < 1){
                showCustomSnackBar('enter_minimum_1'.tr);
              }else if(startDate.isEmpty && startDate == null){
                showCustomSnackBar('enter_start_date'.tr);
              }else if(endDate.isEmpty && endDate == null){
                showCustomSnackBar('enter_end_date'.tr);
              }else if(!compare){
                showCustomSnackBar('select_valid_date_range'.tr);
              }else if(minPurchase.isEmpty){
                showCustomSnackBar('enter_min_purchase'.tr);
              }else if(maxPurchase.isEmpty){
                showCustomSnackBar('enter_max_discount_amount'.tr);
              }else if(discountAmount.isEmpty){
                showCustomSnackBar('enter_discount_amount'.tr);
              }else{
                Coupons coupon = Coupons(
                  id: update? widget.coupon.id: null,
                  title: title,
                  couponType: selectedCouponType,
                  userLimit: int.parse(limitForSameUser),
                  couponCode: couponCode,
                  startDate: startDate,
                  expireDate: endDate,
                  minPurchase: minPurchase,
                  maxDiscount: maxPurchase,
                  discount: discountAmount,
                  discountType: selectedDiscountType,
                );
                couponController.addCoupon(coupon, update);

              }


            },
          ),

        ],),
      ),);
  }
}
