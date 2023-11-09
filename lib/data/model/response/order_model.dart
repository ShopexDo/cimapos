class OrderModel {
  int _total;
  String _limit;
  String _offset;
  List<Orders> _orders;

  OrderModel(
      {int total, String limit, String offset, List<Orders> orders}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (orders != null) {
      this._orders = orders;
    }
  }

  int get total => _total;
  String get limit => _limit;
  String get offset => _offset;
  List<Orders> get orders => _orders;


  OrderModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['orders'] != null) {
      _orders = <Orders>[];
      json['orders'].forEach((v) {
        _orders.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._orders != null) {
      data['orders'] = this._orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int _id;
  int _userId;
  double _orderAmount;
  double _totalTax;
  double _collectedCash;
  double _extraDiscount;
  String _couponCode;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  int _paymentId;
  String _transactionReference;
  String _createdAt;
  String _updatedAt;
  Account _account;

  Orders(
      {int id,
        int userId,
        double orderAmount,
        double totalTax,
        double collectedCash,
        double extraDiscount,
        String couponCode,
        double couponDiscountAmount,
        String couponDiscountTitle,
        int paymentId,
        String transactionReference,
        String createdAt,
        String updatedAt,
        Account account

      }) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (orderAmount != null) {
      this._orderAmount = orderAmount;
    }
    if (totalTax != null) {
      this._totalTax = totalTax;
    }
    if (collectedCash != null) {
      this._collectedCash = collectedCash;
    }
    if (extraDiscount != null) {
      this._extraDiscount = extraDiscount;
    }
    if (couponCode != null) {
      this._couponCode = couponCode;
    }
    if (couponDiscountAmount != null) {
      this._couponDiscountAmount = couponDiscountAmount;
    }
    if (couponDiscountTitle != null) {
      this._couponDiscountTitle = couponDiscountTitle;
    }
    if (paymentId != null) {
      this._paymentId = paymentId;
    }
    if (transactionReference != null) {
      this._transactionReference = transactionReference;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (account != null) {
      this._account = account;
    }
  }

  int get id => _id;
  int get userId => _userId;
  double get orderAmount => _orderAmount;
  double get totalTax => _totalTax;
  double get collectedCash => _collectedCash;
  double get extraDiscount => _extraDiscount;
  String get couponCode => _couponCode;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  int get paymentId => _paymentId;
  String get transactionReference => _transactionReference;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  Account get account => _account;


  Orders.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if(json['user_id'] != null){
      _userId = int.parse(json['user_id'].toString());
    }

    if(json['order_amount'] != null){
      try{
        _orderAmount = json['order_amount'].toDouble();
      }catch(e){
        _orderAmount = double.parse(json['order_amount'].toString());
      }
    }

    if(json['total_tax'] != null){
      try{
        _totalTax = json['total_tax'].toDouble();
      }catch(e){
        _totalTax = double.parse(json['total_tax'].toString());
      }

    }else{
      _totalTax = 0.0;
    }
    if(json['collected_cash'] != null){
      try{
        _collectedCash = json['collected_cash'].toDouble();
      }catch(e){
        _collectedCash =double.parse(json['collected_cash'].toString());
      }

    }else{
      _collectedCash = 0.0;
    }

    if(json['extra_discount'] != null){
      try{
        _extraDiscount = json['extra_discount'].toDouble();
      }catch(e){
        _extraDiscount = double.parse(json['extra_discount'].toString());
      }

    }else{
      _extraDiscount = 0.0;
    }

    _couponCode = json['coupon_code'];
    if(json['coupon_discount_amount'] != null){
      try{
        _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
      }catch(e){
        _couponDiscountAmount = double.parse(json['coupon_discount_amount'].toString());
      }

    }else{
      _couponDiscountAmount = 0.0;
    }

    _couponDiscountTitle = json['coupon_discount_title'];
    if(json['payment_id'] != null){
      _paymentId = int.parse(json['payment_id'].toString());
    }

    _transactionReference = json['transaction_reference'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _account = json['account'] != null?  new Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['order_amount'] = this._orderAmount;
    data['total_tax'] = this._totalTax;
    data['collected_cash'] = this._collectedCash;
    data['extra_discount'] = this._extraDiscount;
    data['coupon_code'] = this._couponCode;
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['payment_id'] = this._paymentId;
    data['transaction_reference'] = this._transactionReference;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._account != null) {
      data['account'] = this._account.toJson();
    }
    return data;
  }
}

class Account {
  int _id;
  String _account;
  String _description;
  double _balance;



  Account(
      {int id,
        String account,
        String description,
        double balance,
      }) {
    if (id != null) {
      this._id = id;
    }
    if (account != null) {
      this._account = account;
    }
    if (description != null) {
      this._description = description;
    }
    if (balance != null) {
      this._balance = balance;
    }


  }

  int get id => _id;
  String get account => _account;
  String get description => _description;
  double get balance => _balance;


  Account.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _account = json['account'];
    _description = json['description'];
    if(json['balance'] != null){
      try{
        _balance = json['balance'].toDouble();
      }catch(e){
        _balance = double.parse(json['balance'].toString());
      }
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['account'] = this._account;
    data['description'] = this._description;
    data['balance'] = this._balance;
    return data;
  }
}
