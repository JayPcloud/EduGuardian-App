import 'package:edu_guardian_app/features/edu/presentation/screens/growth_activities_screen.dart';
import 'package:edu_guardian_app/features/profile/presentation/screens/privacy_security_screen.dart';
import 'package:edu_guardian_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Screens and Shell
import '../../features/dashboard/presentation/screens/behaviour_screen.dart';
import '../../features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../../features/edu/presentation/screens/academic_preformance_screen.dart';
import '../../features/edu/presentation/screens/attendance_screen.dart';
import '../../features/edu/presentation/screens/badges_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../widgets/navigation/main_navigation_shell.dart';
import 'app_routes.dart';


part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home, 
    debugLogDiagnostics: true,
    
    // TODO: Add back auth redirect logic here later
    // redirect: (context, state) { ... },

    routes: [
      // -------------------------------------------------------------------
      // MAIN APP SHELL (Bottom Nav)
      // -------------------------------------------------------------------
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationShell(
            currentIndex: _getCurrentIndex(state.matchedLocation),
            onTabChanged: (index) => _onTabTapped(context, index),
            child: child, 
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeDashboardScreen(), 
          ),
          GoRoute(
            path: AppRoutes.academic,
            name: 'academic',
            builder: (context, state) => const AcademicPerformanceScreen(), 
          ),
          GoRoute(
            path: AppRoutes.attendance,
            name: 'attendance',
            builder: (context, state) => const AttendanceScreen(), 
          ),
          GoRoute(
            path: AppRoutes.badges,
            name: 'badges',
            builder: (context, state) => const BadgesScreen(), 
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(), // Placeholder
          ),
        ],
      ),

      // -------------------------------------------------------------------
      // STANDALONE PAGES (These render ON TOP of the bottom nav)
      // -------------------------------------------------------------------
      
      //Dashboard Screens
      GoRoute(
        path: AppRoutes.behaviorTimeline,
        name: 'behavior-timeline',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const BehaviorScreen(), 
      ),
      GoRoute(
        path: AppRoutes.growthAndActivity,
        name: 'growth-and-activity',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const GrowthActivitiesScreen(), 
      ),
      
      // Settings Screen
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'change-password',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const ChangePasswordScreen(), 
      ),
      GoRoute(
        path: AppRoutes.privacyAndSecurity,
        name: 'privacy-security',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const PrivacySecurityScreen(), 
      ),
      // Add Login/Signup routes ...
    ],
  );
}

// --- HELPER FUNCTIONS FOR BOTTOM NAV LOGIC ---

int _getCurrentIndex(String location) {
  if (location.startsWith(AppRoutes.home)) return 0;
  if (location.startsWith(AppRoutes.academic)) return 1;
  if (location.startsWith(AppRoutes.attendance)) return 2;
  if (location.startsWith(AppRoutes.badges)) return 3;
  if (location.startsWith(AppRoutes.settings)) return 4;
  return 0; // Default to Home
}

void _onTabTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go(AppRoutes.home);
      break;
    case 1:
      context.go(AppRoutes.academic);
      break;
    case 2:
      context.go(AppRoutes.attendance);
      break;
    case 3:
      context.go(AppRoutes.badges);
      break;
    case 4:
      context.go(AppRoutes.settings);
      break;
  }
}