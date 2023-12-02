import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/account_model.dart';
import 'package:cimapos/data/model/response/earning_statistics_model.dart';
import 'package:cimapos/data/repository/account_repo.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';

class AccountController extends GetxController implements GetxService{
  final AccountRepo accountRepo;
  AccountController({@required this.accountRepo});
  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int _accountListLength;
  int get accountListLength => _accountListLength;
  List<Accounts> _accountList = [];
  List<Accounts> get accountList =>_accountList;

  double _mmE = 0;
  double get mmE=>_mmE;
  double _mmI = 0;
  double get mmI => _mmI;
  double _maxValueForChard = 0;
  double get maxValueForChard=>_maxValueForChard;


  List <YearWiseExpense> _yearWiseExpenseList =[];
  List <YearWiseExpense> get yearWiseExpenseList => _yearWiseExpenseList;
  List <YearWiseIncome> _yearWiseIncomeList =[];
  List <YearWiseIncome> get yearWiseIncomeList => _yearWiseIncomeList;

  List <YearWiseExpense> _filterExpenseList =[];
  List <YearWiseExpense> get filterExpenseList => _filterExpenseList;

   List<double> _expanseList = [0,0,0,0,0,0,0,0,0,0,0,0];
   List<double> get expanseList => _expanseList;

  List<double> _incomeList = [0,0,0,0,0,0,0,0,0,0,0,0];
  List<double> get incomeList => _incomeList;


  List<FlSpot> _expanseChartList = [];
  List<FlSpot> get expanseChartList =>_expanseChartList;
  List<FlSpot> _incomeChartList = [];
  List<FlSpot> get incomeChartList => _incomeChartList;

  int _accountIndex = 0;
  int get accountIndex => _accountIndex;

  List<int> _accountIds = [];
  List<int> get accountIds => _accountIds;

  List<int> _incomeMonthList = [];
  List<int> get incomeMonthList => _incomeMonthList;

  List<int> _expenseMonthList = [];
  List<int> get expenseMonthList => _expenseMonthList;






  Future<void> getAccountList( int offset, {bool reload = false}) async {
    if(reload){
      _accountList = [];
    }
    _accountIndex = 0;
    _accountIds = [];
    _isLoading = true;
    Response response = await accountRepo.getAccountList(offset);
    if(response.statusCode == 200) {
      _accountList.addAll(AccountModel.fromJson(response.body).accounts);
      _accountListLength = AccountModel.fromJson(response.body).total;
      if(_accountList.length != 0){
        for(int index = 0; index < _accountList.length; index++) {
          _accountIds.add(_accountList[index].id);
        }
        _accountIndex = _accountIds[0];
      }

      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> searchAccount(String search) async {
    _accountList = [];
    _isLoading = true;
    Response response = await accountRepo.searchAccount(search);
    if(response.statusCode == 200) {
      _accountList = [];
      _accountList.addAll(AccountModel.fromJson(response.body).accounts);
      _accountListLength = AccountModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<void> deleteAccount(int accountId) async {
    _isLoading = true;
    Response response = await accountRepo.deleteAccountId(accountId);
    if(response.statusCode == 200) {
      getAccountList(1, reload: true);
      _isLoading = false;
      Get.back();
      showCustomSnackBar('account_deleted_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addAccount(Accounts account, bool isUpdate) async {
    _isLoading = true;
    Response response = await accountRepo.addAccount(account, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getAccountList(1, reload:  true);
      Get.back();
      showCustomSnackBar(isUpdate ? 'account_updated_successfully'.tr : 'account_created_successfully'.tr, isError: false);
      _isLoading = false;
    }else if(response.statusCode == 403){
      showCustomSnackBar('account_name_already_exist'.tr);
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


  Future<void> getRevenueDataForChart(int year) async {
    _yearWiseExpenseList = [];
    _yearWiseIncomeList = [];
    _incomeMonthList =[];
    _expenseMonthList = [];
    _isLoading = true;
    Response response = await accountRepo.getRevenueChartData();
    if(response.statusCode == 200) {
     _yearWiseExpenseList = [];
     _yearWiseIncomeList = [];
     _expanseChartList = [];
     _incomeChartList = [];
     _yearWiseExpenseList.addAll(RevenueChartModel.fromJson(response.body).yearWiseExpense);
     _yearWiseIncomeList.addAll(RevenueChartModel.fromJson(response.body).yearWiseIncome);


     _expanseList = [];
     _incomeList = [];
     for(int i= 0; i<= 12; i++){
       _expanseList.add(0);
       _incomeList.add(0);
     }

     for(int i = 0; i< yearWiseExpenseList.length; i++){
       _expanseList[yearWiseExpenseList[i].month] = double.parse(yearWiseExpenseList[i].totalAmount.toStringAsFixed(2));
     }

     for(int i = 0; i< yearWiseIncomeList.length; i++){
       _incomeList[yearWiseIncomeList[i].month] = double.parse(yearWiseIncomeList[i].totalAmount.toStringAsFixed(2));
     }

     print('-------$_incomeList/$_expanseList}');

     _expanseChartList = _expanseList.asMap().entries.map((e) {
       return FlSpot(e.key.toDouble(), e.value);
     }).toList();

     _incomeChartList = _incomeList.asMap().entries.map((e) {
       return FlSpot(e.key.toDouble(), e.value);
     }).toList();

     _expanseList.sort();
     _incomeList.sort();

     _mmE = _expanseList[_expanseList.length-1];
     _mmI = _incomeList[_incomeList.length-1];

      _maxValueForChard = _mmE> _mmI? _mmE : _mmI;


     print('===income===>${_incomeChartList.toList()} && =====Expense =====>${_expanseChartList.toList()} ==MAXX==>$_maxValueForChard');

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void filterByYear(int year){
    for(int i =0; i< _yearWiseExpenseList.length; i++){
      if(_yearWiseExpenseList[i].year ==year){
        _filterExpenseList.add(_yearWiseExpenseList[i]);
      }
    }
  }

  void setAccountIndex(int index, bool notify) {
    _accountIndex = index;

    print('=ID===>$index');
    if(notify) {
      update();
    }
  }


}