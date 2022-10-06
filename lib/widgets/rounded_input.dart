import 'package:flutter/material.dart';

import 'rounded_input_field.dart';


class RoundedInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final VoidCallback? ontap;
  final TextEditingController? handler;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool readOnly;
  const RoundedInput(
      {Key? key,
      required this.label,
      required this.hint,
      required this.icon,
      this.ontap,
      this.handler,
      this.onChanged,
      this.suffixIcon,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            RoundedInputField(
              hintText: hint,
              x: readOnly,
              icon: icon,
              tap: ontap,
              controller: handler,
              postfixIcon: suffixIcon,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
