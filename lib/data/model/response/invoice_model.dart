class InvoiceModel {
  bool _success;
  Invoice _invoice;

  InvoiceModel({bool success, Invoice invoice}) {
    if (success != null) {
      this._success = success;
    }
    if (invoice != null) {
      this._invoice = invoice;
    }
  }

  bool get success => _success;
  Invoice get invoice => _invoice;


  InvoiceModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _invoice =
    json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    if (this._invoice != null) {
      data['invoice'] = this._invoice.toJson();
    }
    return data;
  }
}

class Invoice {
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
  List<Details> _details;
  Account _account;

  Invoice(
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
        List<Details> details,
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
    if (details != null) {
      this._details = details;
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
  List<Details> get details => _details;
  Account get account => _account;





  Invoice.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = int.parse(json['user_id'].toString());
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
        _collectedCash = double.parse(json['collected_cash'].toString());
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
    if(json['coupon_code'] != null){
      _couponCode = json['coupon_code'];
    }else{
      _couponCode = '';
    }

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
    _paymentId = int.parse(json['payment_id'].toString());
    _transactionReference = json['transaction_reference'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['details'] != null) {
      _details = <Details>[];
      json['details'].forEach((v) {
        _details.add(new Details.fromJson(v));
      });
    }
    _account = json['account'] != null ? new Account.fromJson(json['account']) : null;
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
    if (this._details != null) {
      data['details'] = this._details.map((v) => v.toJson()).toList();
    }
    if (this._account != null) {
      data['account'] = this._account.toJson();
    }
    return data;
  }
}

class Details {
  int _id;
  int _productId;
  int _orderId;
  double _price;
  String _productDetails;
  double _discountOnProduct;
  String _discountType;
  int _quantity;
  double _taxAmount;
  String _createdAt;
  String _updatedAt;

  Details(
      {int id,
        int productId,
        int orderId,
        double price,
        String productDetails,
        double discountOnProduct,
        String discountType,
        int quantity,
        double taxAmount,
        String createdAt,
        String updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (productId != null) {
      this._productId = productId;
    }
    if (orderId != null) {
      this._orderId = orderId;
    }
    if (price != null) {
      this._price = price;
    }
    if (productDetails != null) {
      this._productDetails = productDetails;
    }
    if (discountOnProduct != null) {
      this._discountOnProduct = discountOnProduct;
    }
    if (discountType != null) {
      this._discountType = discountType;
    }
    if (quantity != null) {
      this._quantity = quantity;
    }
    if (taxAmount != null) {
      this._taxAmount = taxAmount;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int get id => _id;
  int get productId => _productId;
  int get orderId => _orderId;
  double get price => _price;
  String get productDetails => _productDetails;
  double get discountOnProduct => _discountOnProduct;
  String get discountType => _discountType;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = int.parse(json['product_id'].toString());
    _orderId = int.parse(json['order_id'].toString());
    if(json['price'] != null){
      try{
        _price = json['price'].toDouble();
      }catch(e){
        _price = double.parse(json['price'].toString());
      }
    }

    _productDetails = json['product_details'];
    if(json['discount_on_product'] != null){
      try{
        _discountOnProduct = json['discount_on_product'].toDouble();
      }catch(e){
        _discountOnProduct = double.parse(json['discount_on_product'].toString());
      }

    }else{
      _discountOnProduct = 0.0;
    }

    _discountType = json['discount_type'];
    _quantity = int.parse(json['quantity'].toString());
    if(json['tax_amount'] != null){
      try{
        _taxAmount = json['tax_amount'].toDouble();
      }catch(e){
        _taxAmount = double.parse(json['tax_amount'].toString());
      }

    }else{
      _taxAmount =0.0;
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['price'] = this._price;
    data['product_details'] = this._productDetails;
    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
class Account {
  int _id;
  String _account;
  Account(
      {int id,
        String account,
      }) {
    if (id != null) {
      this._id = id;
    }
    if (account != null) {
      this._account = account;
    }

  }

  int get id => _id;
  String get account => _account;


  Account.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _account = json['account'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['account'] = this._account;
    return data;
  }
}