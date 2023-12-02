import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/order_controller.dart';
import 'package:cimapos/controller/quote_controller.dart';
import 'package:cimapos/controller/transaction_controller.dart';
import 'package:cimapos/data/api/api_checker.dart';
import 'package:cimapos/data/model/body/place_order_body.dart';
import 'package:cimapos/data/model/body/place_bill_body.dart';
import 'package:cimapos/data/model/body/place_quote_body.dart';
import 'package:cimapos/data/model/response/cart_model.dart';
import 'package:cimapos/data/model/response/categoriesProductModel.dart';
import 'package:cimapos/data/model/response/coupon_model.dart';
import 'package:cimapos/data/model/response/customer_model.dart';
import 'package:cimapos/data/model/response/temporary_cart_for_customer.dart';
import 'package:cimapos/data/repository/cart_repo.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cimapos/view/screens/order/invoice_screen.dart';
import 'package:cimapos/view/screens/order/bill_screen.dart';


class CartController extends GetxController implements GetxService{
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});


  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;
  double _amount = 0.0;
  double get amount => _amount;
  double _productDiscount = 0.0;
  double get productDiscount => _productDiscount;

  double _productTax = 0.0;
  double get productTax => _productTax;

  List<TemporaryCartListModel> _customerCartList = [];
  List<TemporaryCartListModel> get customerCartList => _customerCartList;


  TextEditingController _collectedCashController = TextEditingController();
  TextEditingController get collectedCashController => _collectedCashController;

  TextEditingController _customerWalletController = TextEditingController();
  TextEditingController get customerWalletController => _customerWalletController;




  TextEditingController _couponController = TextEditingController();
  TextEditingController get couponController => _couponController;

  TextEditingController _extraDiscountController = TextEditingController();
  TextEditingController get extraDiscountController => _extraDiscountController;

  double _returnToCustomerAmount = 0 ;
  double get returnToCustomerAmount => _returnToCustomerAmount;

  double _couponCodeAmount = 0;
  double get couponCodeAmount =>_couponCodeAmount;

  double _extraDiscountAmount = 0;
  double get extraDiscountAmount =>_extraDiscountAmount;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;


  String _selectedDiscountType = '';
  String get selectedDiscountType =>_selectedDiscountType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _singleClick = false;
  bool get singleClick => _singleClick;

  List <CategoriesProduct> _scanProduct =[];
  List <CategoriesProduct> get scanProduct=>_scanProduct;

  List<bool> _isSelectedList = [];
  List<bool> get isSelectedList => _isSelectedList;

  int _customerIndex = 0;
  int get customerIndex => _customerIndex;

  List<int> _customerIds = [];
  List<int> get customerIds => _customerIds;

  List<CartModel> _existInCartList;
  List<CartModel> get existInCartList =>_existInCartList;

  Coupons _coupons;
  Coupons get coupons =>_coupons;

  List<Customers> _searchedCustomerList;
  List<Customers> get searchedCustomerList =>_searchedCustomerList;

  bool _isGetting = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;

  int _customerListLength = 0;
  int get customerListLength => _customerListLength;



  String _customerSelectedName = '';
  String get customerSelectedName => _customerSelectedName;

  String _customerSelectedMobile = '';
  String get customerSelectedMobile => _customerSelectedMobile;

  int _customerId = 0;
  int get customerId => _customerId;

  TextEditingController _searchCustomerController = TextEditingController();
  TextEditingController get searchCustomerController => _searchCustomerController;
  double _customerBalance = 0.0;
  double get customerBalance=> _customerBalance;
  int cartIndex = 0;

  void setAmount(double newAmount) {
    _amount = newAmount;
    update();
  }

  void setExtraDiscount() {
    _extraDiscountAmount = 0.0;
    update();
  }

  void setSelectedDiscountType(String type){
    _selectedDiscountType = type;
    update();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }



  void getReturnAmount( double totalCostAmount){
    setReturnAmountToZero();

    if(_customerId != 0  && Get.find<TransactionController>().selectedFromAccountId == 0){
      _customerWalletController.text = _customerBalance.toString();
      _returnToCustomerAmount = double.parse(_customerWalletController.text) - totalCostAmount;
    }
    else if(_collectedCashController.text.isNotEmpty){
     _returnToCustomerAmount = double.parse(_collectedCashController.text) - totalCostAmount;
    }


    update();
  }

  void applyCouponCodeAndExtraDiscount(){
    String extraDiscount = _extraDiscountController.text.trim()?? '0';
    _extraDiscountAmount = double.parse(extraDiscount);
    if(_extraDiscountAmount > _amount){
      showCustomSnackBar('discount_cant_greater_than_order_amount'.tr, isToaster: true, isError: false);

    }else{
      _customerCartList[_customerIndex].extraDiscount = _extraDiscountAmount;
    }

    update();

  }

  void applyExtraDiscount(){
    String extraDiscount = _extraDiscountController.text.trim()?? '0';
    _extraDiscountAmount = double.parse(extraDiscount);
    if(_extraDiscountAmount > _amount){
      showCustomSnackBar('discount_cant_greater_than_order_amount'.tr, isToaster: true, isError: false);

    }

    update();
  }

  void setReturnAmountToZero()
  {
    _returnToCustomerAmount = 0;
    update();
  }



  void addToCart(CartModel cartModel) {
    _amount = 0;
    if(_customerCartList.isEmpty){
      TemporaryCartListModel customerCart = TemporaryCartListModel(
          cart: [],
          userIndex: 0,
          userId: 0,
          customerName: 'wc-0');
     addToCartListForUser(customerCart, clear: false);
     print(customerCart);
    }
    if (_customerCartList[_customerIndex].cart.any((e) => e.product.id == cartModel.product.id)) {
      isExistInCart(cartModel);
    }else{
      _customerCartList[_customerIndex].cart.add(cartModel);

      for(int i = 0; i< _customerCartList[_customerIndex].cart.length; i++){
        _amount = _amount + (_customerCartList[_customerIndex].cart[i].price *
            _customerCartList[_customerIndex].cart[i].quantity);
      }

      showCustomSnackBar('added_cart_successfully'.tr, isToaster: true, isError: false);

    }

    update();
  }


  void addToCartListForUser(TemporaryCartListModel cartList,{bool clear = false}) {
    if(_customerCartList.isEmpty){
      _customerIds = [];
    }

    if (_customerCartList.any((e) => e.userId == cartList.userId && cartList.userId != 0)) {
     _customerCartList.removeAt(_customerIds.indexOf(cartList.userIndex));
      print('already user exist');
    }else{
      _customerIds.add(_customerIds.length);
      _customerCartList.add(cartList);
      if(clear){

        update();
      }
    }



  }


  void setQuantity(bool isIncrement, int index) {
    _amount = 0;
    if (isIncrement) {
      if(_customerCartList[_customerIndex].cart[index].product.quantity > _customerCartList[_customerIndex].cart[index].quantity)
     {
       _customerCartList[_customerIndex].cart[index].quantity = _customerCartList[_customerIndex].cart[index].quantity + 1;

       for(int i =0 ; i< _customerCartList[_customerIndex].cart.length; i++){
         _amount = _amount + (_customerCartList[_customerIndex].cart[i].price *
             _customerCartList[_customerIndex].cart[i].quantity);
       }

     }else{
        showCustomSnackBar('stock_out'.tr);
      }
    } else {
      if(_customerCartList[_customerIndex].cart[index].quantity > 1){
        _customerCartList[_customerIndex].cart[index].quantity = _customerCartList[_customerIndex].cart[index].quantity - 1;
        for(int i =0 ; i< _customerCartList[_customerIndex].cart.length; i++){
          _amount = _amount + (_customerCartList[_customerIndex].cart[i].price *
              _customerCartList[_customerIndex].cart[i].quantity);
        }
      }else{
        showCustomSnackBar('minimum_quantity_1'.tr);
        for(int i =0 ; i< _customerCartList[_customerIndex].cart.length; i++){
          _amount = _amount + (_customerCartList[_customerIndex].cart[i].price *
              _customerCartList[_customerIndex].cart[i].quantity);
        }
      }

    }

    update();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_customerCartList[_customerIndex].cart[index].price * _customerCartList[_customerIndex].cart[index].quantity);
    _customerCartList[_customerIndex].cart.removeAt(index);

    update();
  }
  void removeAllCart() {
    _cartList = [];
    _collectedCashController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    _customerCartList = [];


    update();
  }


  void removeAllCartList() {
    _cartList =[];
    _customerWalletController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    _customerCartList =[];
    _customerIds = [];
    _customerIndex = 0;
    update();
  }



  void clearCartList() {
    _cartList = [];
    _amount = 0;
    update();
  }

  bool isExistInCart(CartModel cartModel) {
    cartIndex = 0;
    for(int index = 0; index<_customerCartList[_customerIndex].cart.length; index++) {
      if(_customerCartList[_customerIndex].cart[index].product.id == cartModel.product.id) {
        setQuantity(true, index);
        showCustomSnackBar('${'added_cart_successfully'.tr} ${ _customerCartList[_customerIndex].cart[index].quantity} ${'items'.tr}', isToaster: true, isError: false);
      }
    }
    return false;
  }

  Future<void> getCouponDiscount(String couponCode, int userId, double orderAmount) async {
    Response response = await cartRepo.getCouponDiscount(couponCode, userId, orderAmount);
    if(response.statusCode == 200) {
      _couponController.clear();
      bool percent;
      _coupons = Coupons.fromJson(response.body['coupon']);
      percent = _coupons.discountType == 'percent';
      if(percent){
        _couponCodeAmount = (double.parse(coupons.discount)/100) * orderAmount;
      }else{
        _couponCodeAmount = double.parse(coupons.discount);
      }

      _customerCartList[_customerIndex].couponAmount = _couponCodeAmount;



     showCustomSnackBar('${'you_got'.tr} $_couponCodeAmount ${'discount'.tr}',isError: false);
    }else if(response.statusCode == 202){
      Map map = response.body;
      String message = map['message'];
      showCustomSnackBar(message);
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void oneClick(){
    _singleClick = true;
    update();
  }

  void clearCardForCancel(){
    _couponCodeAmount = 0;
    _extraDiscountAmount = 0;
    update();

  }

  Future<Response> placeOrder(PlaceOrderBody placeOrderBody) async {
    _isLoading = true;
    update();

    Response response = await cartRepo.placeOrder(placeOrderBody);
    if(response.statusCode == 200){
      _isLoading = false;
      _returnToCustomerAmount = 0;
      _couponCodeAmount = 0;
      _productDiscount = 0;
      _customerBalance = 0;
      _customerWalletController.clear();
      Get.find<OrderController>().getOrderList('1',reload: true);
      showCustomSnackBar('order_placed_successfully'.tr, isError: false);
      _extraDiscountAmount = 0;
      _amount = 0;
      _collectedCashController.clear();
      _customerCartList.removeAt(_customerIndex);
      _customerIds.removeAt(_customerIndex);
      setReturnAmountToZero();


      if(_customerIds.isNotEmpty) {
        _amount = 0;
        setCustomerIndex(0, false);
        Get.find<CartController>().searchCustomerController.text = 'walking customer';
        setCustomerInfo(_customerCartList[_customerIndex].userId, _customerCartList[_customerIndex].customerName, '', _customerCartList[_customerIndex].customerBalance, true);
      }
      Get.to(()=> InVoiceScreen(orderId: response.body['order_id']));

    }else{
     ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> placeQuote(PlaceQuoteBody placeQuoteBody) async {
    _isLoading = true;
    update();

    Response response = await cartRepo.placeQuote(placeQuoteBody);
    if(response.statusCode == 200){
      _isLoading = false;
      _returnToCustomerAmount = 0;
      _couponCodeAmount = 0;
      _productDiscount = 0;
      _customerBalance = 0;
      _customerWalletController.clear();
      Get.find<QuoteController>().getQuoteList('1',reload: true);
      showCustomSnackBar('quote_placed_successfully'.tr, isError: false);
      _extraDiscountAmount = 0;
      _amount = 0;
      _collectedCashController.clear();
      _customerCartList.removeAt(_customerIndex);
      _customerIds.removeAt(_customerIndex);
      setReturnAmountToZero();


      if(_customerIds.isNotEmpty) {
        _amount = 0;
        setCustomerIndex(0, false);
        Get.find<CartController>().searchCustomerController.text = 'walking customer';
        setCustomerInfo(_customerCartList[_customerIndex].userId, _customerCartList[_customerIndex].customerName, '', _customerCartList[_customerIndex].customerBalance, true);
      }
      Get.to(()=> BillScreen(quoteId: response.body['quote_id']));

    }else{
     ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> approvedQuote(PlaceBillBody quote) async {
    _isLoading = true;
    update();

    Response response = await cartRepo.approvedQuote(quote);
    if(response.statusCode == 200){
      _isLoading = false;
      _returnToCustomerAmount = 0;
      _couponCodeAmount = 0;
      _productDiscount = 0;
      _customerBalance = 0;
      _customerWalletController.clear();
      Get.find<OrderController>().getOrderList('1',reload: true);
      showCustomSnackBar('quote_placed_successfully'.tr, isError: false);
      _extraDiscountAmount = 0;
      _amount = 0;
      _collectedCashController.clear();
      // _customerCartList.removeAt(_customerIndex);
      // _customerIds.removeAt(_customerIndex);
      setReturnAmountToZero();


      if(_customerIds.isNotEmpty) {
        _amount = 0;
        setCustomerIndex(0, false);
        Get.find<CartController>().searchCustomerController.text = 'walking customer';
        setCustomerInfo(_customerCartList[_customerIndex].userId, _customerCartList[_customerIndex].customerName, '', _customerCartList[_customerIndex].customerBalance, true);
      }
      Get.to(()=> InVoiceScreen(orderId: response.body['order_id']));

    }else{
     ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> scanProductBarCode() async{
    String scannedProductBarCode;
    try{
      scannedProductBarCode = await FlutterBarcodeScanner.scanBarcode('#003E47', 'cancel', false, ScanMode.BARCODE);
    }
    on PlatformException{}
    getProductFromScan(scannedProductBarCode);
  }



  Future<void> getProductFromScan(String productCode) async {
    _isLoading = true;
    Response response = await cartRepo.getProductFromScan(productCode);
    if(response.statusCode == 200) {
      _scanProduct =[];
      response.body.forEach((categoriesProduct) => _scanProduct.add(CategoriesProduct.fromJson(categoriesProduct)));
      CartModel cartModel = CartModel(_scanProduct[0].sellingPrice, _scanProduct[0].discount, 1, _scanProduct[0].tax, _scanProduct[0]);
      addToCart(cartModel);
      _isLoading = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> setCustomerIndex(int index, bool notify) async {
    _amount = 0;
    _customerIndex = index;
    if(_customerCartList.isNotEmpty) {
      for(int i =0; i< _customerCartList[_customerIndex].cart.length; i++){
        _amount = _amount + (_customerCartList[_customerIndex].cart[i].price * _customerCartList[_customerIndex].cart[i].quantity);
      }
    }

    if(notify) {
      update();
    }
  }
  Future<void> searchCustomer(String searchName) async {
    _searchedCustomerList = [];
    _isGetting = true;
    Response response = await cartRepo.customerSearch(searchName);
    if(response.statusCode == 200) {
      _searchedCustomerList = [];
      _searchedCustomerList.addAll(CustomerModel.fromJson(response.body).customers);
      _customerListLength = CustomerModel.fromJson(response.body).total;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  void setCustomerInfo(int id, String name,String phone,double customerBalance,  bool notify) {
      _customerId = id;
      _customerSelectedName = name;
      _customerSelectedMobile  = phone;
      _customerBalance = customerBalance;
      if(notify) {
        update();
      }
    }

}