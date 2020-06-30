import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/my_file.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ScenarioDetailBloc {
  final _repo = ScenarioRepo();
  final BuildContext _context;

  final PublishSubject<Scenario> _scenarioStream = PublishSubject<Scenario>();

  ScenarioDetailBloc(this._context);

  Observable<Scenario> get scenario => _scenarioStream.stream;

  void close() {
    _scenarioStream.close();
  }

  Future<Scenario> getScenarioById(int id) async {
    var scen;

    try {
      var response = await _repo.getById(id);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        scen = Scenario.fromJSON(body);

        _scenarioStream.sink.add(scen);
      } else {
        MySnackbar.showSnackbar(_context, "Error while loading data");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error while processing data");
    }

    return scen;
  }

  Future<bool> updateScenario(
      Scenario scenario, MyFile script, bool isFileChange) async {
    if (isFileChange) {
      try {
        // upload file

        if (script != null && script.filename != null && script.file != null) {
          print('start upload');
          var filename = script.filename +
              "-" +
              DateTime.now().toString() +
              "." +
              script.fileExtension;

          StorageReference storageReference =
              FirebaseStorage.instance.ref().child('script/' + filename);

          StorageUploadTask uploadTask = storageReference.putFile(script.file);

          await uploadTask.onComplete;

          print('Uploaded');

          await storageReference.getDownloadURL().then((value) {
            print(value);
            scenario.script = value;
          });
        } else {
          scenario.script = null;
        }
      } catch (e) {
        print(e);
        MySnackbar.showSnackbar(_context, "Upload file failed");
        return false;
      }
    }

    try {
      var response = await _repo.updateScenario(scenario);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Processing Data Failed from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing Data Failed");
      return false;
    }
  }

  Future<bool> deleteScence(int id) async {
    try {
      var response = await _repo.deleteScenario(id);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Processing Data Failed from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing Data Failed");
      return false;
    }
  }
}
