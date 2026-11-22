class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final int roleId;
  final String roleName;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    required this.roleId,
    required this.roleName,
  });

  bool get isAdmin => roleName == 'admin' || roleId == 2;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final roleData = json['roles'] as Map<String, dynamic>?;
    return UserProfile(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['full_name'],
      roleId: json['role_id'] ?? 1,
      roleName:
          roleData?['name'] ?? (json['role_id'] == 2 ? 'admin' : 'customer'),
    );
  }
}
