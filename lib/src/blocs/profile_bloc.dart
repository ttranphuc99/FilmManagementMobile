import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/my_img.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final BuildContext _context;
  AuthRepository _repo = AuthRepository();

  ProfileBloc(this._context);

  PublishSubject<Account> _profile = PublishSubject<Account>();

  Observable<Account> get profile => _profile.stream;

  void close() {
    _profile.close();
  }

  Future<Account> loadData() async {
    try {
      var response = await _repo.getProfile();

      if (response.statusCode == 200) {
        var body = response.body;
        var data = json.decode(body);
        Account account = Account.fromJSON(data);

        _profile.sink.add(account);
        return account;
      } else {
        MySnackbar.showSnackbar(_context, "Error processing from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error processing");
    }
    return null;
  }

  Future<bool> update(Account account, MyImage avatar) async {
    try {
      //upload img
      if (avatar.isNew) {
        StorageReference storageReference;
        StorageUploadTask uploadTask;
        var filename = avatar.imgFile.path
            .substring(avatar.imgFile.path.lastIndexOf('/') + 1);

        storageReference =
            FirebaseStorage.instance.ref().child('script/' + filename);
        uploadTask = storageReference.putFile(avatar.imgFile);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((value) {
          print(value);
          avatar.url = value;
        });
      }

      account.image = avatar.url;

      var response = await _repo.update(account);

      if (response.statusCode == 200) {
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error processing from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error processing");
    }
    return false;
  }
}
