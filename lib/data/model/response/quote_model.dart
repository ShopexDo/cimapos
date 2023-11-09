class QuoteModel {
  int _total;
  String _limit;
  String _offset;
  List<Quotes> _quotes;

  QuoteModel(
      {int total, String limit, String offset, List<Quotes> quotes}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (quotes != null) {
      this._quotes = quotes;
    }
  }

  int get total => _total;
  String get limit => _limit;
  String get offset => _offset;
  List<Quotes> get quotes => _quotes;


  QuoteModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['quotes'] != null) {
      _quotes = <Quotes>[];
      json['quotes'].forEach((v) {
        _quotes.add(new Quotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._quotes != null) {
      data['quotes'] = this._quotes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quotes {
  int _id;
  int _userId;
  double _quoteAmount;
  int _state;
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
  Client _client;

  Quotes(
      {int id,
        int userId,
        double quoteAmount,
        int state,
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
        Account account,
        Client client

      }) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (quoteAmount != null) {
      this._quoteAmount = quoteAmount;
    }
    if (state != null) {
      this._state = state;
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
    if (client != null) {
      this._client = client;
    }
  }

  int get id => _id;
  int get userId => _userId;
  double get quoteAmount => _quoteAmount;
  int get state => _state;
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
  Client get client => _client;


  Quotes.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if(json['user_id'] != null){
      _userId = int.parse(json['user_id'].toString());
    }

    if(json['quote_amount'] != null){
      try{
        _quoteAmount = json['quote_amount'].toDouble();
      }catch(e){
        _quoteAmount = double.parse(json['quote_amount'].toString());
      }
    }

    if(json['state'] != null){
      _state = int.parse(json['state'].toString());
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
    _client = json['client'] != null?  new Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['quote_amount'] = this._quoteAmount;
    data['state'] = this._state;
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
    if (this._client != null) {
      data['client'] = this._client.toJson();
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

class Client {
  int _id;
  String _name;
  String _mobile;

  Client(
      {int id,
        String name,
        String mobile,
      }) {
    if (id != null) {
      this._id = id;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
  }

  int get id => _id;
  String get name => _name;
  String get mobile => _mobile;

  Client.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['mobile'] = this._mobile;
    return data;
  }
}