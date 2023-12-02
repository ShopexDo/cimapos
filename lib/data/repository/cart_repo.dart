import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cimapos/data/api/api_client.dart';
import 'package:cimapos/data/model/body/place_order_body.dart';
import 'package:cimapos/data/model/body/place_bill_body.dart';
import 'package:cimapos/data/model/body/place_quote_body.dart';
import 'package:cimapos/util/app_constants.dart';

class CartRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CartRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getCouponDiscount(String couponCode, int userId, double orderAmount) async {
    return await apiClient.getData('${AppConstants.GET_COUPON_DISCOUNT}?code=$couponCode&user_id=$userId&order_amount=$orderAmount');
  }

  Future<Response> placeOrder(PlaceOrderBody placeOrderBody) async {
    return await apiClient.postData('${AppConstants.PLACE_ORDER_URI}', placeOrderBody.toJson());
  }

  Future<Response> placeQuote(PlaceQuoteBody placeQuoteBody) async {
    return await apiClient.postData('${AppConstants.PLACE_QUOTE_URI}', placeQuoteBody.toJson());
  }

  Future<Response> approvedQuote(PlaceBillBody quote) async {
    return await apiClient.postData('${AppConstants.APPROVED_BILL}', quote.toJson());
  }

  Future<Response> getProductFromScan(String productCode) async {
    return await apiClient.getData('${AppConstants.GET_PRODUCT_FROM_PRODUCT_CODE}?product_code=$productCode');
  }

  Future<Response> customerSearch(String name) async {
    return await apiClient.getData('${AppConstants.CUSTOMER_SEARCH_URI}?name=$name');
  }

}