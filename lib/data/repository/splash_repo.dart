import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/model/response/config_model.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.apiClient});

  AppConstants appConstants = AppConstants();

  Future<Response> getConfigData(String baseUrl) async {
    Response _response = await apiClient.getDataConfig(baseUrl, AppConstants.CONFIG_URI);
    return _response;
  }


  Future<http.Response> getTimeZoneDataList() async {
    return await http.get(Uri.parse(AppConstants.TIMEZONE_API));
  }


  Future<bool> initSharedData() {
    print('soy splas');
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
  Future<Response> getProfile() async {
    return await apiClient.getData('${AppConstants.GET_PROFILE_URI}');
  }
  Future<Response> getDashboardRevenueSummery(String filterType) async {
    Response _response = await apiClient.getData('${AppConstants.GET_DASHBOARD_REVENUE_SUMMERY}?statistics_type=$filterType');
    return _response;
  }


  Future<http.StreamedResponse> updateShop(String baseUrl, BusinessInfo shop,  XFile file, String token,) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_SHOP_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      Uint8List _list = await file.readAsBytes();
      var part = http.MultipartFile('shop_logo', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
    'pagination_limit': shop.paginationLimit,
    'currency': shop.currency,
   'shop_name': shop.shopName,
    'shop_address': shop.shopAddress,
    'shop_phone': shop.shopPhone,
    'shop_email':shop.shopEmail,
    'footer_text': shop.footerText,
    'country': shop.country,
    'stock_limit': shop. stockLimit,
    'time_zone': shop.timeZone,
    'vat_reg_no': shop.vat,
    });
    request.fields.addAll(_fields);
    print('==========>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }
}
