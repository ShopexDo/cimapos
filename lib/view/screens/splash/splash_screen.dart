import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/auth_controller.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/helper/gradient_color_helper.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/view/screens/auth/log_in_screen.dart';
import 'package:cimapos/view/screens/dashboard/nav_bar_screen.dart';
import 'package:cimapos/util/app_constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  // void _route() {
  //   Get.find<SplashController>().getConfigData().then((value) {
  //     Timer(Duration(seconds: 1), () async {
  //       if (Get.find<AuthController>().isLoggedIn()) {
  //         Get.to(()=> NavBarScreen());
  //       } else {
  //         Get.to(()=> LogInScreen());
  //       }
  //     });
  //   });
  // }
  void _route() {
    Timer(Duration(seconds: 1), () async {
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<SplashController>().getConfigData(null).then((value) {
          Get.to(() => NavBarScreen());
        });
      } else {
        Get.to(() => LogInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _globalKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: GradientColorHelper.gradientColor(),
        ),
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: width*.7, child: Image.asset(Images.Splash_logo, height: 175)),
            ],
          ),
        ),
      ),
    );
  }
}
