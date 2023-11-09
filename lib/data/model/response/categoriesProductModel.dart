class CategoriesProduct {
  int _id;
  String _title;
  String _productCode;
  int _unitType;
  int _unitValue;
  Brand _brand;
  List<CategoryIds> _categoryIds;
  double _purchasePrice;
  double _sellingPrice;
  String _discountType;
  double _discount;
  double _tax;
  int _quantity;
  String _image;
  Supplier _supplier;

  CategoriesProduct(
      {int id,
        String title,
        String productCode,
        int unitType,
        int unitValue,
        Brand brand,
        List<CategoryIds> categoryIds,
        double purchasePrice,
        double sellingPrice,
        String discountType,
        double discount,
        double tax,
        int quantity,
        String image,
        Supplier supplier}) {
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (productCode != null) {
      this._productCode = productCode;
    }
    if (unitType != null) {
      this._unitType = unitType;
    }
    if (unitValue != null) {
      this._unitValue = unitValue;
    }
    if (brand != null) {
      this._brand = brand;
    }
    if (categoryIds != null) {
      this._categoryIds = categoryIds;
    }
    if (purchasePrice != null) {
      this._purchasePrice = purchasePrice;
    }
    if (sellingPrice != null) {
      this._sellingPrice = sellingPrice;
    }
    if (discountType != null) {
      this._discountType = discountType;
    }
    if (discount != null) {
      this._discount = discount;
    }
    if (tax != null) {
      this._tax = tax;
    }
    if (quantity != null) {
      this._quantity = quantity;
    }
    if (image != null) {
      this._image = image;
    }
    if (supplier != null) {
      this._supplier = supplier;
    }
  }

  int get id => _id;
  String get title => _title;
  String get productCode => _productCode;
  int get unitType => _unitType;
  int get unitValue => _unitValue;
  Brand get brand => _brand;
  List<CategoryIds> get categoryIds => _categoryIds;
  double get purchasePrice => _purchasePrice;
  double get sellingPrice => _sellingPrice;
  String get discountType => _discountType;
  double get discount => _discount;
  double get tax => _tax;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  set quantity(int quantity) => _quantity = quantity;
  String get image => _image;
  Supplier get supplier => _supplier;


  CategoriesProduct.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _productCode = json['product_code'];
    if(json['unit_type'] != null){
      _unitType = int.parse(json['unit_type'].toString());
    }

    if(json['unit_value'] != null){
      _unitValue = int.parse(json['unit_value'].toString());
    }

    _brand = json['brand'] != null?  new Brand.fromJson(json['brand']) : null;
    if (json['category_ids'] != null) {
      _categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        _categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    if(json['purchase_price'] != null){
      try{
        _purchasePrice = json['purchase_price'].toDouble();
      }catch(e){
        _purchasePrice = double.parse(json['purchase_price'].toString());
      }
      
    }else{
      _purchasePrice = 0.0;
    }

    if(json['selling_price'] != null){
      try{
        _sellingPrice = json['selling_price'].toDouble();
      }catch(e){
        _sellingPrice = double.parse(json['selling_price'].toString());
      }
      
    }else{
      _sellingPrice = 0.0;
    }

    _discountType = json['discount_type'];
    if(json['discount'] != null){
      try{
        _discount = json['discount'].toDouble();
      }catch(e){
        _discount = double.parse(json['discount'].toString());
      }
      
    }else{
      _discount = 0.0;
    }

    if(json['tax'] != null){
      try{
        _tax = json['tax'].toDouble();
      }catch(e){
        _tax = double.parse(json['tax'].toString());
      }
      
    }else{
      _tax = 0.0;
    }
    _quantity = int.parse(json['quantity'].toString());
    _image = json['image'];
    _supplier = json['supplier'] != null?
         new Supplier.fromJson(json['supplier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['product_code'] = this._productCode;
    data['unit_type'] = this._unitType;
    data['unit_value'] = this._unitValue;
    if (this._brand != null) {
      data['brand'] = this._brand.toJson();
    }
    if (this._categoryIds != null) {
      data['category_ids'] = this._categoryIds.map((v) => v.toJson()).toList();
    }
    data['purchase_price'] = this._purchasePrice;
    data['selling_price'] = this._sellingPrice;
    data['discount_type'] = this._discountType;
    data['discount'] = this._discount;
    data['tax'] = this._tax;
    data['quantity'] = this._quantity;
    data['image'] = this._image;
    if (this._supplier != null) {
      data['supplier'] = this._supplier.toJson();
    }
    return data;
  }
}

class CategoryIds {
  String _id;
  int _position;

  CategoryIds({String id, int position}) {
    if (id != null) {
      this._id = id;
    }
    if (position != null) {
      this._position = position;
    }
  }

  String get id => _id;
  int get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['position'] = this._position;
    return data;
  }
}

class Brand {
  int _id;
  String _name;
  String _image;



  Brand(
      {int id,
        String name,
        String image,

      }) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (image != null) {
      this._image = image;
    }


  }

  int get id => _id;
  String get name => _name;
  String get image => _image;



  Brand.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;

    return data;
  }
}

class Supplier {
  int _id;
  String _name;
  String _mobile;
  String _email;
  String _image;
  String _state;
  String _city;
  String _zipCode;
  String _address;


  Supplier(
      {int id,
        String name,
        String mobile,
        String email,
        String image,
        String state,
        String city,
        String zipCode,
        String address,
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

  }

  int get id => _id;
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get image => _image;
  String get state => _state;
  String get city => _city;
  String get zipCode => _zipCode;


  Supplier.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];

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

    return data;
  }
}
