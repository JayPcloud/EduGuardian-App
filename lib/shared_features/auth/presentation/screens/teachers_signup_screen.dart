import 'package:edu_guardian_app/shared_features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';

class TeachersSignupScreen extends StatelessWidget {
  const TeachersSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return AuthScaffold(
      titleHeader: 'Sign up', 
      subtitle: 'Your account was created by your school admin. Signup with work email to activate account', 
      children: [
        LabeledTextField(
            label: 'School Email',
            hintText: 'Enter school email',
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: Sizes.spaceM),
          LabeledTextField(
            label: 'Activation Code',
            hintText: 'ADM-2024',
            prefixIcon: LucideIcons.keyRound,
          ),
          const SizedBox(height: Sizes.spaceM),
          LabeledTextField(
            label: 'Create Password',
            hintText: '********',
            prefixIcon: LucideIcons.lock,
          ),
          const SizedBox(height: Sizes.spaceM),
          LabeledTextField(
            label: 'Confirm Password',
            hintText: '********',
            prefixIcon: LucideIcons.lock,
          ),

          const SizedBox(height: Sizes.spaceXXXL),

          // Custom Primary Button
          PrimaryButton(
            label: 'Sign up',
            onPressed: () => context.go(AppRoutes.homeDashboard),
          ),
          const SizedBox(height: Sizes.spaceXXL),

          // Sign up text
          Center(
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.login),
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outlineVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceL),
      ]
    );
  }
}