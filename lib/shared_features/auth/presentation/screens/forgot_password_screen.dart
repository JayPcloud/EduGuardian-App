import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utility/form_validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/auth_controllers.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(passwordResetControllerProvider.notifier).sendCode(_emailController.text.trim());
      if (mounted) context.push(AppRoutes.otpVerification);
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resetState = ref.watch(passwordResetControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Sizes.spaceM),
                const AuthHeader(),
                const SizedBox(height: Sizes.spaceXXXL),
                
                Text(
                  'Forgot Password',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
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
                  controller: _emailController,
                  validator: FormValidators.validateEmail,
                ),
                const SizedBox(height: Sizes.spaceXXXL),

                // Buttons
                PrimaryButton(
                  label: 'Request Password Reset Link',
                  isLoading: resetState.isLoading,
                  onPressed: resetState.isLoading ? null : _handleSendCode,
                ),
                const SizedBox(height: Sizes.spaceM),
                OutlinedBorderButton(
                  label: 'Cancel',
                  onPressed: () => context.pop(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}