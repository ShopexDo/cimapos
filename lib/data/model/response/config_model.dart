class ConfigModel {
  BusinessInfo _businessInfo;
  BaseUrls _baseUrls;
  String _currencySymbol;

  ConfigModel({BusinessInfo businessInfo, BaseUrls baseUrls, String currencySymbol}) {
    if (businessInfo != null) {
      this._businessInfo = businessInfo;
    }
    if (baseUrls != null) {
      this._baseUrls = baseUrls;
    }
    if (currencySymbol != null) {
      this._currencySymbol = currencySymbol;
    }
  }

  BusinessInfo get businessInfo => _businessInfo;
  BaseUrls get baseUrls => _baseUrls;
  String get currencySymbol => _currencySymbol;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _businessInfo = json['business_info'] != null
        ? new BusinessInfo.fromJson(json['business_info'])
        : null;
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._businessInfo != null) {
      data['business_info'] = this._businessInfo.toJson();
    }
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    return data;
  }
}

class BusinessInfo {
  String _shopLogo;
  String _paginationLimit;
  String _currency;
  String _shopName;
  String _shopAddress;
  String _shopPhone;
  String _shopEmail;
  String _footerText;
  String _country;
  String _stockLimit;
  String _timeZone;
  String _vat;


  BusinessInfo(
      {String shopLogo,
        String paginationLimit,
        String currency,
        String shopName,
        String shopAddress,
        String shopPhone,
        String shopEmail,
        String footerText,
        String country,
        String stockLimit,
        String timeZone,
        String vat,

      }) {
    if (shopLogo != null) {
      this._shopLogo = shopLogo;
    }
    if (paginationLimit != null) {
      this._paginationLimit = paginationLimit;
    }
    if (currency != null) {
      this._currency = currency;
    }
    if (shopName != null) {
      this._shopName = shopName;
    }
    if (shopAddress != null) {
      this._shopAddress = shopAddress;
    }
    if (shopPhone != null) {
      this._shopPhone = shopPhone;
    }
    if (shopEmail != null) {
      this._shopEmail = shopEmail;
    }
    if (footerText != null) {
      this._footerText = footerText;
    }
    if (country != null) {
      this._country = country;
    }
    if (stockLimit != null) {
      this._stockLimit = stockLimit;
    }
    if (timeZone != null) {
      this._timeZone = timeZone;
    }
    if (vat != null) {
      this._vat = vat;
    }

  }

  String get shopLogo => _shopLogo;
  String get paginationLimit => _paginationLimit;
  String get currency => _currency;
  String get shopName => _shopName;
  String get shopAddress => _shopAddress;
  String get shopPhone => _shopPhone;
  String get shopEmail => _shopEmail;
  String get footerText => _footerText;
  String get country => _country;
  String get stockLimit => _stockLimit;
  String get timeZone => _timeZone;
  String get vat => _vat;


  BusinessInfo.fromJson(Map<String, dynamic> json) {
    _shopLogo = json['shop_logo'];
    _paginationLimit = json['pagination_limit'];
    _currency = json['currency'];
    _shopName = json['shop_name'];
    _shopAddress = json['shop_address'];
    _shopPhone = json['shop_phone'];
    _shopEmail = json['shop_email'];
    _footerText = json['footer_text'];
    _country = json['country'];
    _stockLimit = json['stock_limit'];
    _timeZone = json['time_zone'];
    _vat = json['vat_reg_no'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_logo'] = this._shopLogo;
    data['pagination_limit'] = this._paginationLimit;
    data['currency'] = this._currency;
    data['shop_name'] = this._shopName;
    data['shop_address'] = this._shopAddress;
    data['shop_phone'] = this._shopPhone;
    data['shop_email'] = this._shopEmail;
    data['footer_text'] = this._footerText;
    data['country'] = this._country;
    data['stock_limit'] = this._stockLimit;
    data['time_zone'] = this._timeZone;
    data['vat_reg_no'] = this._vat;

    return data;
  }
}

class BaseUrls {
  String _categoryImageUrl;
  String _brandImageUrl;
  String _productImageUrl;
  String _supplierImageUrl;
  String _shopImageUrl;

  BaseUrls(
      {String categoryImageUrl,
        String brandImageUrl,
        String productImageUrl,
        String supplierImageUrl,
        String shopImageUrl}) {
    if (categoryImageUrl != null) {
      this._categoryImageUrl = categoryImageUrl;
    }
    if (brandImageUrl != null) {
      this._brandImageUrl = brandImageUrl;
    }
    if (productImageUrl != null) {
      this._productImageUrl = productImageUrl;
    }
    if (supplierImageUrl != null) {
      this._supplierImageUrl = supplierImageUrl;
    }
    if (shopImageUrl != null) {
      this._shopImageUrl = shopImageUrl;
    }
  }

  String get categoryImageUrl => _categoryImageUrl;
  String get brandImageUrl => _brandImageUrl;
  String get productImageUrl => _productImageUrl;
  String get supplierImageUrl => _supplierImageUrl;
  String get shopImageUrl => _shopImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _categoryImageUrl = json['category_image_url'];
    _brandImageUrl = json['brand_image_url'];
    _productImageUrl = json['product_image_url'];
    _supplierImageUrl = json['supplier_image_url'];
    _shopImageUrl = json['shop_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_image_url'] = this._categoryImageUrl;
    data['brand_image_url'] = this._brandImageUrl;
    data['product_image_url'] = this._productImageUrl;
    data['supplier_image_url'] = this._supplierImageUrl;
    data['shop_image_url'] = this._shopImageUrl;
    return data;
  }
}
