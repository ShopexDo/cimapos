import 'package:fluttertoast/fluttertoast.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = true, bool isToaster = false}) {
  if(message != null && message.isNotEmpty) {
    if(isToaster){
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        message: message,
        maxWidth: Dimensions.WEB_MAX_WIDTH,
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        borderRadius: Dimensions.RADIUS_SMALL,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }

  }
}