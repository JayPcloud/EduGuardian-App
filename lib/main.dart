import 'package:edu_guardian_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'shared_features/auth/data/data_sources/auth_local_data_source.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  final openedUserBox = await Hive.openBox('user_box');

  runApp(
    ProviderScope(
      overrides: [
    userBoxProvider.overrideWithValue(openedUserBox),
  ], child: const EduGuardianApp(),
  ),
  );
}
