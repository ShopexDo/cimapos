import 'package:get/get.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/screens/auth/log_in_screen.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<SplashController>().removeSharedData();
      Get.to(()=> LogInScreen());
      // TODO: Auth Login
    }else {
      showCustomSnackBar(response.statusText);
    }
  }
}