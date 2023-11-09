
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';


class CustomLoader extends StatelessWidget {
  const CustomLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height-500,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 80,width: 80, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT)
            ),
                child: const Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
