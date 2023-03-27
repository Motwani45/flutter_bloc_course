import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_event.dart';
import 'package:flutter_bloc_course/extensions/if_debugging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: "jai@jai.com".ifDebugging);
    final passwordController =
        useTextEditingController(text: "123456".ifDebugging);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(hintText: "Enter your email here..."),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: "Enter your password here..."),
              obscureText: true,
            ),
            TextButton(onPressed: () {
              final email=emailController.text;
              final password=passwordController.text;
              context.read<AppBloc>().add(AppEventLogIn(email: email, password: password));

            }, child: const Text("Log In")),
            TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(AppEventGotToRegistration());
                },
                child: const Text("Dont have account? Register")),
          ],
        ),
      ),
    );
  }
}
