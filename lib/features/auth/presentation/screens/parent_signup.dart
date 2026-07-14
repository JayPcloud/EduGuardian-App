import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:edu_guardian_app/features/auth/presentation/screens/child_selection_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/parent_signup_flow/activation_step.dart';
import '../widgets/parent_signup_flow/preferences_step.dart';
import '../widgets/parent_signup_flow/secure_step.dart';
import '../widgets/parent_signup_flow/verification_step.dart';


class ParentSignupFlowScreen extends StatefulWidget {
  const ParentSignupFlowScreen({super.key});

  @override
  State<ParentSignupFlowScreen> createState() => _ParentSignupFlowScreenState();
}

class _ParentSignupFlowScreenState extends State<ParentSignupFlowScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChildSelectionScreen(),
      ),
    );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Correctly extracting both Text and Colors from the dynamic theme
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              // Replace the LinearProgressIndicator with this Segmented Bar
              Row(
                children: List.generate(
                  _totalPages,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : Sizes.spaceS), // Gap between dashes
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentIndex
                            ? colorScheme.primary
                            : colorScheme.outline, // Inactive state
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
                      Text(
                        'Back',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceL),

              // Step Pill
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                  color: colorScheme.surface, // Adapts to dark/light surface
                ),
                padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingSm, vertical: Sizes.paddingXS),
                child: Text(
                  _getStepText(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceL),

              // Page Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: const [
                    ActivationStep(),
                    VerificationStep(),
                    SecureStep(),
                    PreferencesStep(),
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
            // Replace with your custom Primary Button if needed
            PrimaryButton(
              onPressed: _nextPage,
              label: _getButtonText(),
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
    if (_currentIndex == 0||_currentIndex==1) {
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