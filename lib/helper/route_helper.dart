import 'package:six_pos/view/screens/dashboard/nav_bar_screen.dart';
import 'package:six_pos/view/screens/shop/shop_settings.dart';
import 'package:six_pos/view/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String shopSettings = '/shop-settings';

  static getInitialRoute() => '$initial';
  static getSplashRoute() => '$splash';
  static getHomeRoute(String name) => '$home?name=$name';
  static getShopSettings() => '$shopSettings';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => SplashScreen()),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: home, page: () => NavBarScreen()),
    GetPage(name: shopSettings, page: () => ShopSettings()),
  ];
}