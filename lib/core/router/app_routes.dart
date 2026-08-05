class AppRoutes {

  // -------------------------------------------------------------------
  // Shared Routes
  // -------------------------------------------------------------------
  
  // Auth & Onboarding
  static const String selectRole = '/select-role';
  static const String loadingPage = '/loading';
  static const String login = '/login';
  static const String parentsSignup = '/parents-signup';
  static const String teachersSignup = '/teachers-signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/verify-otp';
  static const String newPassword = '/new-password';
  static const String setup2FA = '/setup-2FA';

  // Shared Main Navigation (Bottom Nav)
  static const String homeDashboard = '/dashboard';
  static const String academic = '/academic';
  static const String classes = '/classes';
  static const String attendance = '/attendance';
  static const String messaging = '/messaging';
  static const String more = '/more';
  static const String teachersProfile = '/profile';

  // ---------------Stand alone Routes-------------------------
  //Messaging
  static const String chatDetail = '/chat';

  //More/Profile/Settings
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String privacyAndSecurity = '/privacy-security';

  //Notifications
  static const String alerts = '/alerts';




  // -------------------------------------------------------------------
  // Parents Routes
  // -------------------------------------------------------------------  

  //Dashboard
  static const String behaviorTimeline = '/behavior-timeline';
  static const String growthAndActivity = '/growth-and-activity';
  
  // Edu
  static const String requestMeeting = '/request-meeting';
  static const String meetingRequestedSuccess = '/meeting-requested-success';

  //More
  static const String badges = '/badges';
  
  
  


  // -------------------------------------------------------------------
  // Teachers Routes
  // -------------------------------------------------------------------  
  
  //Teachers Edu
  static const String teachersTimeTable = '/teachers-timetable';
  static const String resultEntry = '/result-entry';
  static const String classManagement = '/class-management';
  static const String studentProfileScreen = '/student-profile';
  
}