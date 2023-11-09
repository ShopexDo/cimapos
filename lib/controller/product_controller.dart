import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/controller/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/limite_stock_product_model.dart';
import 'package:six_pos/data/model/response/product_model.dart';

import 'package:six_pos/data/repository/product_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController implements GetxService{
  final ProductRepo productRepo;
  ProductController({@required this.productRepo});

  bool _isLoading = false;
  bool _isGetting = false;
  bool _isSub = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;
  bool get isLoading => _isLoading;
  bool get isSub => _isSub;
  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  int _productListLength;
  int get productListLength => _productListLength;

  int _limitedStockProductListLength;
  int get limitedStockProductListLength => _limitedStockProductListLength;

  List<Products> _productList = [];
  List<Products> get productList =>_productList;

  List<StockLimitedProducts> _limitedStockProductList = [];
  List<StockLimitedProducts> get limitedStockProductList =>_limitedStockProductList;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController get productNameController => _productNameController;
  TextEditingController _productStockController = TextEditingController();
  TextEditingController get productStockController => _productStockController;
  TextEditingController _productSkuController = TextEditingController();
  TextEditingController get productSkuController => _productSkuController;

  TextEditingController _productSellingPriceController = TextEditingController();
  TextEditingController get productSellingPriceController => _productSellingPriceController;

  TextEditingController _productPurchasePriceController = TextEditingController();
  TextEditingController get productPurchasePriceController => _productPurchasePriceController;

  TextEditingController _productTaxController = TextEditingController();
  TextEditingController get productTaxController => _productTaxController;

  TextEditingController _productDiscountController = TextEditingController();
  TextEditingController get productDiscountController => _productDiscountController;

  TextEditingController _productQuantityController = TextEditingController();
  TextEditingController get productQuantityController => _productQuantityController;


  int _selectionTabIndex = 0;
  int get selectionTabIndex =>_selectionTabIndex;
  String _selectedDiscountType = '';
  String get selectedDiscountType =>_selectedDiscountType;

  File _selectedFileForImport ;
  File get selectedFileForImport =>_selectedFileForImport;

  String _bulkImportSampleFilePath = '';
  String get bulkImportSampleFilePath =>_bulkImportSampleFilePath;


  String _printBarCode = '';
  String get printBarCode =>_printBarCode;


  String _bulkExportFilePath = '';
  String get bulkExportFilePath =>_bulkExportFilePath;

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;
  bool _isUpdate = false;
  bool get isUpdate =>_isUpdate;




  final picker = ImagePicker();
  XFile _productImage;
  XFile get productImage=> _productImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _productImage = null;
    }else {
      _productImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }


  Future<void> getProductList( int offset, {bool reload = false}) async {
    if(reload){
      _productList = [];
    }
    _isGetting = true;
    Response response = await productRepo.getProductList(offset);
    if(response.statusCode == 200) {
      _productList.addAll(ProductModel.fromJson(response.body).products);
      _productListLength = ProductModel.fromJson(response.body).total;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  Future<void> getSearchProductList(String name) async {
    Response response = await productRepo.searchProduct(name);
    if(response.body != {} &&  response.statusCode == 200) {
      _productList =[];
      _productList.addAll(ProductModel.fromJson(response.body).products);
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }





  Future<void> getLimitedStockProductList( int offset, {bool reload = false}) async {
    if(reload){
      _limitedStockProductList = [];
    }
    _isGetting = true;
    Response response = await productRepo.getLimitedStockProductList(offset);
    if(response.statusCode == 200) {
      _limitedStockProductList.addAll(LimitedStockProductModel.fromJson(response.body).stockLimitedProducts);
      _limitedStockProductListLength = LimitedStockProductModel.fromJson(response.body).total;

      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  Future<void> updateProductQuantity(int productId, int quantity) async {
    _isUpdate = true;
    Response response = await productRepo.updateProductQuantity(productId, quantity);
    if(response.statusCode == 200) {
      _productQuantityController.clear();
      getLimitedStockProductList(1, reload: true);
      getProductList(1, reload: true);
      Map map = response.body;
      String message = map['message'];
      showCustomSnackBar(message, isError: false);
      _isUpdate = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isUpdate = false;
    update();
  }

  Future<http.StreamedResponse> addProduct(Products product, String category, String subCategory, int brandId, int supplierId, bool isUpdate) async {
    _isLoading = true;
    update();
    print('=======image =======>$_productImage');
    http.StreamedResponse response = await productRepo.addProduct(product,category,subCategory,brandId,supplierId, _productImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);
    if(response.statusCode == 200) {
      _productImage = null;
      getProductList(1, reload: true);
      _productNameController.clear();
      _productStockController.clear();
      _productSkuController.clear();
      _productSellingPriceController.clear();
      _productPurchasePriceController.clear();
      _productTaxController.clear();
      _productDiscountController.clear();
      _productQuantityController.clear();
      _isLoading = false;
      Get.back();
      showCustomSnackBar(isUpdate? 'product_updated_successfully'.tr : 'product_added_successfully'.tr, isError: false);
    }else {
      _isLoading = false;
      showCustomSnackBar('failed_to_add_product'.tr, isError: false);
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> deleteProduct( int productId) async {
    _isGetting = true;
    update();
    Response response = await productRepo.deleteProduct(productId);
    if(response.statusCode == 200) {
      Get.back();
     getProductList(1, reload: true);
     showCustomSnackBar('product_deleted_successfully'.tr.tr, isError: false);
      _isGetting = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  void removeImage(){
    _productImage = null;
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

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setIndexForTabBar(int index){
    _selectionTabIndex = index;
    update();
  }

  void setSelectedDiscountType(String type){
    _selectedDiscountType = type;
    print('selected discount type is ==>$_selectedDiscountType');
    update();
  }
  void setSelectedFileName(File fileName){
    _selectedFileForImport = fileName;
    print('selected discount type is ==>$_selectedDiscountType');
    update();
  }

  Future<void> getSampleFile() async {
    _isGetting = true;
    Response response = await productRepo.downloadSampleFile();
    if(response.statusCode == 200) {
      Map map = response.body;
      _bulkImportSampleFilePath = map['product_bulk_file'];
      print('download url is ===> $_bulkImportSampleFilePath');
      _isGetting = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<http.StreamedResponse> bulkImportFile() async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await productRepo.bulkImport(_selectedFileForImport, Get.find<AuthController>().getUserToken());
    if(response.statusCode == 200) {
      _isLoading = false;
      Get.back();
      showCustomSnackBar('product_imported_successfully'.tr, isError: false);
      _selectedFileForImport = null;

    }else {
      _isLoading = false;
    }
    _isLoading = false;
    update();
    return response;
  }




  Future<void> bulkExportFile() async {
    _isGetting = true;
    Response response = await productRepo.bulkExport();
    if(response.statusCode == 200) {
      Map map = response.body;
      _bulkExportFilePath = map['excel_report'];
      _isGetting = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  void setBarCodeQuantity(int quantity){
    _barCodeQuantity = quantity;
    print('Quantity is ==>$_barCodeQuantity');
    update();
  }


  void downloadFile(String url, String dir) async {
     await FlutterDownloader.enqueue(
      url: '$url',
      savedDir: '$dir',
      showNotification: true,
       saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  Future<void> barCodeDownload(int id, int quantity) async {
    _isGetting = true;
    Response response = await productRepo.barCodeDownLoad(id, quantity);
    if(response.statusCode == 200) {
      _printBarCode = response.body;
      showCustomSnackBar('barcode_downloaded_successfully'.tr, isError: false);
      print('download url is ===> $_bulkImportSampleFilePath');
      _isGetting = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

}