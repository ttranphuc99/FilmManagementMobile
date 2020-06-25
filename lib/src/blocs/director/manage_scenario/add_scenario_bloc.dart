import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:path/path.dart' as Path;

import 'package:rxdart/rxdart.dart';

class AddScenarioBloc {
  final PublishSubject<bool> _result = PublishSubject<bool>();

  Observable<bool> get result => _result.stream;

  void close() {
    _result.close();
  }

  Future<bool> addScenario(Scenario scenario, File script, String extens, String fname) async {
    // upload file
    var filename = fname + "-" + DateTime.now().toString() + extens;

    StorageReference storageReference = 
    FirebaseStorage
    .instance.ref().child('script/' + filename);

    StorageUploadTask uploadTask = storageReference.putFile(script);

    await uploadTask.onComplete;

    print('Uploaded');

    storageReference.getDownloadURL().then((value) => print(value));
  }
}