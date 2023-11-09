import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/controller/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/categoriesProductModel.dart';
import 'package:six_pos/data/model/response/category_model.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/data/model/response/sub_category_model.dart';
import 'package:six_pos/data/repository/category_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController implements GetxService{
  final CategoryRepo categoryRepo;
  CategoryController({@required this.categoryRepo});

  bool _isLoading = false;
  bool _isGetting = false;
  bool _isCategory = false;
  bool get isCategory => _isCategory;
  bool _isSub = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;
  bool get isLoading => _isLoading;
  bool get isSub => _isSub;
  int _categoryListLength;
  int get categoryListLength => _categoryListLength;

  int _subCategoryListLength;
  int get subCategoryListLength => _subCategoryListLength;

  List<Categories> _categoryList = [];
  List<Categories> get categoryList =>_categoryList;

  List<SubCategories> _subCategoryList =[];
  List<SubCategories> get subCategoryList =>_subCategoryList;


  int _categorySelectedIndex;
  int get categorySelectedIndex => _categorySelectedIndex;


  int _categoryIndex = 0;
  int _categoryId = 0;
  int get categoryId => _categoryId;
  int _subCategoryIndex = 0;
  int get categoryIndex => _categoryIndex;
  int get subCategoryIndex => _subCategoryIndex;
  List<int> _categoryIds = [];
  List<int> _subCategoryIds = [0];
  List<int> get categoryIds => _categoryIds;
  List<int> get subCategoryIds => _subCategoryIds;


  List<CategoriesProduct> _categoriesProductList;
  List<CategoriesProduct> get categoriesProductList =>_categoriesProductList;

  List<Products> _searchedProductList;
  List<Products> get searchedProductList =>_searchedProductList;
  String _selectedCategoryName = 'select';
  String get selectedCategoryName => _selectedCategoryName;



  final picker = ImagePicker();
  XFile _categoryImage;
  XFile get categoryImage=> _categoryImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _categoryImage = null;
    }else {
      _categoryImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }



  Future<http.StreamedResponse> addCategory(String categoryName, int categoryId, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await categoryRepo.addCategory(categoryName,categoryId, _categoryImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);
    if(response.statusCode == 200) {
      _categoryImage = null;
      getCategoryList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar(isUpdate? 'category_updated_successfully'.tr : 'category_added_successfully'.tr, isError: false);

    }
    else if(response.statusCode == 403){
      showCustomSnackBar('category_already_exist'.tr);
    }
    else {
      _isLoading = false;
      print('${response.statusCode}');
      _isLoading = false;
    }
    _isLoading = false;
    update();
    return response;
  }





  Future<void> getCategoryList(int offset, {Products product, reload = false}) async {
    if(reload){
      _categoryList =[];
    }
    _isGetting = true;
    _categoryIndex = 0;
    _categoryIds = [];
    _categoryIds.add(0);
    Response response = await categoryRepo.getCategoryList(offset);
    if(response.statusCode == 200) {
      _categoryList.addAll(CategoryModel.fromJson(response.body).categories);
      _categoryListLength = CategoryModel.fromJson(response.body).total;
      _categoryIndex = 0;
      for(int index = 0; index < _categoryList.length; index++) {
        _categoryIds.add(_categoryList[index].id);
      }

      if(product != null){
        setCategoryIndex(_categoryIds.indexOf(int.parse(product.categoryIds[0].id)), false, product: product);
      }


      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }



  Future<void> getCategoryWiseProductList(int categoryId) async {
    _isCategory = true;
    Response response = await categoryRepo.getCategoryWiseProductList(categoryId);
    if(response.body != {} &&  response.statusCode == 200) {
      _categoriesProductList = [];
      response.body.forEach((categoriesProduct) => _categoriesProductList.add(CategoriesProduct.fromJson(categoriesProduct)));
    }else {
      ApiChecker.checkApi(response);
    }
    _isCategory = false;
    update();
  }



  Future<void> getSearchProductList(String name) async {
    Response response = await categoryRepo.searchProduct(name);
    if(response.body != {} &&  response.statusCode == 200) {
      _searchedProductList = [];
      _searchedProductList.addAll(ProductModel.fromJson(response.body).products);
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }




  Future<void> getSubCategoryList(int offset, int categoryId, {Products product, bool reload= false}) async {
    if(reload){
      _subCategoryList = [];
    }
    _isGetting = true;
    _subCategoryIds =[];
    _subCategoryIds.add(0);
    Response response = await categoryRepo.getSubCategoryList(offset, categoryId);
    if(response.statusCode == 200) {
      _subCategoryList = [];
      _subCategoryList.addAll(SubCategoryModel.fromJson(response.body).subCategories);
      _subCategoryListLength = SubCategoryModel.fromJson(response.body).total;
      for(int index = 0; index < _subCategoryList.length; index++) {
        _subCategoryIds.add(_subCategoryList[index].id);
      }

      if(product != null){
        if(product.categoryIds.length > 1){
          setSubCategoryIndex(int.parse(product.categoryIds[1].id), false);
        }
      }
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  Future<void> addSubCategory(String subCategoryName, int id, int parenCategoryId, bool isUpdate) async {
    _isSub = true;
    Response response = await categoryRepo.addSubCategory(subCategoryName, parenCategoryId,id, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getSubCategoryList(1, parenCategoryId, reload: true);
      Get.back();
      showCustomSnackBar(isUpdate ? 'sub_category_update_successfully'.tr : 'sub_category_added_successfully'.tr, isError: false);
      _isSub = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isSub = false;
    update();
  }





  void removeImage(){
    _categoryImage = null;
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
  void setCategoryIndex(int index, bool notify, {bool fromUpdate = false, Products product}) {
    getSubCategoryList(1, categoryList[index-1].id, reload: true, product: product);
    _categoryIndex = index;
    _categorySelectedIndex = _categoryIndex;
    if(notify) {
      update();
    }
  }
  void setSubCategoryIndex(int index, bool notify) {
    print('========$index');
    _subCategoryIndex = index;

    if(notify) {
      update();
    }
  }
  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    // update();
  }
  void setCategorySelectedName(String categoryName) {
    _selectedCategoryName = categoryName;
    update();
  }

  Future<void> deleteCategory(int categoryId) async {
    Response response = await categoryRepo.deleteCategory(categoryId);
    if(response.statusCode == 200) {
      Map map = response.body;
      bool status = map ['success'];
      String message = map ['message'];
      getCategoryList(1, reload: true);
      Get.back();
      showCustomSnackBar('$message', isError: !status);
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  Future<void> deleteSubCategory(int categoryId) async {
    Response response = await categoryRepo.deleteCategory(categoryId);
    if(response.statusCode == 200) {
      Get.back();
      getSubCategoryList(1, _categorySelectedIndex+1, reload: true);
      showCustomSnackBar('sub_category_deleted_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }
  Future<void> categoryStatusOnOff(int categoryId, int status, int index) async {
    Response response = await categoryRepo.categoryStatusOnOff(categoryId, status);
    if(response.statusCode == 200){
      // getCategoryList(1, reload: true);
      _categoryList[index].status = status;
      showCustomSnackBar('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }
  Future<void> subCategoryStatusOnOff(int subCategoryId, int status) async {
    Response response = await categoryRepo.categoryStatusOnOff(subCategoryId, status);
    if(response.statusCode == 200){
      getSubCategoryList(1,categorySelectedIndex, reload: true);
      showCustomSnackBar('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> categoryListEmpty(Products product)async {
    _categoryList = [];
    getCategoryList(1,product: product, reload: true);

  }

  void setCategoryAndSubCategoryEmpty(){
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    update();
  }

}