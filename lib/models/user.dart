class User {
  final String id;
  final String username;
  final String password;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      token: json['token'],
    );
  }
}
