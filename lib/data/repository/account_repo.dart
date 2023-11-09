import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/util/app_constants.dart';



class AccountRepo{
  ApiClient apiClient;
  AccountRepo({@required this.apiClient});

  Future<Response> getAccountList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_account_LIST}?limit=10&offset=$offset');
  }

  Future<Response> searchAccount(String search) async {
    return await apiClient.getData('${AppConstants.SEARCH_ACCOUNT_URI}?name=$search');
  }

  Future<Response> deleteAccountId(int accountId) async {
    return await apiClient.getData('${AppConstants.DElETE_ACCOUNT_URI}?id=$accountId');
  }

  Future<Response> addAccount(Accounts account, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate ? '${AppConstants.UPDATE_ACCOUNT_URI}' : '${AppConstants.ADD_NEW_ACCOUNT}',{
      'id': account.id,
      'account': account.account,
      'description': account.description,
      'balance': account.balance,
      'account_number': account.accountNumber,


    });
  }

  Future<Response> getRevenueChartData() async {
    return await apiClient.getData('${AppConstants.Get_REVENUE_CHART_DATA}');
  }


}