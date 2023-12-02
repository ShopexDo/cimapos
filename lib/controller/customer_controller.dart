import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cimapos/controller/auth_controller.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/customer_model.dart';
import 'package:cimapos/data/model/response/order_model.dart';
import 'package:cimapos/data/repository/customer_repo.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class CustomerController extends GetxController implements GetxService{
  final CustomerRepo customerRepo;
  CustomerController({@required this.customerRepo});

  bool _isLoading = false;
  bool _isGetting = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;
  bool get isLoading => _isLoading;

  int _customerListLength;
  int get customerListLength => _customerListLength;


  List<Customers> _customerList = [];
  List<Customers> get customerList =>_customerList;

  List<Customers> _searchedCustomerList;
  List<Customers> get searchedCustomerList =>_searchedCustomerList;

  List<Orders> _customerWiseOrderList = [];
  List<Orders> get customerWiseOrderList =>_customerWiseOrderList;

  int _customerWiseOrderListLength;
  int get customerWiseOrderListLength => _customerWiseOrderListLength;



  int _customerIndex = 0;
  int get customerIndex => _customerIndex;

  List<int> _customerIds = [];
  List<int> get customerIds => _customerIds;
  int _offset = 1;
  int get offset => _offset;


  final picker = ImagePicker();
  XFile _customerImage;
  XFile get customerImage=> _customerImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _customerImage = null;
    }else {
      _customerImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }


  void setOffset(int offset) {
    _offset = _offset + 1;
  }


  Future<http.StreamedResponse> addCustomer(Customers customer, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await customerRepo.addCustomer(customer, _customerImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);

    print('===Response status===>${response.statusCode}');
    if(response.statusCode == 200) {
      _customerImage = null;
      getCustomerList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar(isUpdate ? 'customer_updated_successfully'.tr : 'customer_added_successfully'.tr, isError: false);

    }else {
      _isLoading = false;
      showCustomSnackBar(isUpdate ? 'customer_update_failed'.tr : 'customer_add_failed'.tr);

    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getCustomerList(int offset, {bool reload = false}) async {
    if(reload){
      _customerList = [];
    }
    _isGetting = true;
    _customerIndex = 0;
    Response response = await customerRepo.getCustomerList(offset);
    if(response.statusCode == 200) {
      _customerList.addAll(CustomerModel.fromJson(response.body).customers);
      _customerListLength = CustomerModel.fromJson(response.body).total;
      _customerIndex = 0;
      for(int index = 0; index < _customerList.length; index++) {
        _customerIds.add(_customerList[index].id);
      }
      _customerIndex = _customerIds[0];
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> updateCustomerBalance(int customerId, int accountId, double amount, String date , String description) async {
    Response response = await customerRepo.updateCustomerBalance(customerId,accountId, amount,date, description);
    if(response.statusCode == 200) {
      Get.back();
      getCustomerList(1, reload: true);
      showCustomSnackBar('customer_balance_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }



  Future<void> getCustomerWiseOrderListList(int customerId ,int offset, {bool reload = true}) async {
    _offset = offset;
    if(reload){
      _customerWiseOrderList = [];
      _isFirst = true;
    }
    _isGetting = true;
    Response response = await customerRepo.getCustomerWiseOrderList(customerId, offset);
    if(response.statusCode == 200) {
      _customerWiseOrderList.addAll(OrderModel.fromJson(response.body).orders);
      _customerWiseOrderListLength = OrderModel.fromJson(response.body).total;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> filterCustomerList(String searchName) async {
    _customerList = [];
    _isGetting = true;
    _customerIndex = 0;
    _customerIds.add(0);
    Response response = await customerRepo.customerSearch(searchName);
    if(response.statusCode == 200) {
      _customerList = [];
      _customerList.addAll(CustomerModel.fromJson(response.body).customers);
      _customerListLength = CustomerModel.fromJson(response.body).total;
      _customerIndex = 0;
      for(int index = 0; index < _customerList.length; index++) {
        _customerIds.add(_customerList[index].id);
      }
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  Future<void> deleteCustomer(int customerId) async {
    _isGetting = true;

    Response response = await customerRepo.deleteCustomer(customerId);
    if(response.statusCode == 200) {
      getCustomerList(1, reload: true);
      _isGetting = false;
      Get.back();
      showCustomSnackBar('customer_deleted_successfully'.tr, isError: false);


    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  void removeImage(){
    _customerImage = null;
    update();
  }

  void showBottomLoader() {
    _isGetting = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
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



}