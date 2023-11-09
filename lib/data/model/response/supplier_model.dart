class SupplierModel {
  int _total;
  int _limit;
  int _offset;
  List<Suppliers> _suppliers;

  SupplierModel(
      {int total, int limit, int offset, List<Suppliers> suppliers}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (suppliers != null) {
      this._suppliers = suppliers;
    }
  }

  int get total => _total;
  int get limit => _limit;
  int get offset => _offset;
  List<Suppliers> get suppliers => _suppliers;


  SupplierModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = int.parse(json['limit'].toString());
    _offset = int.parse(json['offset'].toString());
    if (json['suppliers'] != null) {
      _suppliers = <Suppliers>[];
      json['suppliers'].forEach((v) {
        _suppliers.add(new Suppliers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._suppliers != null) {
      data['suppliers'] = this._suppliers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suppliers {
  int _id;
  String _name;
  String _mobile;
  String _email;
  String _image;
  String _state;
  String _city;
  String _zipCode;
  String _address;
  double _dueAmount;
  String _createdAt;
  String _updatedAt;
  int _productCount;


  Suppliers(
      {int id,
        String name,
        String mobile,
        String email,
        String image,
        String state,
        String city,
        String zipCode,
        String address,
        double dueAmount,
        String createdAt,
        String updatedAt,
        int productCount,
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
    if (dueAmount != null) {
      this._dueAmount = dueAmount;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (productCount != null) {
      this._productCount = productCount;
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
  double get dueAmount => _dueAmount;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get productCount => _productCount;


  Suppliers.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];
   if(json['due_amount'] != null){
     try{
       _dueAmount = json['due_amount'].toDouble();
     }catch(e){
       _dueAmount = double.parse(json['due_amount'].toString());
     }

   }else{
     _dueAmount = 0.0;
   }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['products_count'] != null){
      _productCount = int.parse(json['products_count'].toString());
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
    data['due_amount'] = this._dueAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['products_count'] = this._productCount;

    return data;
  }
}
