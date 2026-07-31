import 'package:edu_guardian_app/core/widgets/inputs/otp_input_field.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/containers/round_rect_border.dart';

class VerificationStep extends StatelessWidget {
  const VerificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Confirm it's ",
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: "really you.",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
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
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outlineVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: Sizes.spaceXS),
                Text(
                  'Greenfield International School',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: Sizes.spaceS),
                Text(
                  'For Amaka Okafor · Mother of Chinedu Okafor, Ada Okafor',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXXL),
          
          // OTP Placeholder - SWAP THIS WITH YOUR CUSTOM OTP WIDGET
          OtpInputField(),
          
          const SizedBox(height: Sizes.spaceL),
          
          InkWell(
            onTap: (){},
            child: Text(
              "Didn't get a code? Resend",
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}