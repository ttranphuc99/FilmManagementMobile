import 'dart:io';

class MyImage {
  num id;
  File imgFile;
  String url;
  bool isNew;
  bool isDelete;

  MyImage.fromURL(url, id) {
    this.url = url;
    this.id = id;
    isNew = false;
    isDelete = false;
  }

  MyImage();
}