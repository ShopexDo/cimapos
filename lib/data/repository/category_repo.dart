import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cimapos/data/api/api_client.dart';
import 'package:cimapos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class CategoryRepo{
  ApiClient apiClient;
  CategoryRepo({@required this.apiClient});

  Future<Response> getCategoryList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_CATEGORY_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getCategoryWiseProductList(int categoryId) async {
    return await apiClient.getData('${AppConstants.CATEGORIES_PRODUCT}?category_id=$categoryId');
  }


  Future<http.StreamedResponse> addCategory(String categoryName,int categoryId,  XFile file, String token, {bool isUpdate = false}) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = isUpdate ? http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_CATEGORY_URI}')):
    http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.ADD_CATEGORY}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

      if(file != null) {
        Uint8List _list = await file.readAsBytes();
        var part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
        request.files.add(part);
      }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'id': categoryId.toString(),
      'name': categoryName,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


  Future<Response> getSubCategoryList(int offset, int categoryId) async {
    return await apiClient.getData('${AppConstants.GET_SUB_CATEGORY_LIST}?limit=10&offset=$offset&category_id=$categoryId');
  }
  Future<Response> addSubCategory(String subCategoryName, int parenCategoryId, int id, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate?  '${AppConstants.UPDATE_SUB_CATEGORY}' : '${AppConstants.ADD_SUB_CATEGORY}',
        {'name':subCategoryName, 'parent_id' : parenCategoryId, 'id': id });
  }


  Future<Response> searchProduct(String productName) async {
    return await apiClient.getData('${AppConstants.PRODUCT_SEARCH_URI}?name=$productName');
  }

  Future<Response> deleteCategory(int categoryId) async {
    return await apiClient.getData('${AppConstants.DELETE_CATEGORY_URI}?id=$categoryId');
  }

  Future<Response> categoryStatusOnOff(int categoryId, int status) async {
    return await apiClient.getData('${AppConstants.UPDATE_CATEGORY_STATUS_URI}?id=$categoryId&status=$status');
  }


}