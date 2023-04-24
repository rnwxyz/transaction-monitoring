class CredentionsModel {
  late String username;
  late String password;

  CredentionsModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
