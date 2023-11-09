import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class OrderRepo{
  ApiClient apiClient;
  OrderRepo({@required this.apiClient});

  Future<Response> getOrderList(String offset) async {
    return await apiClient.getData('${AppConstants.ORDER_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getInvoiceData(int orderId) async {
    return await apiClient.getData('${AppConstants.INVOICE}?order_id=$orderId');
  }
}