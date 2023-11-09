import 'package:flutter/material.dart';

class PlaceBillBody {
  int _quoteId;
  double _couponDiscountAmount;
  double _orderAmount;
  String _couponCode;
  int _userId;
  double _collectedCash;
  double _extraDiscount;
  double _returnedAmount;
  int _type;
  String _transactionRef;
  String _extraDiscountType;



  PlaceBillBody(
      {
        int quoteId,
        double couponDiscountAmount,
        String couponCode,
        double orderAmount,
        int userId,
        double collectedCash,
        double extraDiscount,
        double returnedAmount,
        int type,
        String transactionRef,
        String extraDiscountType,


       }) {
    this._quoteId = quoteId;
    this._couponDiscountAmount = couponDiscountAmount;
    this._orderAmount = orderAmount;
    this._userId = userId;
    this._collectedCash = collectedCash;
    this._extraDiscount = extraDiscount;
    this._returnedAmount = returnedAmount;
    this._type =type;
    this._transactionRef = transactionRef;
    this._extraDiscountType = extraDiscountType;

  }

  int get quoteId => _quoteId;
  double get couponDiscountAmount => _couponDiscountAmount;
  double get orderAmount => _orderAmount;
  int get userId => _userId;
  double get collectedCash => _collectedCash;
  double get extraDiscount => _extraDiscount;
  double get returnedAmount => _returnedAmount;
  int get type => _type;
  String get transactionRef => _transactionRef;
  String get extraDiscountType => _extraDiscountType;


  PlaceBillBody.fromJson(Map<String, dynamic> json) {
    _quoteId = json['quote_id'];
    _couponDiscountAmount = json['coupon_discount'];
    _orderAmount = json['order_amount'];
    _userId = json['user_id'];
    _collectedCash = json['collected_cash'];
    _extraDiscount = json['extra_discount'];
    _returnedAmount = json['remaining_balance'];
    _type = json ['type'];
    _transactionRef = json ['transaction_reference'];
    _extraDiscountType = json ['extra_discount_type'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quote_id'] = this._quoteId;
    data['coupon_discount'] = this._couponDiscountAmount;
    data['order_amount'] = this._orderAmount;
    data['coupon_code'] = this._couponCode;
    data['user_id'] = this._userId;
    data['collected_cash'] = this._collectedCash;
    data['extra_discount'] = this._extraDiscount;
    data['remaining_balance'] = this._returnedAmount;
    data['type'] = this._type;
    data['transaction_reference'] = this._transactionRef;
    data['extra_discount_type'] = this._extraDiscountType;

    return data;
  }
}