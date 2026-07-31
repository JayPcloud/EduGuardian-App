class AppRoutes {

  // Auth & Onboarding
  static const String selectRole = '/select-role';
  static const String loadingPage = '/loading';
  static const String login = '/login';
  static const String parentsSignup = '/parents-signup';
  static const String teachersSignup = '/teachers-signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/verify-otp';
  static const String newPassword = '/new-password';
  
  // Parents Main Navigation (Bottom Nav)
  static const String homeDashboard = '/parent-dashboard';
  static const String academic = '/academic';
  static const String attendance = '/attendance';
  static const String messaging = '/messaging';
  static const String more = '/more';
  
  //Teachers Main Navigation (Bottom Nav)
  static const String teacherDashboard = '/teacher-dashboard';
  static const String classes = '/classes';
  static const String teacherAttendance = '/teacher-attendance';
  // static const String messaging = '/messaging';
  static const String teachersProfile = '/profile';

  // Sub-screens (Ontop of bottom nav)
  //Dashboard
  static const String behaviorTimeline = '/behavior-timeline';
  static const String growthAndActivity = '/growth-and-activity';
  
  // Edu
  static const String requestMeeting = '/request-meeting';
  static const String meetingRequestedSuccess = '/meeting-requested-success';
  //Teachers Edu
  static const String teachersTimeTable = '/teachers-timetable';
  static const String resultEntry = '/result-entry';

  //Messaging
  static const String chatDetail = '/chat';

  //More
  static const String badges = '/badges';
  static const String changePassword = '/change-password';
  static const String privacyAndSecurity = '/privacy-security';
  static const String settings = '/settings';

  //Notifications
  static const String alerts = '/alerts';

  
}