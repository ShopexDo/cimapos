import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double fontSize;
  final double radius;
  final IconData icon;
  final isClear;
  CustomButton({
    this.onPressed,
    @required this.buttonText,
    this.buttonColor,
    this.textColor,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 5,
    this.icon,
    this.isClear =  false,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ?
        Theme.of(context).disabledColor : buttonColor != null ? buttonColor : Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width : Dimensions.WEB_MAX_WIDTH, height != null ? height : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Center(child: SizedBox(width: width != null ? width : Dimensions.WEB_MAX_WIDTH, child: Padding(
      padding: margin == null ? EdgeInsets.all(0) : margin,
      child: TextButton(
        onPressed: onPressed,
        style: _flatButtonStyle,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(icon, color: Theme.of(context).cardColor),
          ) : SizedBox(),
          Text(buttonText ??'', textAlign: TextAlign.center, style: fontSizeRegular.copyWith(
            color: isClear? textColor : Theme.of(context).cardColor,
            fontSize: fontSize != null ? fontSize : Dimensions.fontSizeDefault,
          )),
        ]),
      ),
    )));
  }
}