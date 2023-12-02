import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/response/invoice_model.dart';
import 'package:cimapos/data/model/response/order_model.dart';
import 'package:cimapos/data/repository/order_repo.dart';

class OrderController extends GetxController implements GetxService{
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  List<Orders> _orderList =[];
  bool _isLoading = false;
  List<Orders> get orderList => _orderList;
  bool get isLoading => _isLoading;
  int _orderListLength;
  int get orderListLength => _orderListLength;
  bool _isFirst = true;
  bool get isFirst => _isFirst;

  Invoice _invoice;
  Invoice get invoice => _invoice;
  double _discountOnProduct = 0;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;
  int _offset = 1;
  int get offset => _offset;


  Future<void> getOrderList(String offset, {bool reload = false}) async {
    _offset = int.parse(offset);
    if(reload){
      _orderList = [];
      _isFirst = true;
    }
    _isLoading = true;
    update();

    Response response = await orderRepo.getOrderList(offset);
    if(response.statusCode == 200) {
      _orderList.addAll(OrderModel.fromJson(response.body).orders);
      _orderListLength = OrderModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  void setOffset(int offset) {
    _offset = _offset + 1;
  }

  Future<void> getInvoiceData(int orderId) async {
    _isLoading = true;
    Response response = await orderRepo.getInvoiceData(orderId);
    if(response.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
     _invoice = InvoiceModel.fromJson(response.body).invoice;
     for(int i=0; i< _invoice.details.length; i++ ){
       _discountOnProduct += invoice.details[i].discountOnProduct;
       _totalTaxAmount += invoice.details[i].taxAmount;
     }
     _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
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

}