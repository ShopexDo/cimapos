import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/api/api_client.dart';
import 'package:cimapos/data/model/response/transaction_model.dart';
import 'package:cimapos/util/app_constants.dart';



class TransactionRepo{
  ApiClient apiClient;
  TransactionRepo({@required this.apiClient});


  Future<Response> getTransactionAccountList(int offset) async {
    return await apiClient.getData('${AppConstants.TRANSACTION_ACCOUNT_LIST_URI}?limit=10&offset=$offset');
  }

  Future<Response> getCustomerWiseTransactionList(int customerId ,int offset) async {
    return await apiClient.getData('${AppConstants.CUSTOMER_WISE_TRANSACTION_LIST_URI}?customer_id=$customerId&limit=10&offset=$offset');
  }



  Future<Response> getTransactionTypeList() async {
    return await apiClient.getData('${AppConstants.TRANSACTION_TYPE_LIST_URI}');
  }

  Future<Response> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.TRANSACTION_LIST_URI}?limit=10&offset=$offset');
  }

  Future<Response> exportTransactionList(String startDate, String endDate, int accountId, String transactionType) async {
    return await apiClient.getData('${AppConstants.TRANSACTION_LIST_EXPORT_URI}?from=$startDate&to=$endDate&account_id=$accountId&transaction_type=$transactionType');
  }

  Future<Response> getTransactionFilter(String startDate, String endDate, int accountId, String transactionType,int offset) async {
    return await apiClient.getData('${AppConstants.TRANSACTION_FILTER_URI}?'
        'from=$startDate&to=$endDate&account_id=$accountId&tran_type=$transactionType&limit=10&offset=$offset');
  }


  Future<Response> addNewTransaction(Transfers transfer, int fromAccountId, int toAccountId) async {
    return await apiClient.postData('${AppConstants.TRANSACTION_ADD_URI}',{
      'account_from_id': fromAccountId,
      'account_to_id': toAccountId,
      'amount': transfer.amount,
      'description': transfer.description,
      'date' : transfer.date
    });
  }


}