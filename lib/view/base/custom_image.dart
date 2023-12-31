import 'package:flutter/material.dart';
import 'package:cimapos/util/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholder;
  final Color color;
  CustomImage({
    @required this.image,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: placeholder != null ? placeholder : Images.placeholder,
      height: height, width: width, fit: fit,
      image: image,
      imageErrorBuilder: (c, o, s) => Image.asset(
        placeholder != null ? placeholder : Images.placeholder,
        height: height, width: width, fit: fit,

      ),
    );
  }
}

