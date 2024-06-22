class User {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final String token;
  final String verify;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.token,
    required this.verify,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['role'] ?? []),
      token: json['token'] ?? '',
      verify: json['email_verified_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'token': token,
      'verify': verify,
    };
  }
}
