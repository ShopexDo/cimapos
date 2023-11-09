import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/controller/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/brand_model.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/data/repository/brand_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class BrandController extends GetxController implements GetxService{
  final BrandRepo brandRepo;
  BrandController({@required this.brandRepo});

  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int _brandListLength;
  int get brandListLength => _brandListLength;
  List<Brands> _brandList;
  List<Brands> get brandList =>_brandList;
  int _brandIndex = 0;
  int get brandIndex => _brandIndex;
  List<int> _brandIds = [];
  List<int> get brandIds => _brandIds;



  final picker = ImagePicker();
  XFile _brandImage;
  XFile get brandImage=> _brandImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _brandImage = null;
    }else {
      _brandImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> addBrand(String brandName, int brandId, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await brandRepo.addBrand(brandName,brandId, _brandImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);
    if(response.statusCode == 200) {
      _brandImage = null;
      getBrandList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar(isUpdate ? 'brand_updated_successfully'.tr : 'brand_added_successfully'.tr, isError: false);
      _brandImage = null;

    }else {
      _isLoading = false;
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getBrandList(int offset, {Products product, bool reload = false}) async {
    if(reload){
      _brandList = [];
    }
    _isLoading = true;
    _brandIndex = 0;
    _brandIds = [];
    _brandIds.add(0);
    Response response = await brandRepo.getBrandList(offset);
    if(response.statusCode == 200) {

      _brandList.addAll(BrandModel.fromJson(response.body).brands);
      _brandListLength = BrandModel.fromJson(response.body).total;
      _brandIndex = 0;
      for(int index = 0; index < _brandList.length; index++) {
        _brandIds.add(_brandList[index].id);
      }

      if(product != null){
        setBrandIndex(product.brand.id, false);
      }
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteBrand(int brandId) async {
    _isLoading = true;
    Response response = await brandRepo.deleteBrand(brandId);
    if(response.statusCode == 200) {
      getBrandList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar('brand_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void removeImage(){
    _brandImage = null;
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setBrandIndex(int index, bool notify) {
    _brandIndex = index;
    if(notify) {
      update();
    }
  }

  void setBrandEmpty(){
    _brandIndex = 0;
    update();
  }

}