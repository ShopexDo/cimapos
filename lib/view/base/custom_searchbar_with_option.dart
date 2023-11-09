import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';

class CustomSearchbarWithOption extends StatelessWidget {
  final String searchTitle;
  const CustomSearchbarWithOption({Key key, this.searchTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,right: Dimensions.PADDING_SIZE_LARGE),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Expanded(child:
        Container(
          height: Dimensions.HEIGHT_WIDTH_50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_EXTRA_LARGE),
              color: ColorResources.whiteColor,
              border: Border.all(width: 0.5,color: ColorResources.blackColor.withOpacity(.3),
              ),
          ),
          child: Container(
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Row(children: [

              Container(
                  height: Dimensions.PADDING_SIZE_LARGE,
                  width: Dimensions.PADDING_SIZE_LARGE,
                  child: Image.asset(Images.search_icon)
              ),

              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

              Expanded(child: TextField(decoration: InputDecoration.collapsed(hintText: searchTitle))),

            ],),

          ),),),

        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),

        Image.asset(Images.filter_icon,height: Dimensions.PADDING_SIZE_EXTRA_LARGE,width: Dimensions.PADDING_SIZE_EXTRA_LARGE),

      ],),
    );
  }
}
