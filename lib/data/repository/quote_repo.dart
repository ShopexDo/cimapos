import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class QuoteRepo{
  ApiClient apiClient;
  QuoteRepo({@required this.apiClient});

  Future<Response> getQuoteList(String offset) async {
    return await apiClient.getData('${AppConstants.QUOTE_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getQuoteData(int quoteId) async {
    return await apiClient.getData('${AppConstants.QUOTE}?quote_id=$quoteId');
  }

  Future<Response> approvedQuote(int quoteId) async {
    return await apiClient.getData('${AppConstants.APPROVED_QUOTE}?quote_id=$quoteId');
  }
}