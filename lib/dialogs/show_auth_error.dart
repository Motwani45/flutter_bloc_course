import 'package:flutter/material.dart';
import 'package:flutter_bloc_course/auth/auth_error.dart';
import 'package:flutter_bloc_course/dialogs/generic_dialog.dart';

Future<void> showAuthErrorDialog(
    BuildContext context,
    AuthError error
    ){
  return showGenericDialog<void>(context: context, title: error.dialogTitle, content: error.dialogText, optionsBuilder: (){
    return {
     'OK':true
    };
  });
}