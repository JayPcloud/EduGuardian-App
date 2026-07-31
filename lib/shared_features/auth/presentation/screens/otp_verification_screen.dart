import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/otp_input_field.dart';
import '../widgets/auth_header.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                'Enter OTP (One time password) sent to\nchukwukaigboaka@gmail.com',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // Your Custom OTP Widget
              OtpInputField(
                length: 6,
                onCompleted: (code) {
                  // TODO: Auto-verify code
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
                onPressed: () => context.pushReplacement(AppRoutes.newPassword)
              ),
              const SizedBox(height: Sizes.spaceM),
              OutlinedBorderButton(
                label: 'Resend Code',
                onPressed: (){},
                )
            ],
          ),
        ),
      ),
    );
  }
}