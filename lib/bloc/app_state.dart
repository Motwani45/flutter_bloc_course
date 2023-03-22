import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc_course/models.dart';

@immutable
class AppState{
  final bool isLoading;
final LoginErrors? loginError;
final LoginHandle? loginHandle;
final Iterable<Note>? fetchedNotes;

@override
  String toString() {
    return {
      'isLoading':isLoading,
      'loginErrors':loginError,
      'loginHandle':loginHandle,
      'Notes':fetchedNotes
    }.toString();
  }
  const AppState.empty():isLoading=false,
  loginError=null,
  loginHandle=null,
  fetchedNotes=null;
  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });
}