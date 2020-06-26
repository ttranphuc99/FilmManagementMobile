import 'dart:io';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/my_file.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as Path;

import 'package:rxdart/rxdart.dart';

class AddScenarioBloc {
  final PublishSubject<bool> _result = PublishSubject<bool>();
  final _repo = ScenarioRepo();
  final BuildContext _context;

  AddScenarioBloc(this._context);

  Observable<bool> get result => _result.stream;

  void close() {
    _result.close();
  }

  Future<bool> addScenario(Scenario scenario, MyFile script) async {
    try {
      // upload file
      print('start upload');
      var filename = script.filename +
          "-" +
          DateTime.now().toString() +
          "." +
          script.fileExtension;

      if (script != null && script.filename.isNotEmpty && script.file != null) {
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child('script/' + filename);

        StorageUploadTask uploadTask = storageReference.putFile(script.file);

        await uploadTask.onComplete;

        print('Uploaded');

        await storageReference.getDownloadURL().then((value) {
          print(value);
          scenario.script = value;
        });
      }

      var response = await _repo.addScenario(scenario);

      if (response.statusCode == 201) {
        MySnackbar.showSnackbar(_context, "Success");
      } else {
        MySnackbar.showSnackbar(_context, "Processing Data Failed from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing Data Failed");
      return false;
    }

    return true;
  }
}
