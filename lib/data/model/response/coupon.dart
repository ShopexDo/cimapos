class CouponItem {
  List<Coupon> _coupon;

  CouponItem({List<Coupon> coupon}) {
    if (coupon != null) {
      this._coupon = coupon;
    }
  }

  List<Coupon> get coupon => _coupon;

  CouponItem.fromJson(Map<String, dynamic> json) {
    if (json['coupon'] != null) {
      _coupon = <Coupon>[];
      json['coupon'].forEach((v) {
        _coupon.add(new Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._coupon != null) {
      data['coupon'] = this._coupon.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupon {
  int _userLimit;
  String _startDate;
  String _expireDate;
  String _minPurchase;
  String _maxDiscount;

  Coupon(
      {int userLimit,
        String startDate,
        String expireDate,
        String minPurchase,
        String maxDiscount}) {
    if (userLimit != null) {
      this._userLimit = userLimit;
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
  }

  int get userLimit => _userLimit;
  String get startDate => _startDate;
  String get expireDate => _expireDate;
  String get minPurchase => _minPurchase;
  String get maxDiscount => _maxDiscount;

  Coupon.fromJson(Map<String, dynamic> json) {
    _userLimit = json['user_limit'];
    _startDate = json['start_date'];
    _expireDate = json['expire_date'];
    _minPurchase = json['min_purchase'];
    _maxDiscount = json['max_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_limit'] = this._userLimit;
    data['start_date'] = this._startDate;
    data['expire_date'] = this._expireDate;
    data['min_purchase'] = this._minPurchase;
    data['max_discount'] = this._maxDiscount;
    return data;
  }
}
