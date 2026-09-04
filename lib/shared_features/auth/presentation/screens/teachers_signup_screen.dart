import 'package:edu_guardian_app/shared_features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utility/form_validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/teacher_signup_controller.dart';

class TeachersSignupScreen extends ConsumerStatefulWidget {
  const TeachersSignupScreen({super.key});

  @override
  ConsumerState<TeachersSignupScreen> createState() => _TeachersSignupScreenState();
}

class _TeachersSignupScreenState extends ConsumerState<TeachersSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(teacherSignupControllerProvider.notifier).activateAccount(
        email: _emailController.text.trim(),
        code: _codeController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      );
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final signupState = ref.watch(teacherSignupControllerProvider);
    
    return AuthScaffold(
      titleHeader: 'Sign up', 
      subtitle: 'Your account was created by your school admin. Signup with work email to activate account', 
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledTextField(
                label: 'School Email',
                hintText: 'Enter school email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                validator: FormValidators.validateEmail,
              ),
              const SizedBox(height: Sizes.spaceM),
              LabeledTextField(
                label: 'Activation Code',
                hintText: 'ADM-2024',
                prefixIcon: LucideIcons.keyRound,
                controller: _codeController,
                validator: (val) => FormValidators.validateRequired(val, 'Activation Code'),
              ),
              const SizedBox(height: Sizes.spaceM),
              LabeledTextField(
                label: 'Create Password',
                hintText: '********',
                prefixIcon: LucideIcons.lock,
                obscureText: true,
                controller: _passwordController,
                validator: FormValidators.validatePassword,
              ),
              const SizedBox(height: Sizes.spaceM),
              LabeledTextField(
                label: 'Confirm Password',
                hintText: '********',
                prefixIcon: LucideIcons.lock,
                obscureText: true,
                controller: _confirmController,
                validator: (val) => FormValidators.validateConfirmPassword(val, _passwordController.text),
              ),

              const SizedBox(height: Sizes.spaceXXXL),

              // Custom Primary Button
              PrimaryButton(
                label: 'Sign up',
                isLoading: signupState.isLoading,
                onPressed: signupState.isLoading ? null : _handleSignup,
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
            ],
          ),
        ),
      ]
    );
  }
}