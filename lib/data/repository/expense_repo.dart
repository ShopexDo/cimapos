import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/data/model/response/expenseModel.dart';
import 'package:six_pos/util/app_constants.dart';



class ExpenseRepo{
  ApiClient apiClient;
  ExpenseRepo({@required this.apiClient});

  Future<Response> getExpenseList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_EXPENSE_LIST}?limit=10&offset=$offset');
  }

  Future<Response> getExpenseFilter(String startDate, String endDate) async {
    return await apiClient.getData('${AppConstants.EXPENSE_FILTER_BY_DATE}?from=$startDate&to=$endDate');
  }

  Future<Response> deleteExpense(int expenseId) async {
    return await apiClient.getData('${AppConstants.DELETE_EXPENSE_URI}?id=$expenseId');
  }

  Future<Response> addNewExpense(Expenses expense, { bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate? '${AppConstants.UPDATE_EXPENSE_URI}':'${AppConstants.ADD_NEW_EXPENSE}',{
      'id': expense.id,
      'account_id': expense.accountId,
      'amount': expense.amount,
      'description': expense.description,
      'date': expense.date
    });
  }


}