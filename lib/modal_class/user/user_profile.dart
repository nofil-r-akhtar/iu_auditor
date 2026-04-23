class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? department;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id:         json['id']?.toString() ?? '',
      name:       json['name']?.toString() ?? '',
      email:      json['email']?.toString() ?? '',
      role:       json['role']?.toString() ?? '',
      department: json['department']?.toString(),
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String get roleLabel {
    switch (role) {
      case 'senior_lecturer': return 'Senior Lecturer';
      case 'admin':           return 'Admin';
      case 'super_admin':     return 'Super Admin';
      case 'department_head': return 'Department Head';
      default:                return role;
    }
  }
}