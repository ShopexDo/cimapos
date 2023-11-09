import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final Function icon;
  final Function onTap;

  final bool isDetailsPage;

  TitleRow({@required this.title,this.icon, this.onTap, this.isDetailsPage});

  @override
  Widget build(BuildContext context) {

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [

      Text(title, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      Spacer(),
      onTap != null ? InkWell(onTap: onTap,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          isDetailsPage == null ? Text('view_all'.tr,
              style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor,decoration: TextDecoration.underline,
                fontSize: Dimensions.FONT_SIZE_DEFAULT)) : SizedBox.shrink(),
        ]),
      ):
      SizedBox.shrink(),
    ]);
  }
}


