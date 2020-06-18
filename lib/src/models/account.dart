class Account {
  num id;
  String username;
  String password;
  String fullname;
  String description;
  String email;
  String phone;
  String image;
  int role;
  String token;
  String deviceToken;

  Account(String _username, String _password, String _deviceToken)
      : username = _username,
        password = _password,
        deviceToken = _deviceToken,
        id = -1;

  Account.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        fullname = json['fullname'],
        description = json['description'],
        email = json['email'],
        phone = json['phone'],
        image = json['image'],
        role = json['role'],
        token = json['token'],
        deviceToken = json['deviceToken'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'fullname': fullname,
        'description': description,
        'email': email,
        'phone': phone,
        'image': image,
        'role': role,
        'token': token,
        'deviceToken': deviceToken
      };
}
