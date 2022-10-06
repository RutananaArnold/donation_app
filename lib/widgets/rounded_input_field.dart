import 'package:flutter/material.dart';

import '../constants/color_pallete.dart';
import 'text_field_container.dart';


class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final VoidCallback? tap;
  final bool x;
  final Widget? postfixIcon;
  final void Function(String)? onChanged;
  const RoundedInputField(
      {Key? key,
      required this.hintText,
      this.icon,
      this.controller,
      this.x = false,
      this.tap,
      this.postfixIcon,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: ((value) =>
            value!.isNotEmpty ? null : "This field is required"),
        controller: controller,
        textInputAction: TextInputAction.next,
        cursorColor: kPrimaryColor,
        onTap: tap,
        readOnly: x,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
            border: InputBorder.none,
            suffixIcon: postfixIcon),
        onChanged: onChanged,
      ),
    );
  }
}
