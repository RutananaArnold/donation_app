import 'package:flutter/material.dart';
import 'package:musayi/constants/color_pallete.dart';
import 'package:musayi/screens/adminscreens/admin_home.dart';
import 'package:musayi/widgets/rounded_button.dart';
import 'package:musayi/widgets/rounded_input_field.dart';
import 'package:musayi/widgets/rounded_password_field.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formkey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              const Text(
                "Admin Log in",
                textHeightBehavior: TextHeightBehavior(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              // SvgPicture.asset(
              //   "images/login.svg",
              //   height: size.height * 0.35,
              // ),
              Icon(
                Icons.verified_user_rounded,
                size: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                icon: Icons.mail_outline_rounded,
                controller: emailController,
                hintText: "Your Email",
              ),
              RoundedPasswordField(
                controller: passwordController,
                hintText: 'Your password',
                onChanged: (String value) {},
                label: 'Password',
              ),
              // forgotYourPasswordUI(),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: ((context) => const AdminHome())),
                        (route) => true);
                  }
                },
                color: kPrimaryColor,
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      )),
    );
  }

  // Widget forgotYourPasswordUI() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         InkWell(
  //           borderRadius: const BorderRadius.all(Radius.circular(8)),
  //           onTap: () {
  //             Navigator.of(context).pushAndRemoveUntil(
  //                 MaterialPageRoute(
  //                     builder: (context) => const ForgotPasswordScreen()),
  //                 (route) => true);
  //           },
  //           child: const Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Text(
  //               "Forgot yourPassword?",
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
