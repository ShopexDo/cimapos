import 'package:flutter/material.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CustomSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final Function iconPressed;
  final Function onSubmit;
  final Function onChanged;
  final Function filterAction;
  final bool isFilter;
  CustomSearchField({
    @required this.controller,
    @required this.hint,
    @required this.prefix,
    @required this.iconPressed,
    this.onSubmit,
    this.onChanged,
    this.filterAction,
    this.isFilter = false,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).disabledColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            filled: true, fillColor: Theme.of(context).cardColor,
            isDense: true,
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: .70),
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: IconButton(
              onPressed: widget.iconPressed,
              icon: Icon(widget.prefix, color: Theme.of(context).hintColor),
            ),
          ),
          onSubmitted: widget.onSubmit,
          onChanged: widget.onChanged,
        ),
      ),

      
     widget.isFilter ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            widget.filterAction(details.globalPosition);
          },
          child: Image.asset(Images.filter_icon, width: Dimensions.PADDING_SIZE_LARGE),
        ),
      ) : SizedBox(),
    ],);
  }
}
