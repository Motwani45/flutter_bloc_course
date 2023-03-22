import 'package:flutter/foundation.dart' show immutable;

import '../models.dart';

@immutable
abstract class NotesApiProtocol{
const NotesApiProtocol();
Future<Iterable<Note>?> getNotes({
  required LoginHandle handle,
});
}

@immutable
class NotesApi implements NotesApiProtocol{
  // const NotesApi._sharedInstance();
  // static const _shared=NotesApi._sharedInstance();
  // factory NotesApi.instance(){
  //   return _shared;
  // }
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle handle}) =>Future.delayed(Duration(seconds: 2),()=>
  handle==const LoginHandle.foobar()?mockNotes:null,);

}