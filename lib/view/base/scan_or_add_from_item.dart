import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
class ScanOrAddFromItem extends StatelessWidget {
  const ScanOrAddFromItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
        Container(width: 80,height: 80,
            child: Image.asset(Images.scan_add_item)),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Text('scan_item_or_add_from_items'.tr),
      ],),
    );
  }
}
