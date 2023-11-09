class CategoryModel {
  int _total;
  String _limit;
  String _offset;
  List<Categories> _categories;

  CategoryModel(
      {int total,
        String limit,
        String offset,
        List<Categories> categories}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (categories != null) {
      this._categories = categories;
    }
  }

  int get total => _total;
  String get limit => _limit;
  String get offset => _offset;
  List<Categories> get categories => _categories;


  CategoryModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['categories'] != null) {
      _categories = <Categories>[];
      json['categories'].forEach((v) {
        _categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._categories != null) {
      data['categories'] = this._categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int _id;
  String _name;
  int _parentId;
  int _position;
  int _status;
  String _image;
  String _createdAt;
  String _updatedAt;

  Categories(
      {int id,
        String name,
        int parentId,
        int position,
        int status,
        String image,
        String createdAt,
        String updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (parentId != null) {
      this._parentId = parentId;
    }
    if (position != null) {
      this._position = position;
    }
    if (status != null) {
      this._status = status;
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
  int get parentId => _parentId;
  int get position => _position;
  //ignore: unnecessary_getters_setters
  int get status => _status;
  set status(int value) {
    _status = value;
  }
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;


  Categories.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    if(json['parent_id'] != null){
      _parentId = int.parse(json['parent_id'].toString());
    }

    if(json['position'] != null){
      _position = int.parse(json['position'].toString());
    }

    if(json['status'] != null){
      _status = int.parse(json['status'].toString());
    }

    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['status'] = this._status;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
