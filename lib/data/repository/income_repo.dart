import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/data/model/response/income_model.dart';
import 'package:six_pos/util/app_constants.dart';

class IncomeRepo{
  ApiClient apiClient;
  IncomeRepo({@required this.apiClient});

  Future<Response> getIncomeList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_INCOME_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getIncomesFilter(String startDate, String endDate) async {
    return await apiClient.getData('${AppConstants.FILTER_INCOME_LIST}?from=$startDate&to=$endDate');
  }


  Future<Response> addNewIncome(Incomes income) async {
    return await apiClient.postData('${AppConstants.ADD_NEW_INCOME}',{
      'account_id': income.accountId,
      'amount': income.amount,
      'description': income.description,
      'date': income.date
    });
  }


}