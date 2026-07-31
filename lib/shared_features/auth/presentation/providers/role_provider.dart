import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { parent, student, teacher }

class RoleNotifier extends Notifier<UserRole?> {
  @override
  UserRole? build() {
    // Default state is null (no role selected yet)
    return null;
  }

  void setRole(UserRole role) {
    state = role;
  }
}

final roleProvider = NotifierProvider<RoleNotifier, UserRole?>(() {
  return RoleNotifier();
});