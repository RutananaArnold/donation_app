import 'package:flutter/material.dart';


import '../constants/color_pallete.dart';
import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final void Function(String)? onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.onChanged, required TextEditingController controller,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() {
    return RoundedPasswordFieldState();
  }
}

class RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool passHide = true;
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
                widget.label,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                onChanged: widget.onChanged,
                obscureText: passHide ? true : false,
                validator: ((value) =>
                    value!.isNotEmpty ? null : "This field is required"),
                cursorColor: kPrimaryColor,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    /**Icons.visibility */
                    color: Colors.black,
                    icon: Icon(passHide
                        ? Icons.visibility
                        : Icons.visibility_off_rounded),
                    onPressed: () {
                      setState(() {
                        passHide = !passHide;
                      });
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
