import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/inputs/otp_input_field.dart';
import '../screens/setup_2FA_screen.dart';

// ==========================================
// VIEW 1: SELECT METHOD
// ==========================================
class SelectMethodView extends StatelessWidget {
  final TwoFAMethod? selectedMethod;
  final ValueChanged<TwoFAMethod> onSelect;

  const SelectMethodView({super.key, required this.selectedMethod, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('selectMethod'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MethodCard(
          title: 'SMS Message',
          subtitle: 'Receive a code by text message',
          icon: LucideIcons.messageSquare,
          isSelected: selectedMethod == TwoFAMethod.sms,
          onTap: () => onSelect(TwoFAMethod.sms),
        ),
        const SizedBox(height: Sizes.spaceM),
        _MethodCard(
          title: 'Email Code',
          subtitle: 'Receive a code by email',
          icon: LucideIcons.mail,
          isSelected: selectedMethod == TwoFAMethod.email,
          onTap: () => onSelect(TwoFAMethod.email),
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({required this.title, required this.subtitle, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.paddingL),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1) : theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.radiusL),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 24),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.normal)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// VIEW 2: INPUT DETAIL
// ==========================================
class InputDetailView extends StatelessWidget {
  final TwoFAMethod method;
  final TextEditingController controller;
  final VoidCallback onNext;

  const InputDetailView({super.key, required this.method, required this.controller, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSms = method == TwoFAMethod.sms;

    return Column(
      key: const ValueKey('inputDetail'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isSms ? 'Add Phone Number' : 'Add email address', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text(isSms ? 'We\'ll send a 6-digit code to this number' : 'We\'ll send a verification code to this email.', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.normal)),
        const SizedBox(height: Sizes.spaceXXL),
        
        TextFormField(
          controller: controller,
          keyboardType: isSms ? TextInputType.phone : TextInputType.emailAddress,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: isSms ? 'Add your phone number' : 'you@example.com',
            prefixIcon: isSms
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇳🇬', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Container(width: 1, height: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                      ],
                    ),
                  )
                : const Icon(LucideIcons.mail, size: 20),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.radiusM), borderSide: BorderSide(color: theme.colorScheme.outline,)),
          ),
        ),
        
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: onNext,
            label: 'Send Code',
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),
      ],
    );
  }
}

// ==========================================
// VIEW 3: VERIFY OTP
// ==========================================
class VerifyOtpView extends StatelessWidget {
  final TwoFAMethod method;
  final String target;
  final VoidCallback onVerify;

  const VerifyOtpView({super.key, required this.method, required this.target, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTarget = target.isEmpty ? (method == TwoFAMethod.sms ? '**345***90' : 'exa*@email.com') : target;

    return Column(
      key: const ValueKey('verifyOtp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Verification Code', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
        const SizedBox(height: Sizes.spaceXXL),
        
        OtpInputField(length: 6, onCompleted: (v) => onVerify()),
        
        const SizedBox(height: Sizes.spaceXL),
        Text('We sent a 6-digit code to $displayTarget', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
        
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: onVerify,
            label: 'Verify Code',
          ),
        ),
        const SizedBox(height: Sizes.spaceM),
        SizedBox(
          width: double.infinity,
          child: OutlinedBorderButton(
            onPressed: () {},
            label: 'Resend Code',
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),
      ],
    );
  }
}

// ==========================================
// VIEW 4: RESULT (Success/Failure)
// ==========================================
class ResultView extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback onAction;
  final VoidCallback? onChangeMethod;

  const ResultView({super.key, required this.isSuccess, required this.onAction, this.onChangeMethod});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainColor = isSuccess ? const Color(0xFF00C853) : const Color(0xFFFF5252);

    return Column(
      key: ValueKey(isSuccess ? 'success' : 'failure'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
            child: Icon(isSuccess ? Icons.check : Icons.close, color: Colors.white, size: 48),
          ),
        ),
        const SizedBox(height: Sizes.spaceXXL),
        Text(isSuccess ? '2FA is Enabled' : '2FA has Failed', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        Text(
          isSuccess ? 'You will be asked for a verification code when signing in from a new device' : 'The code you entered is incorrect or has expired',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant, height: 1.4),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: onAction,
            label: isSuccess ? 'Continue' : 'Try Again'
           
          ),
        ),
        if (!isSuccess && onChangeMethod != null) ...[
          const SizedBox(height: Sizes.spaceL),
          GestureDetector(
            onTap: onChangeMethod,
            child: Text('Choose another method', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
          ),
        ],
        const SizedBox(height: Sizes.spaceXL),
      ],
    );
  }
}