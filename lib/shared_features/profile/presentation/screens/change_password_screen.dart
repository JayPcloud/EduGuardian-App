import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:edu_guardian_app/core/widgets/containers/round_rect_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/change_password_controller.dart';
import '../widgets/settings_components.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  // Obscure Text States
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Real-time Validation States
  bool _hasLength = false;
  bool _hasUpper = false;
  bool _hasNumber = false;
  bool _hasSymbol = false;
  bool _isMatch = false;

  @override
  void initState() {
    super.initState();
    // Listen to changes in real-time to update the validation checklist
    _newPasswordCtrl.addListener(_validatePassword);
    _confirmPasswordCtrl.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // The logic that powers the checklist UI
  void _validatePassword() {
    final pass = _newPasswordCtrl.text;
    final confirm = _confirmPasswordCtrl.text;

    setState(() {
      _hasLength = pass.length >= 8;
      _hasUpper = pass.contains(RegExp(r'[A-Z]'));
      _hasNumber = pass.contains(RegExp(r'[0-9]'));
      _hasSymbol = pass.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]')); // checks for symbols
      _isMatch = pass.isNotEmpty && pass == confirm;
    });
  }

  bool get _isFormValid => _hasLength && _hasUpper && _hasNumber && _hasSymbol && _isMatch && _currentPasswordCtrl.text.isNotEmpty;

  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;

    try {
      await ref.read(changePasswordControllerProvider.notifier).changePassword(
        currentPassword: _currentPasswordCtrl.text,
        newPassword: _newPasswordCtrl.text,
      );
      if (mounted) {
        AppSnackBar.success('Password updated successfully', context: context);
        context.pop(); // Go back after success
      }
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changePassState = ref.watch(changePasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Change Password', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('Keep your account secure', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeroCard( // Assuming you have this widget intact
              icon: LucideIcons.keyRound,
              title: 'Update your password',
              subtitle: "You'll stay signed in on this device",
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            // Form Fields
            RoundRectBorder(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Current password', 
                      theme: theme,
                      controller: _currentPasswordCtrl,
                      obscureText: _obscureCurrent,
                      onToggleEye: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const SizedBox(height: Sizes.spaceM),
                    _buildPasswordField(
                      label: 'New password', 
                      theme: theme,
                      controller: _newPasswordCtrl,
                      obscureText: _obscureNew,
                      onToggleEye: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: Sizes.spaceM),
                    _buildPasswordField(
                      label: 'Confirm new password', 
                      theme: theme,
                      controller: _confirmPasswordCtrl,
                      obscureText: _obscureConfirm,
                      // The prompt's UI had showEye: false here originally, but since you asked to make it toggleable, we enable it.
                      onToggleEye: () => setState(() => _obscureConfirm = !_obscureConfirm), 
                    ),
                    const SizedBox(height: Sizes.spaceM),

                    // Validation Box
                    Container(
                      padding: const EdgeInsets.all(Sizes.paddingM),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(Sizes.radiusM),
                      ),
                      child: Column(
                        children: [
                          _buildValidationRule('At least 8 characters', _hasLength, theme),
                          _buildValidationRule('One uppercase letter', _hasUpper, theme),
                          _buildValidationRule('One number', _hasNumber, theme),
                          _buildValidationRule('One symbol (!@#_)', _hasSymbol, theme),
                          _buildValidationRule('Passwords match', _isMatch, theme),
                        ],
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXL),

                    // Update Button (Disabled if not valid or loading)
                    PrimaryButton(
                      label: 'Update password',
                      trailingIcon: null,
                      isLoading: changePassState.isLoading,
                      onPressed: (_isFormValid && !changePassState.isLoading) ? _handleSubmit : null,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Updated to accept controllers and state dynamically
  Widget _buildPasswordField({
    required String label, 
    required ThemeData theme, 
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleEye,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
        const SizedBox(height: Sizes.spaceXS),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: theme.textTheme.bodyMedium, // Use standard text style so dots don't look weird
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: onToggleEye,
              child: Icon(
                obscureText ? LucideIcons.eyeOff : LucideIcons.eye, 
                size: 20, 
                color: theme.colorScheme.outlineVariant
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationRule(String text, bool isValid, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceS),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check : Icons.close, 
            size: 14, 
            color: isValid ? theme.colorScheme.primary : theme.colorScheme.outlineVariant
          ),
          const SizedBox(width: Sizes.spaceS),
          Text(text, style: theme.textTheme.labelSmall?.copyWith(
            color: isValid ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            fontWeight: FontWeight.w500,
          )),
        ],
      ),
    );
  }
}