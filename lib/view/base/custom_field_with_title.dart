import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomFieldWithTitle extends StatelessWidget {
  final Widget customTextField;
  final String title;
  final bool requiredField;
  final bool isPadding;
  final bool isSKU;
  final bool limitSet;
  final String setLimitTitle;
  final Function onTap;
  const CustomFieldWithTitle({
    Key key,
    @required this.customTextField,
    this.title,
    this.setLimitTitle,
    this.requiredField = false,
    this.isPadding = true,
    this.isSKU = false,
    this.limitSet = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: title, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                children: <TextSpan>[
                 requiredField ? TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)) : TextSpan(),
                ],
              ),
            ),
            isSKU?
            InkWell(onTap: onTap,
                child: Text(limitSet? setLimitTitle : 'auto_generate'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor))):SizedBox(),
          ],
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        
        customTextField,
      ],),
    );
  }
}
