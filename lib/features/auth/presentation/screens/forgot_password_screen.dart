import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                'Forget Password',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: Sizes.spaceS),
              Text(
                'Provide the email address linked with your account to reset your password',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // Email Input
              LabeledTextField(
                label: 'Email',
                hintText: 'you@example.com ',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: Sizes.spaceXXXL),

              // Buttons
              PrimaryButton(
                label: 'Request Password Reset Link',
                // Assuming your PrimaryButton accepts an icon or you have a way to render the arrow
                onPressed: () => context.push(AppRoutes.otpVerification)
              ),
              const SizedBox(height: Sizes.spaceM),
              OutlinedBorderButton(
                label: 'Cancel',
                onPressed: (){},
                )
            ],
          ),
        ),
      ),
    );
  }
}