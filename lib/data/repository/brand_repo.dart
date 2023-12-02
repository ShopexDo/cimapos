import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cimapos/data/api/api_client.dart';
import 'package:cimapos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class BrandRepo{
  ApiClient apiClient;
  BrandRepo({@required this.apiClient});

  Future<Response> getBrandList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_BRAND_LIST}?limit=10&offset=$offset');
  }

  Future<http.StreamedResponse> addBrand(String brandName,int brandId,  XFile file, String token, {bool isUpdate}) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_BRAND_URI}')):
    http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.ADD_BRAND}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List _list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'id': brandId.toString(),
      'name': brandName,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> deleteBrand(int brandId) async {
    return await apiClient.getData('${AppConstants.DELETE_BRAND_URI}?id=$brandId');
  }


}