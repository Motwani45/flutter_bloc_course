import 'package:flutter/material.dart';
import 'package:flutter_bloc_course/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(
    BuildContext context,
    ){
  return showGenericDialog<bool>(context: context, title: 'Log Out', content: 'Are you sure you want to log out?', optionsBuilder: (){
    return {
      'Cancel':false,
      "Log Out":true
    };
  }).then((value) => value??false);
}