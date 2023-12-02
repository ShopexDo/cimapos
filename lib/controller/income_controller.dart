import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/income_model.dart';
import 'package:cimapos/data/repository/income_repo.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';

class IncomeController extends GetxController implements GetxService{
  final IncomeRepo incomeRepo;
  IncomeController({@required this.incomeRepo});
  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int _incomeListLength;
  int get incomeListLength => _incomeListLength;
  List<Incomes> _incomeList = [];
  List<Incomes> get incomeList =>_incomeList;
  int _accountTypeIndex = 0;
  int get accountTypeIndex => _accountTypeIndex;

  Future<void> getIncomeList( int offset, {bool reload = true}) async {
    if(reload || offset == 1){
      _incomeList =[];
    }
    _isLoading = true;
    Response response = await incomeRepo.getIncomeList(offset);
    if(response.statusCode == 200) {
      _incomeList.addAll(IncomeModel.fromJson(response.body).incomes);
      _incomeListLength = (IncomeModel.fromJson(response.body).total/10).ceil();
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getIncomeFilter(String startDate, String endDate) async {
    _incomeList = [];
    _isLoading = true;
    Response response = await incomeRepo.getIncomesFilter(startDate, endDate);
    if(response.statusCode == 200) {
      _incomeList = [];
      _incomeList.addAll(IncomeModel.fromJson(response.body).incomes);
      _incomeListLength = IncomeModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> addIncome(Incomes income) async {
    _isLoading = true;
    Response response = await incomeRepo.addNewIncome(income);
    if(response.statusCode == 200) {
      getIncomeList(1, reload: true);
      Get.back();
      showCustomSnackBar( 'income_created_successfully'.tr, isError: false);
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