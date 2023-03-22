import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/bloc/actions.dart';
import 'package:flutter_bloc_course/bloc/app_state.dart';
import 'package:flutter_bloc_course/models.dart';
import 'package:flutter_bloc_course/strings.dart';
import '../apis/login_api.dart';
import '../apis/notes_api.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      //start loading
      emit(const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ));

      //log the user in
      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      //start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );

      //get login handle
      final loginHandle=state.loginHandle;
      if(loginHandle!=const LoginHandle.foobar()){
        //invalid login handle, cannot fetch notes
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
        return;
      }
     // valid login handle and want to fetch notes
      final fetchedNotes=await notesApi.getNotes(handle: loginHandle!);
      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: fetchedNotes,
        ),
      );
    });
  }
}
