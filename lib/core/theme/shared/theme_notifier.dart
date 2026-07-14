// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'theme_notifier.g.dart';

// // 🚨 Must be keepAlive so the theme doesn't reset when switching tabs!
// @Riverpod(keepAlive: true)
// class ThemeNotifier extends _$ThemeNotifier {
//   static const _boxName = 'settingsBox';
//   static const _themeKey = 'isDarkMode';

//   @override
//   ThemeMode build() {
//     // 1. Read synchronously from Hive (super fast!)
//     final box = Hive.box(_boxName);
    
//     // 2. Default to false (Light Mode) if it's the user's first time
//     final isDark = box.get(_themeKey, defaultValue: false) as bool;
    
//     return isDark ? ThemeMode.dark : ThemeMode.light;
//   }

//   void toggleTheme() {
//     final box = Hive.box(_boxName);
//     final isCurrentlyDark = state == ThemeMode.dark;
    
//     // 1. Save the new state to Hive so it remembers next time
//     box.put(_themeKey, !isCurrentlyDark);
    
//     // 2. Update the Riverpod state to instantly trigger the UI rebuild
//     state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
//   }
// }

// final settingsBoxProvider = Provider<Box>((ref) {
//   throw UnimplementedError('settingsBoxProvider must be overridden in main.dart');
// });