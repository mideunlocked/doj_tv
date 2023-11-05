class Users {
  final String id;
  final String email;
  final String fullName;
  final String password;

  const Users({
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json["id"] as String,
      email: json["email"] as String,
      fullName: json["fullName"] as String,
      password: json["password"] as String,
    );
  }

  Map<String, dynamic> toJson(String id) {
    return {
      "id": id,
      "email": email,
      "fullName": fullName,
      "password": password,
    };
  }
}
