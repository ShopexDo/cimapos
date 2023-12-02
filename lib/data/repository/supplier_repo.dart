
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cimapos/data/api/api_client.dart';
import 'package:cimapos/data/model/response/supplier_model.dart';
import 'package:cimapos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class SupplierRepo{
  ApiClient apiClient;
  SupplierRepo({@required this.apiClient});

  Future<Response> getSupplierList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_SUPPLIER_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getSupplierProfile(int sellerId) async {
    return await apiClient.getData('${AppConstants.SUPPLIER_PROFILE_URI}?id=$sellerId');
  }

  Future<Response> getSupplierProductList(int offset, int supplierId) async {
    return await apiClient.getData('${AppConstants.SUPPLIER_PRODUCT_LIST_URI}?limit=10&offset=$offset&supplier_id=$supplierId');
  }

  Future<Response> getSupplierTransactionList(int offset, int supplierId) async {
    return await apiClient.getData('${AppConstants.SUPPLIER_TRANSACTION_LIST_URI}?limit=10&offset=$offset&supplier_id=$supplierId');
  }

  Future<Response> getSupplierTransactionFilterList(int offset, int supplierId, String fromDate, String toDate) async {
    return await apiClient.getData('${AppConstants.SUPPLIER_TRANSACTION_FILTER_LIST_URI}?supplier_id=$supplierId&limit=10&offset=$offset&from=$fromDate&to=$toDate');
  }

  Future<Response> supplierNewPurchase(int supplierId, double purchaseAmount, double paidAmount, double dueAmount, int paymentAccountId) async {
    return await apiClient.postData('${AppConstants.NEW_PURCHASE_FROM_SUPPLIER}', {
      'supplier_id': supplierId,
      'purchased_amount': purchaseAmount,
      'paid_amount': paidAmount,
      'due_amount' : dueAmount,
      'payment_account_id': paymentAccountId

    });
  }


  Future<Response> supplierPayment(int supplierId, double totalDueAmount, double payAmount, double remainingDueAmount, int paymentAccountId) async {
    return await apiClient.postData('${AppConstants.SUPPLIER_PAYMENT}', {
      'supplier_id': supplierId,
      'total_due_amount': totalDueAmount,
      'pay_amount': payAmount,
      'remaining_due_amount' : remainingDueAmount,
      'payment_account_id': paymentAccountId
    });
  }




  Future<Response> searchSupplier(String name) async {
    return await apiClient.getData('${AppConstants.SEARCH_SUPPLIER_URI}?name=$name');
  }


  Future<http.StreamedResponse> addSupplier(Suppliers supplier, XFile file, String token, {bool isUpdate = false}) async {
    final baseUrl = await AppConstants.getSavedBaseUrl();
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.UPDATE_SUPPLIER_URI}')):
    http.MultipartRequest('POST', Uri.parse('${baseUrl}${AppConstants.ADD_SUPPLIER}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List _list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'id': supplier.id.toString(),
      'name': supplier.name,
      'mobile': supplier.mobile,
      'state': supplier.state,
      'city': supplier.city,
      'zip_code': supplier.zipCode,
      'address': supplier.address,
      'email': supplier.email,
      'due_amount': '0.0',
      '_method': isUpdate? 'put' : 'post'
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> deleteSupplier(int supplierId) async {
    return await apiClient.getData('${AppConstants.DELETE_SUPPLIER_URI}?id=$supplierId');
  }
}