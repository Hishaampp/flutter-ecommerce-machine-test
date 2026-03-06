class UserModel {
  final String id;
  final String token;
  final String? name;
  final String? email;

  UserModel({
    required this.id,
    required this.token,
    this.name,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      name: json['name']?.toString(),
      email: json['email']?.toString(),
    );
  }
}