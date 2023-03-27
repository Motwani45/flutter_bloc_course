import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_event.dart';
import 'package:flutter_bloc_course/dialogs/delete_account_dialog.dart';
import 'package:flutter_bloc_course/dialogs/logout_dialog.dart';
enum MenuAction{
  logOut,
  deleteAccount
}
class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
    onSelected:(value)async{
      switch(value) {

        case MenuAction.logOut:
          final shouldLogOut=await showLogoutDialog(context);
          if(shouldLogOut){
            context.read<AppBloc>().add(AppEventLogOut());
          }

          break;
        case MenuAction.deleteAccount:
          final shouldDeleteAccount=await showDeleteAccountDialog(context);
          if(shouldDeleteAccount){
            context.read<AppBloc>().add(AppEventDeleteAccount());
          }
          break;
      }
    }
    ,itemBuilder: (context){
      return[
        const PopupMenuItem<MenuAction>(value: MenuAction.logOut,child:Text("Log out"),),
        const PopupMenuItem<MenuAction>(value: MenuAction.deleteAccount,child:Text("Delete Account"),),

      ];
    });
  }
}
