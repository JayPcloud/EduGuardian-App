import 'package:edu_guardian_app/core/widgets/common/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utility/form_validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/auth_controllers.dart';
import '../widgets/auth_header.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(passwordResetControllerProvider.notifier).resetPassword(_passwordController.text);
      if (mounted) {
        SuccessDialog.show(
          context, 
          title: 'Password Updated', 
          buttonText: 'Go to Login', 
          message: 'Your password have been changed successfully. You can now login with your new password', 
          onButtonPressed: () => context.go(AppRoutes.login),
        );
      }
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
                  'New Credentials',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: Sizes.spaceXXL),

                // New Password Input
                LabeledTextField(
                  label: 'New Password',
                  hintText: '********',
                  prefixIcon: LucideIcons.keyRound,
                  obscureText: true,
                  controller: _passwordController,
                  validator: FormValidators.validatePassword,
                ),
                const SizedBox(height: Sizes.spaceM),
                LabeledTextField(
                  label: 'Confirm Password',
                  hintText: '********',
                  prefixIcon: LucideIcons.keyRound,
                  obscureText: true,
                  controller: _confirmController,
                  validator: (val) => FormValidators.validateConfirmPassword(val, _passwordController.text),
                ),
                              
                const SizedBox(height: Sizes.spaceM),

                // Password Rules
                Text(
                  'Password must be at least 8 characters long.\nPassword must contain at least one upper case.\nOne lower case letter.\nPassword must contain at least one number or special character.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: Sizes.spaceXXXL),

                // Buttons
                PrimaryButton(
                  label: 'Submit',
                  isLoading: resetState.isLoading,
                  onPressed: resetState.isLoading ? null : _handleSubmit,
                ),
                const SizedBox(height: Sizes.spaceM),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable text field builder for the passwords
  Widget _buildPasswordField(ThemeData theme, ColorScheme colorScheme, Color primaryBlue) {
    return TextField(
      obscureText: true,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: '********',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.outlineVariant,
        ),
        prefixIcon: Icon(LucideIcons.keyRound, color: colorScheme.outlineVariant, size: 20),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
          borderSide: BorderSide(color: primaryBlue),
        ),
      ),
    );
  }
}