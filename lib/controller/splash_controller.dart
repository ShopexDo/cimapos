import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cimapos/controller/auth_controller.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/config_model.dart';
import 'package:cimapos/data/model/response/profile_model.dart';
import 'package:cimapos/data/model/response/revenue_model.dart';
import 'package:cimapos/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:cimapos/util/app_constants.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({@required this.splashRepo});

  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;
  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  ConfigModel _configModel;
  ConfigModel get configModel=>_configModel;
  BaseUrls _baseUrls;
  BaseUrls get baseUrls => _baseUrls;

  ProfileModel _profileModel;
  ProfileModel get profileModel=>  _profileModel;

  RevenueSummary _revenueModel;
  RevenueSummary get revenueModel=>  _revenueModel;

  int _revenueFilterTypeIndex = 0;
  int get revenueFilterTypeIndex => _revenueFilterTypeIndex;

  String _revenueFilterType = '';
  String get revenueFilterType => _revenueFilterType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _timeZoneList =[];
  List<dynamic> get timeZoneList => _timeZoneList;
  List<String> _timeZone =[];
  List<String> get timeZone => _timeZone;

  String _selectedTimeZone = '';
  String get selectedTimeZone => _selectedTimeZone;



  Future<void> getConfigData(String baseUrl) async {
    String storedBaseUrl;
    if (baseUrl == null) {
      storedBaseUrl = await AppConstants.getSavedBaseUrl();
    } else {
      storedBaseUrl = baseUrl;
    }
    Response _response = await splashRepo.getConfigData(storedBaseUrl);
    print('splas_con');
    print(_response.body);
    if(_response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(_response.body);
      _baseUrls = ConfigModel.fromJson(_response.body).baseUrls;
      print(_response.body);
    }else {
      ApiChecker.checkApi(_response);
    }
  }


  Future<http.Response> getTimeZoneList() async {
    http.Response response = await splashRepo.getTimeZoneDataList();
    if(response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      _timeZoneList.addAll(decodedData);
      _timeZone = List<String>.from(_timeZoneList);

      print('===TimeZone====>${_timeZone.toList()}');
    }
    update();
    return response;
  }



  Future<void> getProfileData() async {
    Response _response = await splashRepo.getProfile();
    if(_response.statusCode == 200) {
      _profileModel = ProfileModel.fromJson(_response.body);
    }else {
      ApiChecker.checkApi(_response);
    }
  }

  Future<void> getDashboardRevenueData(String filterType) async {
    Response _response = await splashRepo.getDashboardRevenueSummery(filterType);
    if(_response.statusCode == 200) {
      _revenueModel = RevenueModel.fromJson(_response.body).revenueSummary;
    }else {
      ApiChecker.checkApi(_response);
    }
    update();
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }


  void setRevenueFilterType(int index, bool notify) {
    _revenueFilterTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setRevenueFilterName(String filterName, bool notify) {
    _revenueFilterType = filterName;
    String callingString;
    if(_revenueFilterType == 'Overall'){
      callingString = 'overall';
    }else if(_revenueFilterType == 'Today'){
      callingString = 'today';
    }else if(_revenueFilterType == 'This Month'){
      callingString = 'month';
    }
    getDashboardRevenueData(callingString);
    if(notify) {
      update();
    }
  }

  final picker = ImagePicker();
  XFile _shopLogo;
  XFile get shopLogo=> _shopLogo;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _shopLogo = null;
    }else {
      _shopLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> updateShop(BusinessInfo shop) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    _isLoading = true;
    update();
    http.StreamedResponse response = await splashRepo.updateShop(baseUrl, shop, _shopLogo, Get.find<AuthController>().getUserToken());
    if(response.statusCode == 200) {
      getConfigData(baseUrl);
      _isLoading = false;
      Get.back();
      showCustomSnackBar('shop_updated_successfully'.tr, isError: false);
    }else {
      _isLoading = false;
    }
    _isLoading = false;
    update();
    return response;
  }
  void setValueForSelectedTimeZone (String setValue){
    _selectedTimeZone = setValue;
  }
}
