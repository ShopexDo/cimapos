import 'package:get/get.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:cimapos/view/screens/auth/log_in_screen.dart';

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