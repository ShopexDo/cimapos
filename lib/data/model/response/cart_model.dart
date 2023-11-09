import 'package:six_pos/data/model/response/categoriesProductModel.dart';
class CartModel {
  double _price;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  CategoriesProduct _product;

  CartModel(
        double price,
        double discountAmount,
        int quantity,
        double taxAmount,
      CategoriesProduct product) {
    this._price = price;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._product = product;
  }

  double get price => _price;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  double get taxAmount => _taxAmount;
  CategoriesProduct get product => _product;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    if (json['product'] != null) {
      _product = CategoriesProduct.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['product'] = this._product.toJson();
    return data;
  }
}


