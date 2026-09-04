import 'package:edu_guardian_app/core/enums/enum_converters.dart';
import '../../../../core/enums/enums.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final String status;
  final bool biometricEnabled;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserRole> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emailVerifiedAt,
    required this.status,
    required this.biometricEnabled,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely extract the role from the 'roles' array

    List<UserRole> parsedRoles() {
    if (json['roles'] != null && (json['roles'] as List).isNotEmpty) {
      return (json['roles'] as List).map((role) => 
      EnumConverters.stringToUserRole(role.toString().toLowerCase()))
      .toList();
    }
    return [];
    }

    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'], // Can be null
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'])
          : null,
      status: json['status'] ?? 'pending',
      biometricEnabled: json['biometric_enabled'] ?? false,
      pushNotificationsEnabled: json['push_notifications_enabled'] ?? true,
      emailNotificationsEnabled: json['email_notifications_enabled'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      roles: parsedRoles(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'status': status,
      'biometric_enabled': biometricEnabled,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      // Reconstruct the roles array format for consistency when retrieving from local cache
      'roles': roles.map((r) => {'name': r.name}).toList()
    };
  }



  //Copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? emailVerifiedAt,
    String? status,
    bool? biometricEnabled,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<UserRole>? roles,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      status: status ?? this.status,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roles: roles ?? this.roles,
    );
  }
}