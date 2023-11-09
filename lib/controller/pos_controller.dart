import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/data/repository/pos_repo.dart';

class PosController extends GetxController implements GetxService{
  final PosRepo posRepo;
  PosController({@required this.posRepo});



  List<Products> _productList;
  List<Products> get productList =>_productList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _customerIndex = 0;
  int get customerIndex => _customerIndex;

  List<int> _customerIds = [];
  List<int> get customerIds => _customerIds;

  List<Customers> _customerList;
  List<Customers> get customerList =>_customerList;

  int _customerSelectedIndex = 0;
  int get customerSelectedIndex => _customerSelectedIndex;

  Future<void> getCustomerList( int offset) async {

    _customerIndex = 0;
    _customerIds.add(0);
    Response response = await posRepo.getCustomerList(offset);
    if(response.statusCode == 200) {
      _customerList = [];
      _customerList.addAll(CustomerModel.fromJson(response.body).customers);
      _customerIndex = 0;
      for(int index = 0; index < _customerList.length; index++) {
        _customerIds.add(_customerList[index].id);
      }


    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void setCustomerIndex(int index, bool notify) {
    _customerIndex = index;
    if(notify) {
      update();
    }
  }

  void changeCustomerSelectedIndex(int selectedIndex) {
    _customerSelectedIndex = selectedIndex;
    update();
  }

}