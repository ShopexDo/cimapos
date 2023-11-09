import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/auth_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/screens/splash/splash_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text('want_to_sign_out'.tr, style: fontSizeRegular, textAlign: TextAlign.center),
        ),

        Divider(height: 0),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () {
              Get.find<AuthController>().clearSharedData().then((condition) {
                Navigator.pop(context);
                Get.offAll(SplashScreen());
                //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              });
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text('yes'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text('no'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor)),
            ),
          )),

        ]),
      ]),
    );
  }
}
