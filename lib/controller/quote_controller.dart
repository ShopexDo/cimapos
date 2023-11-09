import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/invoice_model.dart';
import 'package:six_pos/data/model/response/bill_model.dart';
import 'package:six_pos/data/model/response/quote_model.dart';
import 'package:six_pos/data/repository/quote_repo.dart';

class QuoteController extends GetxController implements GetxService{
  final QuoteRepo quoteRepo;
  QuoteController({@required this.quoteRepo});

  List<Quotes> _quoteList =[];
  bool _isLoading = false;
  List<Quotes> get quoteList => _quoteList;
  bool get isLoading => _isLoading;
  int _quoteListLength;
  int get quoteListLength => _quoteListLength;
  bool _isFirst = true;
  bool get isFirst => _isFirst;

  Bill _invoice;
  Bill get invoice => _invoice;
  double _discountOnProduct = 0;
  double get discountOnProduct => _discountOnProduct;

  double _totalTaxAmount = 0;
  double get totalTaxAmount => _totalTaxAmount;
  int _offset = 1;
  int get offset => _offset;


  Future<void> getQuoteList(String offset, {bool reload = false}) async {
    _offset = int.parse(offset);
    if(reload){
      _quoteList = [];
      _isFirst = true;
    }
    _isLoading = true;
    update();

    Response response = await quoteRepo.getQuoteList(offset);
    if(response.statusCode == 200) {
      _quoteList.addAll(QuoteModel.fromJson(response.body).quotes);
      _quoteListLength = QuoteModel.fromJson(response.body).total;
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

  Future<void> getQuoteData(int quoteId) async {
    _isLoading = true;
    Response response = await quoteRepo.getQuoteData(quoteId);
    if(response.statusCode == 200) {
      _discountOnProduct = 0;
      _totalTaxAmount = 0;
     _invoice = BillModel.fromJson(response.body).bill;
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

  Future<Response> approvedQuote(int quoteId) async {
    _isLoading = true;
    Response response = await quoteRepo.approvedQuote(quoteId);
    if(response.statusCode == 200) {
    //   _discountOnProduct = 0;
    //   _totalTaxAmount = 0;
    //  _invoice = BillModel.fromJson(response.body).bill;
    //  for(int i=0; i< _invoice.details.length; i++ ){
    //    _discountOnProduct += invoice.details[i].discountOnProduct;
    //    _totalTaxAmount += invoice.details[i].taxAmount;
    //  }
     _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
    return response;
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