import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_course/auth/auth_error.dart';
import 'package:flutter_bloc_course/bloc/app_State.dart';
import 'package:flutter_bloc_course/bloc/app_event.dart';
import 'package:flutter_bloc_course/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(isLoading: false, authError: null)) {
    // handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      // log user out if we don't have valid user
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false, authError: null));
        return;
      }
      //start the loading process
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
          authError: null,
        ),
      );
      final file = File(event.filePathToUpload);
      await uploadImageToFirebase(file: file, userId: user.uid);

      //after upload is complete, grab the latest file references
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(
          user: user, images: images, isLoading: false, authError: null));
    });
    on<AppEventDeleteAccount>((event,emit) async{
      final user=FirebaseAuth.instance.currentUser;
      if(user==null){
        emit(const AppStateLoggedOut(isLoading: false, authError: null));
        return;
      }
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
          authError: null,
        ),
      );
      try{
      final folder=FirebaseStorage.instance.ref(user.uid);
       if(state.images!.isNotEmpty){
         await folder.delete();
       }
      await user.delete();
      await FirebaseAuth.instance.signOut();
      emit(AppStateLoggedOut(isLoading: false, authError: null));
      } on FirebaseAuthException catch(e){
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
            authError: AuthError.from(e),
          ),
        );
      }
      on FirebaseException catch(e){
        emit(AppStateLoggedOut(isLoading: false, authError: null));
      }
    });
    on<AppEventLogOut>((event,emit) async{
      emit(AppStateLoggedOut(isLoading: true, authError: null));
      await FirebaseAuth.instance.signOut();
      emit(AppStateLoggedOut(isLoading: false,authError: null));
    });
    on<AppEventInitialize>((event,emit) async{
      final user=FirebaseAuth.instance.currentUser;
      if(user!=null){
        final images=await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: images, isLoading: false, authError: null));
      }
      else{
        emit(AppStateLoggedOut(isLoading: false, authError: null));
      }
    });
    on<AppEventGotToRegistration>((event,emit){
      emit(AppStateIsInRegistrationView(isLoading: false, authError: null));
    });
    on<AppEventGotToLogin>((event,emit){
      emit(AppStateLoggedOut(isLoading: false, authError: null));
    });
    on<AppEventRegister>((event,emit)async{
      emit(AppStateIsInRegistrationView(isLoading: true, authError: null));
      final email=event.email;
      final password=event.password;
      try{
final credentials= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    emit(AppStateLoggedIn(user: credentials.user!, images: [], isLoading: false, authError: null));
      } on FirebaseAuthException catch(e){
        emit(AppStateIsInRegistrationView(isLoading: false, authError: AuthError.from(e)));
      }
    });
    on<AppEventLogIn>((event,emit) async{
      emit(AppStateLoggedOut(isLoading: true, authError: null));
      final email=event.email;
      final password=event.password;
      try{
        final credentials= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        final images=await _getImages(credentials.user!.uid);
        emit(AppStateLoggedIn(user: credentials.user!, images: images, isLoading: false, authError: null));
      } on FirebaseAuthException catch(e){
        emit(AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)));
      }
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) {
    return FirebaseStorage.instance
        .ref(userId)
        .list()
        .then((listResult) => listResult.items);
  }
}
