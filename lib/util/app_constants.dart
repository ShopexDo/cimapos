import 'package:cimapos/data/model/response/language_model.dart';
import 'package:cimapos/util/images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AppConstants {
  static const String APP_NAME = 'CimaPos';
  static const bool demo = false;
  static const String BASE_URL_lOGIN = 'https://pos.cimapos.com.do';
  // static const String BASE_URL = 'https://pos.cimapos.com.do';
  static const String CONFIG_URI = '/api/v1/config';
  static const String LOGIN_URI = '/api/v1/login/user';
  static const String PROFILE_URI = '/api/v1/delivery-man/profile?token=';
  static const String TOKEN_URI = '/api/v1/delivery-man/update-fcm-token';
  static const String ORDER_LIST = '/api/v1/pos/order/list';
  static const String INVOICE = '/api/v1/pos/invoice';
  static const String ADD_CATEGORY = '/api/v1/category/store';
  static const String GET_CATEGORY_LIST = '/api/v1/category/list';
  static const String ADD_SUB_CATEGORY = '/api/v1/sub/category/store';
  static const String UPDATE_SUB_CATEGORY = '/api/v1/sub/category/update';
  static const String GET_SUB_CATEGORY_LIST = '/api/v1/sub/category/list';
  static const String GET_UNIT_LIST = '/api/v1/unit/list';
  static const String ADD_UNIT = '/api/v1/unit/store';
  static const String DELETE_UNIT_URI = '/api/v1/unit/delete';
  static const String UPDATE_UNIT_URI = '/api/v1/unit/update';
  static const String ADD_BRAND = '/api/v1/brand/store';
  static const String GET_BRAND_LIST = '/api/v1/brand/list';
  static const String DELETE_BRAND_URI = '/api/v1/brand/delete';
  static const String UPDATE_BRAND_URI = '/api/v1/brand/update';
  static const String ADD_SUPPLIER = '/api/v1/supplier/store';
  static const String GET_SUPPLIER_LIST = '/api/v1/supplier/list';
  static const String SEARCH_SUPPLIER_URI = '/api/v1/supplier/search';
  static const String DELETE_SUPPLIER_URI = '/api/v1/supplier/delete';
  static const String UPDATE_SUPPLIER_URI = '/api/v1/supplier/update';
  static const String GET_account_LIST = '/api/v1/account/list';
  static const String SEARCH_ACCOUNT_URI = '/api/v1/account/search';
  static const String ADD_NEW_ACCOUNT = '/api/v1/account/save';
  static const String UPDATE_ACCOUNT_URI = '/api/v1/account/update';
  static const String DElETE_ACCOUNT_URI = '/api/v1/account/delete';
  static const String ADD_NEW_EXPENSE = '/api/v1/transaction/expense';
  static const String UPDATE_EXPENSE_URI = '/api/v1/transaction/update';
  static const String DELETE_EXPENSE_URI = '/api/v1/transaction/delete';
  static const String GET_EXPENSE_LIST = '/api/v1/transaction/exp/list';
  static const String EXPENSE_FILTER_BY_DATE = '/api/v1/transaction/expense/search';
  static const String GET_CUSTOMER_LIST = '/api/v1/customer/list';
  static const String CUSTOMER_SEARCH_URI = '/api/v1/customer/search';
  static const String ADD_NEW_CUSTOMER = '/api/v1/customer/store';
  static const String UPDATE_CUSTOMER_URI = '/api/v1/customer/update';
  static const String DELETE_CUSTOMER_URI = '/api/v1/customer/delete';
  static const String ADD_NEW_COUPON = '/api/v1/coupon/store';
  static const String GET_COUPON_LIST = '/api/v1/coupon/list';
  static const String UPDATE_COUPON = '/api/v1/coupon/update';
  static const String UPDATE_COUPON_STATUS = '/api/v1/coupon/status';
  static const String DELETE_COUPON_URI = '/api/v1/coupon/delete';
  static const String ADD_PRODUCT = '/api/v1/product/store';
  static const String UPDATE_PRODUCT_URI = '/api/v1/product/update';
  static const String GET_PRODUCT_URI = '/api/v1/product/list';
  static const String GET_LIMITED_STOCK_PRODUCT_URI = '/api/v1/dashboard/product/limited-stock';
  static const String GET_PROFILE_URI = '/api/v1/profile';
  static const String UPDATE_SHOP_URI = '/api/v1/update/shop';
  static const String GET_DASHBOARD_REVENUE_SUMMERY = '/api/v1/dashboard/revenue-summary';
  static const String GET_DOWNLOAD_SAMPLE_FILE_URL = '/api/v1/product/download/excel/sample';
  static const String BULK_EXPORT_PRODUCT = '/api/v1/product/export';
  static const String BULK_IMPORT_PRODUCT = '/api/v1/product/import';
  static const String CATEGORIES_PRODUCT = '/api/v1/product/category-wise';
  static const String GET_PRODUCT_FROM_PRODUCT_CODE = '/api/v1/product/code/search';
  static const String GET_COUPON_DISCOUNT = '/api/v1/coupon/check';
  static const String PLACE_ORDER_URI = '/api/v1/pos/place/order';
  static const String Get_PRODUCT_FROM_PRODUCT_CODE = '/api/v1/product/code/search';
  static const String Get_REVENUE_CHART_DATA = '/api/v1/dashboard/monthly/revenue';
  static const String UPDATE_PRODUCT_QUANTITY = '/api/v1/dashboard/quantity/increase';
  static const String PRODUCT_DELETE_URI = '/api/v1/product/delete';
  static const String PRODUCT_SEARCH_URI = '/api/v1/product/search';
  static const String DELETE_CATEGORY_URI = '/api/v1/category/delete';
  static const String UPDATE_CATEGORY_URI = '/api/v1/category/update';
  static const String UPDATE_CATEGORY_STATUS_URI = '/api/v1/category/status';
  static const String TRANSACTION_ADD_URI = '/api/v1/transaction/fund/transfer';
  static const String TRANSACTION_LIST_URI = '/api/v1/transaction/transfer-list';
  static const String TRANSACTION_FILTER_URI = '/api/v1/transaction/filter';
  static const String TRANSACTION_TYPE_LIST_URI = '/api/v1/transaction/types';
  static const String TRANSACTION_LIST_EXPORT_URI = '/api/v1/transaction/transfer/export';
  static const String TRANSACTION_ACCOUNT_LIST_URI = '/api/v1/transaction/transfer/accounts';
  static const String CUSTOMER_WISE_ORDER_LIST_URI = '/api/v1/pos/customer/orders';
  static const String CUSTOMER_WISE_TRANSACTION_LIST_URI = '/api/v1/customer/transaction';
  static const String SUPPLIER_PROFILE_URI = '/api/v1/supplier/details';
  static const String SUPPLIER_PRODUCT_LIST_URI = '/api/v1/product/supplier/wise';
  static const String SUPPLIER_TRANSACTION_LIST_URI = '/api/v1/supplier/transactions';
  static const String SUPPLIER_TRANSACTION_FILTER_LIST_URI = '/api/v1/supplier/transactions/date/filter';
  static const String NEW_PURCHASE_FROM_SUPPLIER = '/api/v1/supplier/new/purchase';
  static const String SUPPLIER_PAYMENT = '/api/v1/supplier/payment';
  static const String ADD_NEW_INCOME = '/api/v1/income/store';
  static const String GET_INCOME_LIST = '/api/v1/income/list';
  static const String FILTER_INCOME_LIST = '/api/v1/income/filter';
  static const String TIMEZONE_API = 'https://worldtimeapi.org/api/timezone';
  static const String CUSTOMER_BALANCE_UPDATE = '/api/v1/customer/update/balance';
  static const String BAR_CODE_DOWNLOAD = '/api/v1/product/barcode/generate';
  //add
  static const String PLACE_QUOTE_URI = '/api/v1/quotes/place/quote';
  static const String QUOTE_LIST = '/api/v1/quotes/quote/list';
  static const String QUOTE = '/api/v1/quotes/quote/bill';
  static const String APPROVED_QUOTE = '/api/v1/quotes/quote/approved';
  static const String APPROVED_BILL = '/api/v1/quotes/quote/approved-bill';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String CUSTOMER_CART_LIST = 'customer_cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_EMAIL = 'USER_EMAIL';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'notify';
  static const String ZONE_TOPIC = 'zone_topic';
  static const String USER_COUNTRY_CODE = 'user_country_code';

  // static StreamController<String> _baseUrlController = StreamController<String>.broadcast();
  // static Stream<String> get baseUrlStream => _baseUrlController.stream;

  // static void updateBaseUrl(String newBaseUrl) {
  //   _baseUrlController.add(newBaseUrl);
  // }

  static StreamController<String> _baseUrlController = StreamController<String>.broadcast();
  static Stream<String> get baseUrlStream => _baseUrlController.stream;

  static Future<void> updateBaseUrl(String newBaseUrl) async {
    await _saveBaseUrl(newBaseUrl); // Guarde la URL base en SharedPreferences
    _baseUrlController.add(newBaseUrl);
  }

  static Future<String> getSavedBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('baseUrl') ?? ''; // Obtenga la URL base almacenada o una cadena vacía si no existe
  }

  static Future<void> _saveBaseUrl(String baseUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl); // Guarde la URL base en SharedPreferences
  }
  
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
    LanguageModel(imageUrl: Images.united_kingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}
