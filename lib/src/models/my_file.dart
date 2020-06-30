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

  static getFilename(String url) {
    try {
      var length = url.length;
      if (length < 25) return url;

      var slashIndex = url.lastIndexOf('/');
      var queryStrIndex = url.lastIndexOf('?');

      if (queryStrIndex < 0 || slashIndex < 0) {
        return url.substring(0, 25);
      }

      var subUrl = url.substring(slashIndex + 10, queryStrIndex);
      print(subUrl);
      length = subUrl.length;

      if (length < 25) return subUrl;

      return subUrl.substring(0, 25) + "...";
    } catch (e) {
      print(e);
      return url.substring(0, 25);
    }
  }
}
