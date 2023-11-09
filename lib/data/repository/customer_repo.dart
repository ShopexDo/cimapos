import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class CustomerRepo{
  ApiClient apiClient;
  CustomerRepo({@required this.apiClient});

  Future<Response> getCustomerList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_CUSTOMER_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getCustomerWiseOrderList(int customerId ,int offset) async {
    return await apiClient.getData('${AppConstants.CUSTOMER_WISE_ORDER_LIST_URI}?customer_id=$customerId&limit=10&offset=$offset');
  }



  Future<Response> customerSearch(String name) async {
    return await apiClient.getData('${AppConstants.CUSTOMER_SEARCH_URI}?name=$name');
  }

  Future<Response> updateCustomerBalance(int customerId, int accountId, double amount, String date, String description) async {
    return await apiClient.postData('${AppConstants.CUSTOMER_BALANCE_UPDATE}',{
      'customer_id': customerId,
      'amount': amount,
      'account_id': accountId,
      'description': description,
      'date': date
    });
  }


  Future<Response> deleteCustomer(int customerId) async {
    return await apiClient.getData('${AppConstants.DELETE_CUSTOMER_URI}?id=$customerId');
  }


  Future<http.StreamedResponse> addCustomer(Customers customer, XFile file, String token, {bool isUpdate = false}) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_CUSTOMER_URI}')):
    http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.ADD_NEW_CUSTOMER}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List _list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'id': customer.id.toString(),
      'name': customer.name,
      'mobile': customer.mobile,
      'email': customer.email,
      'state': customer.state,
      'city': customer.city,
      'zip_code': customer.zipCode,
      'address': customer.address,
      'balance': '0.0',
      '_method': isUpdate? 'put': 'post'
    });
    request.fields.addAll(_fields);
    print('==========>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }

}