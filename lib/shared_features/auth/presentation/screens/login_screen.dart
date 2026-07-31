import 'package:edu_guardian_app/shared_features/auth/presentation/providers/role_provider.dart';
import 'package:edu_guardian_app/shared_features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.userRole});

  final UserRole userRole;
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AuthScaffold(
        titleHeader: 'Welcome back',
        subtitle:
            widget.userRole==UserRole.teacher
            ?'Access class rosters, students result, attendance logs and parent messages '
            :'Access your child\'s attendance logs, behaviour, growth and academic report.',
        children: [
          LabeledTextField(
            label: 'Email',
            hintText: 'you@example.com ',
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: Sizes.spaceL),
          LabeledTextField(
            label: 'Password',
            hintText: '********',
            prefixIcon: LucideIcons.keyRound,
          ),
          // Password Field
          const SizedBox(height: Sizes.spaceM),

          // Checkbox & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() => _rememberMe = val ?? false);
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  GestureDetector(
                    onTap: () {
                      setState(() => _rememberMe = !_rememberMe);
                    },
                    child: Text(
                      'Remember me',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot password ?',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceXXXL),

          // Custom Primary Button
          PrimaryButton(
            label: 'Sign in',
            onPressed: () => context.go(AppRoutes.homeDashboard),
          ),
          const SizedBox(height: Sizes.spaceXXL),

          // Sign up text
          Center(
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.parentsSignup),
              child: RichText(
                text: TextSpan(
                  text: 'Dont have an account? ',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outlineVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
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
        ]);
    
  }

  // Extracted Label Builder
}
