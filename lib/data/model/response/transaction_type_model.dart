class TransactionTypeModel {
  List<Types> _types;

  TransactionTypeModel({List<Types> types}) {
    if (types != null) {
      this._types = types;
    }
  }

  List<Types> get types => _types;


  TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      _types = <Types>[];
      json['types'].forEach((v) {
        _types.add(new Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._types != null) {
      data['types'] = this._types.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Types {
  int _id;
  String _tranType;

  Types({int id, String tranType}) {
    if (id != null) {
      this._id = id;
    }
    if (tranType != null) {
      this._tranType = tranType;
    }
  }

  int get id => _id;
  String get tranType => _tranType;

  Types.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _tranType = json['tran_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['tran_type'] = this._tranType;
    return data;
  }
}
