// profile.dart
class Profile {
  final int userId;
  final String username;
  final String nomer_telepon;
  final String alamat;

  Profile({
    required this.userId,
    required this.username,
    required this.nomer_telepon,
    required this.alamat,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['user_id'],
      username: json['username'],
      nomer_telepon: json['nomer_telepon'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'nomer_telepon': nomer_telepon,
      'alamat': alamat,
    };
  }
}
