import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/expenseModel.dart';
import 'package:six_pos/data/repository/expense_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';

class ExpenseController extends GetxController implements GetxService{
  final ExpenseRepo expenseRepo;
  ExpenseController({@required this.expenseRepo});
  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int _expenseListLength;
  int get expenseListLength => _expenseListLength;
  List<Expenses> _expenseList = [];
  List<Expenses> get expenseList =>_expenseList;
  int _accountTypeIndex = 0;
  int get accountTypeIndex => _accountTypeIndex;

  Future<void> getExpenseList( int offset, {bool reload = false}) async {
    if(reload){
      _expenseList = [];
    }
    _isLoading = true;
    Response response = await expenseRepo.getExpenseList(offset);
    if(response.statusCode == 200) {
      _expenseList.addAll(ExpenseModel.fromJson(response.body).expenses);
      _expenseListLength = ExpenseModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getExpenseFilter(String startDate, String endDate) async {
    print('===Expense filter$startDate and $endDate');
    _expenseList = [];
    _isLoading = true;
    Response response = await expenseRepo.getExpenseFilter(startDate, endDate);
    if(response.statusCode == 200) {
      _expenseList = [];
      _expenseList.addAll(ExpenseModel.fromJson(response.body).expenses);
      _expenseListLength = ExpenseModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deleteExpense(int expenseId) async {
    _isLoading = true;
    Response response = await expenseRepo.deleteExpense(expenseId);
    if(response.statusCode == 200) {
      getExpenseList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar('expense_deleted_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addExpense(Expenses expense , bool isUpdate) async {
    _isLoading = true;
    Response response = await expenseRepo.addNewExpense(expense, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getExpenseList(1, reload: true);
      Get.back();
      showCustomSnackBar(isUpdate? 'expense_updated_successfully'.tr : 'expense_created_successfully'.tr, isError: false);
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }




  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setAccountTypeIndex(int index, bool notify) {
    _accountTypeIndex = index;
    print('===accountType==$_accountTypeIndex');
    if(notify) {
      update();
    }
  }
  DateTime _startDate;
  DateTime _endDate;
  DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date;
      }else{
        _endDate = date;
      }
      if(date == null){
        print('Null');
      }
      update();
    });
  }



}