class User {
  String username;
  String password;

  User({
    this.username,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username ?? "",
      "password": password ?? "",
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      username: map["username"],
      password: map["password"],
    );
  }
}
