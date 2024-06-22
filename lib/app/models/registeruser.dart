class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RegisterUser {
  final int id;
  final String name;
  final String email;
  final List<Role> roles;
  final String token;

  RegisterUser({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.token,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles: (json['roles'] as List).map((role) => Role.fromJson(role)).toList(),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles.map((role) => role.toJson()).toList(),
      'token': token,
    };
  }
}
