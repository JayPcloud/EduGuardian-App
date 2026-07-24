import 'package:edu_guardian_app/features/auth/presentation/screens/login_screen.dart';
import 'package:edu_guardian_app/features/auth/presentation/screens/parent_signup.dart';
import 'package:edu_guardian_app/features/edu/presentation/screens/growth_activities_screen.dart';
import 'package:edu_guardian_app/features/edu/presentation/screens/meeting_requested_success_screen.dart';
import 'package:edu_guardian_app/features/edu/presentation/screens/request_meeting_screen.dart';
import 'package:edu_guardian_app/features/messaging/presentation/screens/chat_detail_screen.dart';
import 'package:edu_guardian_app/features/messaging/presentation/screens/messages_screen.dart';
import 'package:edu_guardian_app/features/profile/presentation/screens/more_menu_screen.dart';
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
import '../../features/notifications/presentation/screens/alerts_screen.dart';
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
            path: AppRoutes.messaging,
            name: 'messaging',
            builder: (context, state) => const MessagesScreen(), 
          ),
          GoRoute(
            path: AppRoutes.more,
            name: 'more',
            builder: (context, state) => const MoreMenuScreen(), // Placeholder
          ),
        ],
      ),

      // -------------------------------------------------------------------
      // STANDALONE PAGES (These render ON TOP of the bottom nav)
      // -------------------------------------------------------------------
      

      //Auth Routes
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const ParentSignupFlowScreen(), 
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const LoginScreen(), 
      ),

      //Dashboard Routes
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

      //Edu Routes
      GoRoute(
        path: AppRoutes.requestMeeting,
        name: 'request-meeting',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const RequestMeetingScreen(), 
      ),
      GoRoute(
        path: AppRoutes.meetingRequestedSuccess,
        name: 'meeting-requested-success',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const MeetingRequestedSuccessScreen(), 
      ),

      //Messaging Routes
      GoRoute(
        path: AppRoutes.chatDetail,
        name: 'chat',
        builder: (context, state) => const ChatDetailScreen(), // Placeholder
      ),

      // 'More' Routes
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

      // Notifications/Alert Routes
      GoRoute(
        path: AppRoutes.alerts,
        name: 'alerts',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const AlertsScreen(), 
      ),
      
    ],
  );
}

// --- HELPER FUNCTIONS FOR BOTTOM NAV LOGIC ---

int _getCurrentIndex(String location) {
  if (location.startsWith(AppRoutes.home)) return 0;
  if (location.startsWith(AppRoutes.academic)) return 1;
  if (location.startsWith(AppRoutes.attendance)) return 2;
  if (location.startsWith(AppRoutes.messaging)) return 3;
  if (location.startsWith(AppRoutes.more)) return 4;
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
      context.go(AppRoutes.messaging);
      break;
    case 4:
      context.go(AppRoutes.more);
      break;
  }
}