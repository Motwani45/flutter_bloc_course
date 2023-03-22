import 'package:flutter/material.dart';
import 'package:flutter_bloc_course/strings.dart';
class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  PasswordTextField({Key? key,required this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      autocorrect: false,
      decoration:const InputDecoration(
        hintText: enterYourPasswordHere,
      ),
    );
  }
}
