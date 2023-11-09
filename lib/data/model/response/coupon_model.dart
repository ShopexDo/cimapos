class CouponModel {
  int _total;
  String _limit;
  String _offset;
  List<Coupons> _coupons;

  CouponModel(
      {int total, String limit, String offset, List<Coupons> coupons}) {
    if (total != null) {
      this._total = total;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (offset != null) {
      this._offset = offset;
    }
    if (coupons != null) {
      this._coupons = coupons;
    }
  }

  int get total => _total;
  String get limit => _limit;
  String get offset => _offset;
  List<Coupons> get coupons => _coupons;

  CouponModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['coupons'] != null) {
      _coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        _coupons.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._coupons != null) {
      data['coupons'] = this._coupons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  int _id;
  String _title;
  String _couponType;
  int _userLimit;
  String _couponCode;
  String _startDate;
  String _expireDate;
  String _minPurchase;
  String _maxDiscount;
  String _discount;
  String _discountType;
  int _status;
  String _createdAt;
  String _updatedAt;

  Coupons(
      {int id,
        String title,
        String couponType,
        int userLimit,
        String couponCode,
        String startDate,
        String expireDate,
        String minPurchase,
        String maxDiscount,
        String discount,
        String discountType,
        int status,
        String createdAt,
        String updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (couponType != null) {
      this._couponType = couponType;
    }
    if (userLimit != null) {
      this._userLimit = userLimit;
    }
    if (couponCode != null) {
      this._couponCode = couponCode;
    }
    if (startDate != null) {
      this._startDate = startDate;
    }
    if (expireDate != null) {
      this._expireDate = expireDate;
    }
    if (minPurchase != null) {
      this._minPurchase = minPurchase;
    }
    if (maxDiscount != null) {
      this._maxDiscount = maxDiscount;
    }
    if (discount != null) {
      this._discount = discount;
    }
    if (discountType != null) {
      this._discountType = discountType;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int get id => _id;
  String get title => _title;
  String get couponType => _couponType;
  int get userLimit => _userLimit;
  String get couponCode => _couponCode;
  String get startDate => _startDate;
  String get expireDate => _expireDate;
  String get minPurchase => _minPurchase;
  String get maxDiscount => _maxDiscount;
  String get discount => _discount;
  String get discountType => _discountType;
  // ignore: unnecessary_getters_setters
  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;


  Coupons.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _couponType = json['coupon_type'];
    if(json['user_limit'] != null){
      _userLimit = int.parse(json['user_limit'].toString());
    }

    _couponCode = json['code'];
    _startDate = json['start_date'];
    _expireDate = json['expire_date'];
    _minPurchase = json['min_purchase'];
    _maxDiscount = json['max_discount'];
    _discount = json['discount'];
    _discountType = json['discount_type'];
    if(json['status'] != null){
      _status = int.parse(json['status'].toString());
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['coupon_type'] = this._couponType;
    data['user_limit'] = this._userLimit;
    data['code'] = this._couponCode;
    data['start_date'] = this._startDate;
    data['expire_date'] = this._expireDate;
    data['min_purchase'] = this._minPurchase;
    data['max_discount'] = this._maxDiscount;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
