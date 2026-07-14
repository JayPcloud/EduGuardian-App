import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:edu_guardian_app/core/widgets/containers/round_rect_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/settings_components.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
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
            SettingsHeroCard(
              icon: LucideIcons.keyRound,
              title: 'Update your password',
              subtitle: "You'll stay signed in on this device",
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            // Form Fields
            RoundRectBorder(child: Column(
              children: [
                _buildPasswordField('Current password', theme),
            const SizedBox(height: Sizes.spaceM),
            _buildPasswordField('New password', theme),
            const SizedBox(height: Sizes.spaceM),
            _buildPasswordField('Confirm new password', theme, showEye: false),
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
                  _buildValidationRule('At least 8 characters', false, theme),
                  _buildValidationRule('One uppercase letter', false, theme),
                  _buildValidationRule('One number', false, theme),
                  _buildValidationRule('One symbol (!@#_)', false, theme),
                  _buildValidationRule('Passwords match', false, theme),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceXL),

            // Update Button (Disabled State as seen in design)
            PrimaryButton(label: 'Update password',trailingIcon: null,)
              ],
            ))
            
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, ThemeData theme, {bool showEye = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
        const SizedBox(height: Sizes.spaceXS),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            suffixIcon: showEye ? Icon(LucideIcons.eye, size: 20, color: theme.colorScheme.outlineVariant) : null,
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
          Icon(isValid ? Icons.check : Icons.close, size: 14, color: isValid ? theme.colorScheme.primary : theme.colorScheme.outlineVariant),
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