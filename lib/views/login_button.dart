import 'package:flutter/material.dart';
import 'package:flutter_bloc_course/dialogs/generic_dialog.dart';
import 'package:flutter_bloc_course/strings.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton(
      {Key? key,
      required this.onLoginTapped,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionBuilder: () {
              return {
                ok: true,
              };
            },
          );
        }
        else{
          onLoginTapped(email,password);

        }
      },
      child: const Text(login),
    );
  }
}
