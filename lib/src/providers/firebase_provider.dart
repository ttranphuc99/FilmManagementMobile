import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> getDeviceToken() async {
    String token;
    await _firebaseMessaging.getToken().then((value) => token = value);
    return token;
  }
}