

import 'dart:io';

class MyFile {
  String filename;
  String fileExtension;
  File file;
  String url;

  void reset() {
    filename = null;
    fileExtension = null;
    file = null;
    url = null;
  }
}