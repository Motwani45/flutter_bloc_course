import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_State.dart';
import 'package:flutter_bloc_course/bloc/app_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_event.dart';
import 'package:flutter_bloc_course/dialogs/show_auth_error.dart';
import 'package:flutter_bloc_course/loading/loading_screen.dart';
import 'package:flutter_bloc_course/views/login_view.dart';
import 'package:flutter_bloc_course/views/photo_gallery_view.dart';
import 'package:flutter_bloc_course/views/register_view.dart';
class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_)=>AppBloc()..add(AppEventInitialize()),
      child: MaterialApp(
          title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc,AppState>(builder: (context,state) {
          if(state is AppStateLoggedOut){
            return const LoginView();
          }
          else if(state is AppStateLoggedIn){
            return const PhotoGalleryView();
          }
          else if(state is AppStateIsInRegistrationView){
            return const RegisterView();
          }
          else{
            return Container();
          }

        }, listener: (context,state){
            if(state.isLoading){
              LoadingScreen.instance().show(context: context, text: "Loading");
            }
            else{
              LoadingScreen.instance().hide();
            }
            final authError=state.authError;
            if(authError!=null){
              showAuthErrorDialog(context, authError);
            }

        }),
      ),
    );
  }
}