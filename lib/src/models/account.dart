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

  Account(String _username, String _password)
      : username = _username,
        password = _password,
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
        token = json['token'];

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
        'token': token
      };
}
