class CustomerModel {
  int _total;
  int _limit;
  int _offset;
  List<Customers> _customers;

  CustomerModel(
      {int total, int limit, int offset, List<Customers> customers}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (customers != null) {
      this._customers = customers;
    }
  }

  int get total => _total;
  int get limit => _limit;
  int get offset => _offset;
  List<Customers> get customers => _customers;


  CustomerModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = int.parse(json['limit'].toString());
    _offset = int.parse(json['offset'].toString());
    if (json['customers'] != null) {
      _customers = <Customers>[];
      json['customers'].forEach((v) {
        _customers.add(new Customers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._customers != null) {
      data['customers'] = this._customers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  int _id;
  String _name;
  String _mobile;
  String _email;
  String _image;
  String _state;
  String _city;
  String _zipCode;
  String _address;
  double _balance;
  String _createdAt;
  String _updatedAt;
  int _ordersCount;


  Customers(
      {int id,
        String name,
        String mobile,
        String email,
        String image,
        String state,
        String city,
        String zipCode,
        String address,
        double balance,
        String createdAt,
        String updatedAt,
        int ordersCount,
        }) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (email != null) {
      this._email = email;
    }
    if (image != null) {
      this._image = image;
    }
    if (state != null) {
      this._state = state;
    }
    if (city != null) {
      this._city = city;
    }
    if (zipCode != null) {
      this._zipCode = zipCode;
    }
    if (address != null) {
      this._address = address;
    }
    if (balance != null) {
      this._balance = balance;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }

    if (ordersCount != null) {
      this._ordersCount = ordersCount;
    }

  }

  int get id => _id;
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get image => _image;
  String get state => _state;
  String get city => _city;
  String get zipCode => _zipCode;
  String get address => _address;
  double get balance => _balance;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get orderCount => _ordersCount;


  Customers.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];
    if(json['balance'] != null){
     try{
       _balance = (json['balance']).toDouble();
     }catch(e){
       _balance = double.parse(json['balance'].toString());
     }
    }else{
      _balance = 0.0;
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['orders_count'] != null){
      _ordersCount = int.parse(json['orders_count'].toString());
    }else{
      _ordersCount = 0;
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['mobile'] = this._mobile;
    data['email'] = this._email;
    data['image'] = this._image;
    data['state'] = this._state;
    data['city'] = this._city;
    data['zip_code'] = this._zipCode;
    data['address'] = this._address;
    data['balance'] = this._balance;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['orders_count'] = this._ordersCount;

    return data;
  }
}
