import 'package:edu_guardian_app/shared_features/auth/presentation/providers/role_provider.dart';
import 'package:edu_guardian_app/shared_features/auth/presentation/screens/select_role_screen.dart';
import 'package:edu_guardian_app/shared_features/auth/presentation/screens/teachers_signup_screen.dart';
import 'package:edu_guardian_app/teachers_features/dashboard/presentation/screens/teacher_dashboard_screen.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/screens/attendance_screen.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/screens/my_classes_screen.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/screens/result_entry_screen.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Parents Screens and Shell
import '../../shared_features/auth/presentation/screens/forgot_password_screen.dart';
import '../../shared_features/auth/presentation/screens/login_screen.dart';
import '../../shared_features/auth/presentation/screens/otp_verification_screen.dart';
import '../../shared_features/auth/presentation/screens/parent_signup.dart';
import '../../parents_features/edu/presentation/screens/growth_activities_screen.dart';
import '../../parents_features/edu/presentation/screens/meeting_requested_success_screen.dart';
import '../../parents_features/edu/presentation/screens/request_meeting_screen.dart';
import 'package:edu_guardian_app/shared_features/messaging/presentation/screens/chat_detail_screen.dart';
import 'package:edu_guardian_app/shared_features/messaging/presentation/screens/messages_screen.dart';
import 'package:edu_guardian_app/parents_features/profile/presentation/screens/more_menu_screen.dart';
import 'package:edu_guardian_app/parents_features/profile/presentation/screens/privacy_security_screen.dart';
import 'package:edu_guardian_app/parents_features/profile/presentation/screens/settings_screen.dart';
import '../../shared_features/auth/presentation/screens/new_password_screen.dart';
import '../../parents_features/dashboard/presentation/screens/behaviour_screen.dart';
import '../../parents_features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../../parents_features/edu/presentation/screens/academic_preformance_screen.dart';
import '../../parents_features/edu/presentation/screens/attendance_screen.dart';
import '../../parents_features/edu/presentation/screens/badges_screen.dart';
import '../../parents_features/notifications/presentation/screens/alerts_screen.dart';
import '../../parents_features/profile/presentation/screens/change_password_screen.dart';
import '../widgets/navigation/main_navigation_shell.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.selectRole, 
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
            onTabChanged: (index) => _onTabTapped(context, index, ref.read(roleProvider)??UserRole.teacher),
            child: child, 
          );
        },
        routes: ref.watch(roleProvider)==UserRole.teacher
        ?[
          GoRoute(
            path: AppRoutes.homeDashboard,
            name: 'home-dashboard',
            builder: (context, state) => const TeacherDashboardScreen(), 
          ),
          GoRoute(
            path: AppRoutes.classes,
            name: 'classes',
            builder: (context, state) => const MyClassesScreen(), 
          ),
          GoRoute(
            path: AppRoutes.attendance,
            name: 'attendance',
            builder: (context, state) => const TeachersAttendanceScreen(), 
          ),
          GoRoute(
            path: AppRoutes.messaging,
            name: 'messaging',
            builder: (context, state) => const MessagesScreen(), 
          ),
          GoRoute(
            path: AppRoutes.teachersProfile,
            name: 'teacher-profile',
            builder: (context, state) => const Scaffold(), // Placeholder
          ),
        ]
        :[
          GoRoute(
            path: AppRoutes.homeDashboard,
            name: 'home-dashboard',
            builder: (context, state) => const ParentDashboardScreen(), 
          ),
          GoRoute(
            path: AppRoutes.academic,
            name: 'academic',
            builder: (context, state) => const AcademicPerformanceScreen(), 
          ),
          GoRoute(
            path: AppRoutes.attendance,
            name: 'attendance',
            builder: (context, state) => const ParentsAttendanceScreen(), 
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
        path: AppRoutes.selectRole,
        name: 'select-role',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const SelectRoleScreen(), 
      ),
      GoRoute(
        path: AppRoutes.parentsSignup,
        name: 'parents-signup',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const ParentSignupFlowScreen(), 
      ),
      GoRoute(
        path: AppRoutes.teachersSignup,
        name: 'teachers-signup',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const TeachersSignupScreen(), 
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) {
          final userRole = ref.read(roleProvider)??UserRole.parent;
          return LoginScreen(userRole: userRole,);
        }, 
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const ForgotPasswordScreen(), 
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'verify-otp',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const OtpVerificationScreen(), 
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        name: 'new-password',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const NewPasswordScreen(), 
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
      //Teachers Edu Routes
      GoRoute(
        path: AppRoutes.teachersTimeTable,
        name: 'teachers-timetable',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const TeachersTimetableScreen(), 
      ),
      GoRoute(
        path: AppRoutes.resultEntry,
        name: 'result-entry',
        parentNavigatorKey: rootNavigatorKey, 
        builder: (context, state) => const ResultEntryScreen(), 
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
  if (location.startsWith(AppRoutes.homeDashboard)) return 0;
  if (location.startsWith(AppRoutes.academic)||location.startsWith(AppRoutes.classes)) return 1;
  if (location.startsWith(AppRoutes.attendance)) return 2;
  if (location.startsWith(AppRoutes.messaging)) return 3;
  if (location.startsWith(AppRoutes.more)||location.startsWith(AppRoutes.teachersProfile)) return 4;
  return 0; // Default to Home
}

void _onTabTapped(BuildContext context, int index, UserRole userRole) {
  String route({required String parent, required String teacher}) {
    if(userRole==UserRole.teacher) {
      return teacher;
    }else{
      return parent;
    }
  }
  switch (index) {
    case 0:
      context.go(AppRoutes.homeDashboard);
      break;
    case 1:
      context.go(route(parent: AppRoutes.academic, teacher: AppRoutes.classes));
      break;
    case 2:
      context.go(AppRoutes.attendance);
      break;
    case 3:
      context.go(AppRoutes.messaging);
      break;
    case 4:
      context.go(route(parent: AppRoutes.more, teacher: AppRoutes.teachersProfile));
      break;
  }
}


