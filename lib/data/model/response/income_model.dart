class IncomeModel {
  int _total;
  int _limit;
  int _offset;
  List<Incomes> _incomes;

  IncomeModel({int total, int limit, int offset, List<Incomes> incomes}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (incomes != null) {
      this._incomes = incomes;
    }
  }

  int get total => _total;
  int get limit => _limit;
  int get offset => _offset;
  List<Incomes> get incomes => _incomes;

  IncomeModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = int.parse(json['limit'].toString());
    _offset = int.parse(json['offset'].toString());
    if (json['incomes'] != null) {
      _incomes = <Incomes>[];
      json['incomes'].forEach((v) {
        _incomes.add(new Incomes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._incomes != null) {
      data['incomes'] = this._incomes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Incomes {
  int _id;
  String _tranType;
  int _accountId;
  double _amount;
  String _description;
  double _debit;
  double _credit;
  double _balance;
  String _date;
  Account _account;

  Incomes(
      {int id,
        String tranType,
        int accountId,
        double amount,
        String description,
        double debit,
        double credit,
        double balance,
        String date,
        Account account}) {
    if (id != null) {
      this._id = id;
    }
    if (tranType != null) {
      this._tranType = tranType;
    }
    if (accountId != null) {
      this._accountId = accountId;
    }
    if (amount != null) {
      this._amount = amount;
    }
    if (description != null) {
      this._description = description;
    }
    if (debit != null) {
      this._debit = debit;
    }
    if (credit != null) {
      this._credit = credit;
    }
    if (balance != null) {
      this._balance = balance;
    }
    if (date != null) {
      this._date = date;
    }
    if (account != null) {
      this._account = account;
    }
  }

  int get id => _id;
  String get tranType => _tranType;
  int get accountId => _accountId;
  double get amount => _amount;
  String get description => _description;
  double get debit => _debit;
  double get credit => _credit;
  double get balance => _balance;
  String get date => _date;
  Account get account => _account;


  Incomes.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _tranType = json['tran_type'];
    if(json['account_id'] != null){
      _accountId = int.parse(json['account_id'].toString());
    }

    if(json['amount'] != null){
      try{
        _amount = json['amount'].toDouble();
      }catch(e){
        _amount = double.parse(json['amount'].toString());
      }
    }

    _description = json['description'];
    if(json['debit'] != null){
      try{
        _debit = json['debit'].toDouble();
      }catch(e){
        _debit = double.parse(json['debit'].toString());
      }
    }
    if(json['credit'] != null){
      try{
        _credit = json['credit'].toDouble();
      }catch(e){
        _credit = double.parse(json['credit'].toString());
      }
    }


    if(json['balance'] != null){
      try{
        _balance = json['balance'].toDouble();
      }catch(e){
        _balance = double.parse(json['balance'].toString());
      }
    }

    _date = json['date'];

    _account = json['account'] != null?  new Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['tran_type'] = this._tranType;
    data['account_id'] = this._accountId;
    data['amount'] = this._amount;
    data['description'] = this._description;
    data['debit'] = this._debit;
    data['credit'] = this._credit;
    data['balance'] = this._balance;
    data['date'] = this._date;
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
