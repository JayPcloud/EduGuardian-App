import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/enums.dart';
import '../../data/data_sources/auth_local_data_source.dart';

class RoleNotifier extends Notifier<UserRole?> {
  @override
  UserRole? build() {
    final localAuth = ref.watch(authLocalDataSourceProvider);
    return localAuth.getCachedActiveRole();
  }

  void setRole(UserRole role, {List<UserRole>? userRoles, bool? cacheRole}) async{
    if(userRoles!=null && cacheRole ==true) {
      if (state == null || !userRoles.contains(state)) {
      state = userRoles.first;
    }
    await ref.read(authLocalDataSourceProvider).cacheActiveRole(state??role);
    return;
  }
    
    state = role;
  }
}

final roleProvider = NotifierProvider<RoleNotifier, UserRole?>(() {
  return RoleNotifier();
});
