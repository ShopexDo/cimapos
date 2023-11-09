import 'package:flutter/material.dart';

class PlaceOrderBody {
  List<Cart> _cart;
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



  PlaceOrderBody(
      {@required List<Cart> cart,
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
    this._cart = cart;
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

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  double get orderAmount => _orderAmount;
  int get userId => _userId;
  double get collectedCash => _collectedCash;
  double get extraDiscount => _extraDiscount;
  double get returnedAmount => _returnedAmount;
  int get type => _type;
  String get transactionRef => _transactionRef;
  String get extraDiscountType => _extraDiscountType;


  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
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
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
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

class Cart {
  String _productId;
  String _price;
  double _discountAmount;
  int _quantity;
  double _taxAmount;


  Cart(
      String productId,
        String price,
        double discountAmount,
        int quantity,
        double taxAmount,
      ) {
    this._productId = productId;
    this._price = price;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;

  }

  String get productId => _productId;
  String get price => _price;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;


  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['id'];
    _price = json['price'];
    _discountAmount = json['discount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._productId;
    data['price'] = this._price;
    data['discount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax'] = this._taxAmount;
    return data;
  }
}
