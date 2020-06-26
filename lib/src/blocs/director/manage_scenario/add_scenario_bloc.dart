import 'dart:io';

import 'package:film_management/src/models/my_file.dart';
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

  Future<bool> addScenario(Scenario scenario, MyFile script) async {
    // upload file
    print('start upload');
    var filename = script.filename + "-" + DateTime.now().toString() + "." + script.fileExtension;

    StorageReference storageReference = 
      FirebaseStorage
      .instance.ref().child('script/' + filename);

    StorageUploadTask uploadTask = storageReference.putFile(script.file);

    await uploadTask.onComplete;

    print('Uploaded');

    storageReference.getDownloadURL().then((value) => print(value));

    return true;
  }
}