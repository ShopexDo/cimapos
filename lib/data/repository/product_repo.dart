import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class ProductRepo{
  ApiClient apiClient;
  ProductRepo({@required this.apiClient});


  Future<Response> getProductList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_PRODUCT_URI}?limit=10&offset=$offset');
  }

  Future<Response> getLimitedStockProductList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_LIMITED_STOCK_PRODUCT_URI}?limit=10&offset=$offset');
  }



  Future<Response> updateProductQuantity(int productId, int quantity) async {
    return await apiClient.getData('${AppConstants.UPDATE_PRODUCT_QUANTITY}?id=$productId&quantity=$quantity');
  }




  Future<http.StreamedResponse> addProduct(Products product,String categoryId,String subCategoryId,int brandId,int supplierId, XFile file, String token,{bool isUpdate = false}) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = isUpdate ? http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_PRODUCT_URI}')):
    http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.ADD_PRODUCT}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      Uint8List _list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'id':product.id.toString(),
      'name': product.title,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'product_code': product.productCode,
      'unit_type': product.unitType.toString(),
      'quantity': product.quantity.toString(),
      'purchase_price': product.purchasePrice.toString(),
      'selling_price': product.sellingPrice.toString(),
      'tax':product.tax.toString(),
      'discount':product.discount.toString(),
      'discount_type':product.discountType,
      'brand':brandId.toString(),
      'supplier_id': supplierId.toString()
    });
    print('===here is product==>${product.toJson()} $categoryId and $subCategoryId');
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
  Future<Response> searchProduct(String productName) async {
    return await apiClient.getData('${AppConstants.PRODUCT_SEARCH_URI}?name=$productName');
  }


  Future<http.StreamedResponse> bulkImport(File filePath, String token) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.BULK_IMPORT_PRODUCT}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(filePath != null) {
      Uint8List _list = await filePath.readAsBytes();
      var part = http.MultipartFile('products_file', filePath.readAsBytes().asStream(), _list.length, filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{

    });

    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }






  Future<Response> bulkExport() async {
    return await apiClient.getData('${AppConstants.BULK_EXPORT_PRODUCT}');
  }

  Future<Response> downloadSampleFile() async {
    return await apiClient.getData('${AppConstants.GET_DOWNLOAD_SAMPLE_FILE_URL}');
  }


  Future<Response> deleteProduct(int productId) async {
    return await apiClient.getData('${AppConstants.PRODUCT_DELETE_URI}?id=$productId');
  }

  Future<Response> barCodeDownLoad( int id, int quantity) async {
    return await apiClient.getData('${AppConstants.BAR_CODE_DOWNLOAD}?id=$id&quantity=$quantity');
  }

}