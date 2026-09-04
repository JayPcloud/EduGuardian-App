import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/auth_status_controller.dart';
import '../controllers/parent_signup_controller.dart';
import '../widgets/parent_signup_flow/activation_step.dart';
import '../widgets/parent_signup_flow/preferences_step.dart';
import '../widgets/parent_signup_flow/secure_step.dart';
import '../widgets/parent_signup_flow/verification_step.dart';
import 'child_selection_screen.dart';


class ParentSignupFlowScreen extends ConsumerStatefulWidget {
  const ParentSignupFlowScreen({super.key});

  @override
  ConsumerState<ParentSignupFlowScreen> createState() => _ParentSignupFlowScreenState();
}

class _ParentSignupFlowScreenState extends ConsumerState<ParentSignupFlowScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final int _totalPages = 4;

  // 🚨 Keys & Controllers for each step
  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _verifyFormKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  final _secureFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 🚨 Preferences State
  bool _grades = true;
  bool _behavior = true;
  bool _attendance = true;
  bool _announcements = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🚨 THE MASTER NAVIGATION & API SUBMITTER
  Future<void> _handleNextOrSubmit() async {
    final controller = ref.read(parentSignupControllerProvider.notifier);

    try {
      if (_currentIndex == 0) {
        if (!_emailFormKey.currentState!.validate()) return;
        await controller.sendActivationCode(_emailController.text.trim());
        _moveToNextPage();
      } 
      else if (_currentIndex == 1) {
        // If your custom OtpInputField doesn't use standard validation, just check length
        if (_otpController.text.trim().length < 4) {
          AppSnackBar.error("Please enter a valid OTP", context: context);
          return;
        }
        await controller.verifyActivationCode(_otpController.text.trim());
        // 🚨 Refreshes the global auth state now that they are logged in!
        ref.read(authStatusNotifierProvider.notifier).refreshUserData();
        _moveToNextPage();
      } 
      else if (_currentIndex == 2) {
        if (!_secureFormKey.currentState!.validate()) return;
        await controller.setPassword(_passwordController.text, _confirmPasswordController.text);
        _moveToNextPage();
      } 
      else if (_currentIndex == 3) {
        await controller.setNotificationPreferences(
          grades: _grades,
          behavior: _behavior,
          attendance: _attendance,
          announcements: _announcements,
        );
        // All done! Move to Child Selection
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChildSelectionScreen(user: ref.read(parentSignupControllerProvider).user,)),
          );
        }
      }
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  void _moveToNextPage() {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final signupState = ref.watch(parentSignupControllerProvider); // Watch for loading!

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                children: List.generate(
                  _totalPages,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : Sizes.spaceS),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentIndex ? colorScheme.primary : colorScheme.outline,
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceM),
              
              // Back Button
              InkWell(
                onTap: _previousPage,
                borderRadius: BorderRadius.circular(Sizes.radiusS),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.paddingS),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios, size: Sizes.iconS, color: colorScheme.onSurfaceVariant),
                      Text('Back', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceL),

              // Step Pill
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                  color: colorScheme.surface,
                ),
                padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingSm, vertical: Sizes.paddingXS),
                child: Text(
                  _getStepText(),
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: Sizes.spaceL),

              // Page Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Locked to button nav
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  children: [
                    Form(key: _emailFormKey, child: ActivationStep(emailController: _emailController)),
                    VerificationStep(otpController: _otpController), // Custom OTP widget usually doesn't need a Form
                    Form(key: _secureFormKey, child: SecureStep(passwordController: _passwordController, confirmController: _confirmPasswordController)),
                    PreferencesStep(
                      initialGrades: _grades,
                      initialBehavior: _behavior,
                      initialAttendance: _attendance,
                      initialAnnouncements: _announcements,
                      onGradesChanged: (v) => _grades = v,
                      onBehaviorChanged: (v) => _behavior = v,
                      onAttendanceChanged: (v) => _attendance = v,
                      onAnnouncementsChanged: (v) => _announcements = v,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              onPressed: signupState.isLoading ? null : _handleNextOrSubmit,
              label: _getButtonText(),
              isLoading: signupState.isLoading, // 🚨 Loading spinner
             ),
            const SizedBox(height: Sizes.spaceM),
            _buildFooterText(colorScheme),
          ],
        ),
      ),
    );
  }

  String _getStepText() {
    switch (_currentIndex) {
      case 0: return 'Step 1 of 4. Activate';
      case 1: return 'Step 2 of 4. Verify';
      case 2: return 'Step 3 of 4. Secure';
      case 3: return 'Step 4 of 4. Preferences';
      default: return '';
    }
  }

  String _getButtonText() {
    switch (_currentIndex) {
      case 0: return 'Activate account';
      case 1: return 'Verify code';
      case 2: return 'Continue';
      case 3: return 'Continue';
      default: return 'Continue';
    }
  }

  Widget _buildFooterText(ColorScheme colorScheme) {
    if (_currentIndex == 0 || _currentIndex == 1) {
      return Text(
        "No invitation yet? Contact your school's admissions office.",
        style: TextStyle(color: colorScheme.outlineVariant, fontSize: Sizes.fontSizeS),
      );
    } else {
      return RichText(
        text: TextSpan(
          text: "Need help? ",
          style: TextStyle(color: colorScheme.outlineVariant, fontSize: Sizes.fontSizeS),
          children: [
            TextSpan(
              text: "Contact school",
              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
  }
}