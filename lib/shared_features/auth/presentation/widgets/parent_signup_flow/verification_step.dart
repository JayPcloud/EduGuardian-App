import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/containers/round_rect_border.dart';
import 'package:edu_guardian_app/core/widgets/inputs/otp_input_field.dart';
import '../../controllers/parent_signup_controller.dart';

class VerificationStep extends ConsumerWidget {
  final TextEditingController otpController;

  const VerificationStep({super.key, required this.otpController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final signupState = ref.watch(parentSignupControllerProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Confirm it's ",
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              children: [
                TextSpan(
                  text: "really you.",
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXL),

          // Invitation Card
          RoundRectBorder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVITATION FROM',
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
                const SizedBox(height: Sizes.spaceXS),
                Text('Greenfield International School', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: Sizes.spaceS),
                Text(
                  'For ${signupState.email }',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXXL),

          // 🚨 THE WIRING FIX 🚨
          // We listen to the built-in onChanged and feed it to our master controller
          OtpInputField(
            length: 6, // Or whatever length your API expects
            onChanged: (value) {
              otpController.text = value; // Updates the parent's controller silently
            },
            onCompleted: (value) {
              otpController.text = value;
              // Optional: You could auto-submit here if you want!
            },
          ),

          const SizedBox(height: Sizes.spaceL),

          InkWell(
            onTap: () {
              if (signupState.email.isNotEmpty) {
                ref.read(parentSignupControllerProvider.notifier).sendActivationCode(signupState.email);
              }
            },
            child: Text(
              "Didn't get a code? Resend",
              style: textTheme.labelMedium?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}