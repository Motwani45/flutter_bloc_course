import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<bool> uploadImageToFirebase({required File file, required String userId}){
  return FirebaseStorage.instance.ref(userId).child(Uuid().v4()).putFile(file).then((p0) =>true).catchError((_)=> false);
  }
