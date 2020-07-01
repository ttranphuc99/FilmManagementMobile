import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/models/my_img.dart';
import 'package:film_management/src/repositories/equipment_image_repo.dart';
import 'package:film_management/src/repositories/equipment_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class EquipmentDetailBloc {
  final EquipmentRepo _repo = EquipmentRepo();
  final EquipmentImageRepo _imgRepo = EquipmentImageRepo();
  final BuildContext _context;

  EquipmentDetailBloc(this._context);

  Future<Equipment> getById(num id) async {
    try {
      var response = await _repo.getById(id);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return Equipment.fromJSON(body);
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return null;
  }

  Future<bool> delete(num id) async {
    try {
      var response = await _repo.deleteEquipment(id);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return false;
  }

  Future<bool> update(Equipment equipment, List<MyImage> listImg) async {
    try {
      //upload img
      StorageReference storageReference;
      StorageUploadTask uploadTask;

      for (var img in listImg) {
        if (!img.isDelete && img.isNew) {
          var filename =
                      img.imgFile.path.substring(img.imgFile.path.lastIndexOf('/') + 1);

          storageReference =
              FirebaseStorage.instance.ref().child('script/' + filename);
          uploadTask = storageReference.putFile(img.imgFile);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((value) {
            print(value);
            img.url = value;
          });
        }
      }

      var response = await _imgRepo.addImage(equipment.id, listImg);
      if (response != null && response.statusCode != 201) {
        MySnackbar.showSnackbar(_context, "Error when post img from server");
        return false;
      }

      response = await _imgRepo.deleteImage(listImg);
      if (response != null && response.statusCode != 200) {
        MySnackbar.showSnackbar(_context, "Error when delete img from server");
        return false;
      }

      //update equipment
      response = await _repo.updateEquipment(equipment);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return false;
  }
}
