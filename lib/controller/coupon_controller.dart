import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/coupon_model.dart';
import 'package:six_pos/data/repository/coupon_repo.dart';
import 'package:six_pos/data/model/response/response_model.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';

class CouponController extends GetxController implements GetxService{
  final CouponRepo couponRepo;
  CouponController({@required this.couponRepo});

  List<Coupons> _couponList = [];
  List<Coupons> get couponList => _couponList;
  int _couponListLength;
  int get couponListLength => _couponListLength;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isFirst = true;
  bool get isFirst => _isFirst;


  bool _isAdded = false;
  bool get isAdded => _isAdded;

  Future<void> getCouponListData( int offset, {bool reload = false}) async {
    if(reload){
      _couponList = [];
    }
    _isLoading = true;
    Response response = await couponRepo.getCouponList(offset);
    if(response.statusCode == 200) {
      _couponList.addAll(CouponModel.fromJson(response.body).coupons);
      _couponListLength = CouponModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> deleteCoupon( int couponId) async {
    _isLoading = true;
    Response response = await couponRepo.deleteCoupon(couponId);
    if(response.statusCode == 200) {
      _isLoading = false;
      getCouponListData(1, reload: true);
      Get.back();
      showCustomSnackBar('coupon_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> toggleCouponStatus(int couponId, int status, int index) async {
    Response response = await couponRepo.toggleCouponStatus(couponId, status);
    if(response.statusCode == 200){
      _couponList[index].status = status;
      showCustomSnackBar('coupon_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  int _dropDownPosition = 0;
  List<String> _dropDownValues =[];

  int get dropDownPosition => _dropDownPosition;
  List<String> get dropDownValues => _dropDownValues;

  Future<ResponseModel> addCoupon(Coupons coupon, bool isUpdate) async {
    _isAdded = true;
    update();
    Response response = await couponRepo.addNewCoupon(coupon, update: isUpdate);
    ResponseModel responseModel;
    if(response.statusCode == 200){
      getCouponListData(1, reload: true);
      Get.back();
      showCustomSnackBar(isUpdate? 'coupon_updated_successfully'.tr : 'coupon_added_successfully'.tr, isError: false);
      _isAdded = false;
    }else if(response.statusCode == 403){
      _isAdded = false;
      showCustomSnackBar('coupon_already_exist'.tr);
    }else{
      _isAdded = false;
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  void setDropDownPosition(int index){
    _dropDownPosition = index;
    update();
  }

  void getDropDownValues(){
    List<String> dropDownValues= [
      'Default',
      'Flash Deal',
    ];
    _dropDownValues = dropDownValues;
    update();
  }

  void setDate( String type, DateTime dateTime){
    if(type == 'start'){
      _startDate = dateTime;
    }else{
      _endDate = dateTime;
    }

  }

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  DateTime _startDate;
  DateTime _endDate;
  DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date;
      }else{
        _endDate = date;
      }
      if(date == null){
        print('Null');
      }
      update();
    });
  }


  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

}
