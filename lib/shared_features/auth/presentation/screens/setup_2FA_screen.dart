import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../widgets/2FA_steps.dart';

enum TwoFAStep { selectMethod, inputDetail, verifyOtp, success, failure }
enum TwoFAMethod { sms, email }

class SetUp2FAScreen extends StatefulWidget {
  const SetUp2FAScreen({super.key});

  @override
  State<SetUp2FAScreen> createState() => _SetUp2FAScreenState();
}

class _SetUp2FAScreenState extends State<SetUp2FAScreen> {
  TwoFAStep _currentStep = TwoFAStep.selectMethod;
  TwoFAMethod? _selectedMethod;
  final TextEditingController _inputController = TextEditingController();
  
  bool _mockSuccess = true; 

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep == TwoFAStep.selectMethod) _currentStep = TwoFAStep.inputDetail;
      else if (_currentStep == TwoFAStep.inputDetail) _currentStep = TwoFAStep.verifyOtp;
      else if (_currentStep == TwoFAStep.verifyOtp) {
        _currentStep = _mockSuccess ? TwoFAStep.success : TwoFAStep.failure;
        _mockSuccess = !_mockSuccess;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep == TwoFAStep.inputDetail) _currentStep = TwoFAStep.selectMethod;
      else if (_currentStep == TwoFAStep.verifyOtp) _currentStep = TwoFAStep.inputDetail;
      else if (_currentStep == TwoFAStep.failure) _currentStep = TwoFAStep.verifyOtp;
      else Navigator.pop(context);
    });
  }

  int _getProgressStep() {
    switch (_currentStep) {
      case TwoFAStep.selectMethod: return 1;
      case TwoFAStep.inputDetail: return 2;
      case TwoFAStep.verifyOtp: return 3;
      case TwoFAStep.success:
      case TwoFAStep.failure: return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.spaceM),
              
              // Custom App Bar
              GestureDetector(
                onTap: _previousStep,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Set up 2FA', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceXL),
              
              // Segmented Progress Bar
              Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index < _getProgressStep() ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // Clean view switcher
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildActiveView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveView() {
    switch (_currentStep) {
      case TwoFAStep.selectMethod:
        return SelectMethodView(
          selectedMethod: _selectedMethod,
          onSelect: (method) {
            setState(() => _selectedMethod = method);
            _nextStep();
          },
        );
      case TwoFAStep.inputDetail:
        return InputDetailView(
          method: _selectedMethod!,
          controller: _inputController,
          onNext: _nextStep,
        );
      case TwoFAStep.verifyOtp:
        return VerifyOtpView(
          method: _selectedMethod!,
          target: _inputController.text,
          onVerify: _nextStep,
        );
      case TwoFAStep.success:
        return ResultView(isSuccess: true, onAction: () => Navigator.pop(context));
      case TwoFAStep.failure:
        return ResultView(
          isSuccess: false, 
          onAction: _previousStep,
          onChangeMethod: () => setState(() => _currentStep = TwoFAStep.selectMethod),
        );
    }
  }
}