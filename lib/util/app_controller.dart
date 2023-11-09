import 'package:get/get.dart';

class AppController extends GetxController {
  var baseUrl = ''.obs;

  void setBaseUrl(String newBaseUrl) {
    baseUrl.value = newBaseUrl;
  }
}