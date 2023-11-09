import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomDatePicker extends StatefulWidget {
  final String title;
  final String text;
  final String image;
  final bool requiredField;
  final Function selectDate;
  CustomDatePicker({this.title,this.text,this.image, this.requiredField = false,this.selectDate});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT,right: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

        RichText(
          text: TextSpan(
            text: widget.title, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
            children: <TextSpan>[
              widget.requiredField ? TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)) : TextSpan(),
            ],
          ),
        ),

        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Container(
          height: 50,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            border: Border.all(color: ColorResources.primaryColor,width: 0.1),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            Text(widget.text, style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),),
            InkWell(
                child: SizedBox(width: 20,height: 20,child: Image.asset(widget.image)),
                onTap: widget.selectDate,
            ),
          ],
          ),
        ),

      ],),
    );
  }
}
