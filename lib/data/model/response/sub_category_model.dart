class SubCategoryModel {
  int _total;
  int _limit;
  int _offset;
  List<SubCategories> _subCategories;

  SubCategoryModel(
      {int total,
        int limit,
        int offset,
        List<SubCategories> subCategories}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (subCategories != null) {
      this._subCategories = subCategories;
    }
  }

  int get total => _total;
  int get limit => _limit;
  int get offset => _offset;
  List<SubCategories> get subCategories => _subCategories;


  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = int.parse(json['limit']);
    _offset = int.parse(json['offset']);
    if (json['subCategories'] != null) {
      _subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        _subCategories.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._subCategories != null) {
      data['subCategories'] =
          this._subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int _id;
  String _name;
  int _parentId;
  int _position;
  int _status;
  String _image;
  String _createdAt;
  String _updatedAt;


  SubCategories(
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
  int get status => _status;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  SubCategories.fromJson(Map<String, dynamic> json) {
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
