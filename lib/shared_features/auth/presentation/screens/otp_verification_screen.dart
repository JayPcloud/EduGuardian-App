import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/otp_input_field.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/auth_controllers.dart';
import '../widgets/auth_header.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_otpController.text.trim().length < 6) { // Adjust length to match your OTP field
      AppSnackBar.error("Please enter the complete OTP", context: context);
      return;
    }

    try {
      await ref.read(passwordResetControllerProvider.notifier).verifyCode(_otpController.text.trim());
      if (mounted) context.pushReplacement(AppRoutes.newPassword);
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  Future<void> _handleResend() async {
    final email = ref.read(passwordResetControllerProvider).value?.email;
    if (email == null || email.isEmpty) return;

    try {
      await ref.read(passwordResetControllerProvider.notifier).sendCode(email);
      if (mounted) AppSnackBar.success("Code resent successfully", context: context);
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resetState = ref.watch(passwordResetControllerProvider);
    final savedEmail = resetState.value?.email ?? "your email";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.spaceM),
              const AuthHeader(),
              const SizedBox(height: Sizes.spaceXXXL),
              
              Text(
                'Code Verification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: Sizes.spaceS),
              Text(
                'Enter OTP (One time password) sent to\n$savedEmail',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // Your Custom OTP Widget
              OtpInputField(
                length: 6,
                onChanged: (code) => _otpController.text = code,
                onCompleted: (code) {
                  _otpController.text = code;
                  _handleVerify(); // Auto-verify!
                },
              ),
              const SizedBox(height: Sizes.spaceS),
              
              // Timer
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '2:00 mins',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: Sizes.spaceXXXL),

              // Buttons
              PrimaryButton(
                label: 'Verify Code',
                isLoading: resetState.isLoading,
                onPressed: resetState.isLoading ? null : _handleVerify,
              ),
              const SizedBox(height: Sizes.spaceM),
              OutlinedBorderButton(
                label: 'Resend Code',
                onPressed: resetState.isLoading ? () {} : _handleResend,
              )
            ],
          ),
        ),
      ),
    );
  }
}