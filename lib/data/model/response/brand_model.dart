class BrandModel {
  int _total;
  String _limit;
  String _offset;
  List<Brands> _brands;

  BrandModel(
      {int total, String limit, String offset, List<Brands> brands}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (brands != null) {
      this._brands = brands;
    }
  }

  int get total => _total;
  String get limit => _limit;
  String get offset => _offset;
  List<Brands> get brands => _brands;


  BrandModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['brands'] != null) {
      _brands = <Brands>[];
      json['brands'].forEach((v) {
        _brands.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._brands != null) {
      data['brands'] = this._brands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int _id;
  String _name;
  String _image;
  String _createdAt;
  String _updatedAt;

  Brands(
      {int id,
        String name,
        String image,
        String createdAt,
        String updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (image != null) {
      this._image = image;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int get id => _id;
  String get name => _name;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;


  Brands.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
