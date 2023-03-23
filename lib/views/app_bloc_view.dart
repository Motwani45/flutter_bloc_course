import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_bloc.dart';
import 'package:flutter_bloc_course/bloc/app_state.dart';
import 'package:flutter_bloc_course/bloc/bloc_events.dart';
import 'package:flutter_bloc_course/extensions/stream/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
        const Duration(seconds: 10), (_){return const LoadNextUrlEvent();},).startWith(
        const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(builder: (context, appState) {
        // on error
        if(appState.error!=null){
          return const Text("An error occurred. Try again in a moment!");
        }
        // when data is available
        else if(appState.data!=null){
          return Image.memory(appState.data!,fit:BoxFit.fitHeight);
        }
        else{
          return const Center(child: CircularProgressIndicator(),);
        }
      },),
    );
  }
}
