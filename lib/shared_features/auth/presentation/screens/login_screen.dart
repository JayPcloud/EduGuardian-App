

import 'package:edu_guardian_app/shared_features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utility/form_validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/auth_controllers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, required this.userRole});
  final UserRole userRole;
  
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authControllerProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // if (mounted) {
      //   // AppRouter's redirect will automatically handle sending them to the dashboard
      //   context.go(AppRoutes.homeDashboard); 
      // }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(e.toString(), context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isTeacher = widget.userRole == UserRole.teacher;
    final authState = ref.watch(authControllerProvider);

    return AuthScaffold(
      titleHeader: 'Welcome back',
      subtitle: isTeacher
          ? 'Access class rosters, students result, attendance logs and parent messages '
          : 'Access your child\'s attendance logs, behaviour, growth and academic report.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledTextField(
                label: 'Email',
                hintText: 'you@example.com ',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                
                validator: FormValidators.validateEmail,
              ),
              const SizedBox(height: Sizes.spaceL),
              LabeledTextField(
                label: 'Password',
                hintText: '********',
                prefixIcon: LucideIcons.keyRound,
                obscureText: _obscureText,
                controller: _passwordController,
                validator: FormValidators.validatePassword,
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscureText=!_obscureText;
                    });
                  }, 
                  icon: Icon(
                _obscureText ? LucideIcons.eyeOff : LucideIcons.eye, 
                size: 20, 
                color: theme.colorScheme.outlineVariant
              )),
              ),
              const SizedBox(height: Sizes.spaceM),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24, height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: Sizes.spaceS),
                      GestureDetector(
                        onTap: () => setState(() => _rememberMe = !_rememberMe),
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

              PrimaryButton(
                label: 'Sign in',
                isLoading: authState.isLoading,
                onPressed: authState.isLoading ? null : _handleLogin,
              ),

              const SizedBox(height: Sizes.spaceXXL),

          Center(
            child: GestureDetector(
              onTap: () => context.push(isTeacher?AppRoutes.teachersSignup: AppRoutes.parentsSignup),
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
            ],
          ),
        ),
      ],
    );
  }
}