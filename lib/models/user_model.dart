class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String userType;
  final String registrationStatus;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    required this.userType,
    required this.registrationStatus,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImage: json['profile_image_url'],
      userType: json['user_type'],
      registrationStatus: json['registration_status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
