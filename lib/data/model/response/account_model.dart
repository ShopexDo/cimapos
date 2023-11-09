class AccountModel {
  int _total;
  int _limit;
  int _offset;
  List<Accounts> _accounts;

  AccountModel(
      {int total, int limit, int offset, List<Accounts> accounts}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (accounts != null) {
      this._accounts = accounts;
    }
  }

  int get total => _total;
  int get limit => _limit;
  int get offset => _offset;
  List<Accounts> get accounts => _accounts;


  AccountModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = int.parse(json['limit'].toString());
    _offset = int.parse(json['offset'].toString());
    if (json['accounts'] != null) {
      _accounts = <Accounts>[];
      json['accounts'].forEach((v) {
        _accounts.add(new Accounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._accounts != null) {
      data['accounts'] = this._accounts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Accounts {
  int _id;
  String _account;
  String _description;
  double _balance;
  String _accountNumber;
  double _totalIn;
  double _totalOut;
  String _createdAt;
  String _updatedAt;


  Accounts(
      {int id,
        String account,
        String description,
        double balance,
        String accountNumber,
        double totalIn,
        double totalOut,
        String createdAt,
        String updatedAt,
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
    if (accountNumber != null) {
      this._accountNumber = accountNumber;
    }
    if (totalIn != null) {
      this._totalIn = totalIn;
    }
    if (totalOut != null) {
      this._totalOut = totalOut;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }

  }

  int get id => _id;
  String get account => _account;
  String get description => _description;
  double get balance => _balance;
  String get accountNumber => _accountNumber;
  double get totalIn => _totalIn;
  double get totalOut => _totalOut;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;


  Accounts.fromJson(Map<String, dynamic> json) {
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

    _accountNumber = json['account_number'];
    if(json['total_in'] != null){
      try{
        _totalIn = json['total_in'].toDouble();
      }catch(e){
        _totalIn = double.parse(json['total_in'].toString());
      }

    }else{
      _totalIn = 0.0;
    }
    if(json['total_out'] != null){
      try{
        _totalOut = json['total_out'].toDouble();
      }catch(e){
        _totalOut = double.parse(json['total_out'].toString());
      }

    }else{
      _totalOut = 0.0;
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['account'] = this._account;
    data['description'] = this._description;
    data['balance'] = this._balance;
    data['account_number'] = this._accountNumber;
    data['total_in'] = this._totalIn;
    data['total_out'] = this._totalOut;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
