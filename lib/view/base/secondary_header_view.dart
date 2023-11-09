import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class SecondaryHeaderView extends StatelessWidget {
  final bool isSerial;
  final bool isLimited;
  final String title;
  final bool isTransaction;
  final bool showOwnTitle;
  const SecondaryHeaderView({Key key, this.isSerial = false, this.isLimited = false, this.title, this.isTransaction = false, this.showOwnTitle = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.06),
      child: ListTile(
        title: showOwnTitle? SizedBox(): isTransaction? Text(title) : isSerial ? Text('item_info'.tr, style: fontSizeMedium.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.FONT_SIZE_LARGE,
          )) : SizedBox(),

        leading:showOwnTitle && isSerial? Text(title,style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.FONT_SIZE_LARGE,
        )) : isSerial ? Text('#', style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.FONT_SIZE_LARGE,
        ),) : Text('item_info'.tr, style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.FONT_SIZE_LARGE,
        )),

        trailing: isTransaction? SizedBox() : Padding(
          padding: isLimited? const EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_LARGE): const EdgeInsets.only(right: 0.0),
          child: Text(isLimited?'qty'.tr : 'action'.tr, style: fontSizeMedium.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.FONT_SIZE_LARGE,
          )),
        ),

      ),
    );
  }
}