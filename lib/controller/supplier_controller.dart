import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cimapos/controller/auth_controller.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/product_model.dart';
import 'package:cimapos/data/model/response/supplier_model.dart';
import 'package:cimapos/data/model/response/supplier_profile_model.dart' as profile;
import 'package:cimapos/data/model/response/transaction_model.dart';
import 'package:cimapos/data/repository/supplier_repo.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:cimapos/data/model/response/response_model.dart';


class SupplierController extends GetxController implements GetxService{
  final SupplierRepo supplierRepo;
  SupplierController({@required this.supplierRepo});

  bool _isLoading = false;
  bool _isGetting = false;
  bool _isSub = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;
  bool get isLoading => _isLoading;
  bool get isSub => _isSub;
  int _supplierListLength;
  int get supplierListLength => _supplierListLength;
  List<Suppliers> _supplierList = [];
  List<Suppliers> get supplierList =>_supplierList;
  int _supplierIndex = 0;
  int get supplierIndex => _supplierIndex;
  List<int> _supplierIds = [];
  List<int> get supplierIds => _supplierIds;

  profile.Supplier _supplierProfile;
  profile.Supplier get supplierProfile =>_supplierProfile;

  List<Products> _supplierProductList = [];
  List<Products> get supplierProductList =>_supplierProductList;

  int _supplierProductListLength;
  int get supplierProductListLength => _supplierProductListLength;

  List<Transfers> _supplierTransactionList = [];
  List<Transfers> get supplierTransactionList =>_supplierTransactionList;

  int _supplierTransactionListLength;
  int get supplierTransactionListLength => _supplierTransactionListLength;




  final picker = ImagePicker();
  XFile _supplierImage;
  XFile get supplierImage=> _supplierImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _supplierImage = null;
    }else {
      _supplierImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> addSupplier(Suppliers supplier, bool isUpdate) async {

    _isLoading = true;
    update();
    http.StreamedResponse response = await supplierRepo.addSupplier(supplier, _supplierImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);
    if(response.statusCode == 200) {
      _supplierImage = null;
      getSupplierList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar(isUpdate? 'supplier_updated_successfully'.tr : 'supplier_added_successfully'.tr, isError: false);

    }else {
      _isLoading = false;
      showCustomSnackBar('supplier_update_failed'.tr);
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getSupplierList( int offset, {Products product, bool reload = true}) async {
    if(reload){
      _supplierList =[];
      _isFirst = true;
    }
    _isGetting = true;
    _supplierIndex = 0;
    _supplierIds =[];
    _supplierIds.add(0);
    Response response = await supplierRepo.getSupplierList(offset);
    if(response.statusCode == 200) {
      _supplierList.addAll(SupplierModel.fromJson(response.body).suppliers);
      _supplierListLength = SupplierModel.fromJson(response.body).total;
      _supplierIndex = 0;
      for(int index = 0; index < _supplierList.length; index++) {
        _supplierIds.add(_supplierList[index].id);
      }

      if(product != null){
        setSupplierIndex(product.supplier.id, true);
      }
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }



  Future<void> searchSupplier(String name) async {
    _supplierList = [];
    _isGetting = true;
    _supplierIndex = 0;
    _supplierIds = [];
    _supplierIds.add(0);
    Response response = await supplierRepo.searchSupplier(name);
    if(response.statusCode == 200) {
      _supplierList = [];
      supplierList.addAll(SupplierModel.fromJson(response.body).suppliers);
      _supplierListLength = SupplierModel.fromJson(response.body).total;
      _supplierIndex = 0;
      for(int index = 0; index < _supplierList.length; index++) {
        _supplierIds.add(_supplierList[index].id);
      }

      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> deleteSupplier(int supplierId) async {
    _isGetting = true;

    Response response = await supplierRepo.deleteSupplier(supplierId);
    if(response.statusCode == 200) {
      getSupplierList(1);
      _isGetting = false;
      Get.back();
      showCustomSnackBar('supplier_deleted_successfully'.tr, isError: false);


    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }



  Future<void> getSupplierProfile(int supplierId) async {
    print('due amount ===>');
    Response response = await supplierRepo.getSupplierProfile(supplierId);
    if(response.statusCode == 200) {
      _supplierProfile = profile.SupplierProfileModel.fromJson(response.body).supplier;
      print('due amount ===>${_supplierProfile.dueAmount}');
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> getSupplierProductList(int offset, int supplierId, {bool reload = true}) async {

    if(reload){
      _supplierProductList = [];
      _isFirst = true;
    }

    _isGetting = true;
    Response response = await supplierRepo.getSupplierProductList(offset, supplierId);
    if(response.statusCode == 200) {
      _supplierProductList.addAll(ProductModel.fromJson(response.body).products);
      _supplierProductListLength = ProductModel.fromJson(response.body).total;

      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> getSupplierTransactionList(int offset, int supplierId, {bool reload = true}) async {
    if(reload){
      _supplierTransactionList =[];
      _isFirst = true;
    }
    _isGetting = true;
    Response response = await supplierRepo.getSupplierTransactionList(offset, supplierId);
    if(response.statusCode == 200) {
      _supplierTransactionList.addAll(TransactionModel.fromJson(response.body).transfers);
      _supplierTransactionListLength = TransactionModel.fromJson(response.body).total;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }




  Future<void> getSupplierTransactionFilterList(int offset, int supplierId, String fromDate, String toDate) async {
    _supplierTransactionList =[];
    _isGetting = true;
    Response response = await supplierRepo.getSupplierTransactionFilterList(offset, supplierId, fromDate, toDate);
    if(response.statusCode == 200) {
      _supplierTransactionList =[];
      _supplierTransactionList.addAll(TransactionModel.fromJson(response.body).transfers);
      _supplierTransactionListLength = TransactionModel.fromJson(response.body).total;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<ResponseModel> supplierNewPurchase(int supplierId, double purchaseAmount, double paidAmount, double dueAmount, int paymentAccountId) async {

    _isLoading = true;
    update();
    Response response = await supplierRepo.supplierNewPurchase(supplierId, purchaseAmount,paidAmount,dueAmount,paymentAccountId);
    ResponseModel responseModel;
    if(response.statusCode == 200){
      getSupplierProfile(supplierId);
      getSupplierTransactionList(1,supplierId);
      Get.back();
      showCustomSnackBar('purchase_completed_successfully'.tr , isError: false);
      _isLoading = false;
    }else{
      _isLoading = false;
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }



  Future<ResponseModel> supplierPayment(int supplierId, double totalDueAmount, double payAmount, double remainingDueAmount, int paymentAccountId) async {

    _isLoading = true;
    update();
    Response response = await supplierRepo.supplierPayment(supplierId, totalDueAmount, payAmount, remainingDueAmount, paymentAccountId);
    ResponseModel responseModel;
    if(response.statusCode == 200){
      getSupplierProfile(supplierId);
      getSupplierTransactionList(1,supplierId);

      Get.back();
      showCustomSnackBar('payment_completed_successfully'.tr , isError: false);
      _isLoading = false;
    }else{
      _isLoading = false;
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }




  void removeImage(){
    _supplierImage = null;
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
  void setSupplierIndex(int index, bool notify) {
    _supplierIndex = index;
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
}