import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../auth_text_field.dart';

class ActivationStep extends StatelessWidget {
  const ActivationStep({super.key});

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
              text: "Activate your ",
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: "parent account.",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceSm),
          Text(
            'Your school invited you when your child was admitted. Enter the phone or email they used, plus the activation code from the invitation.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: Sizes.spaceXXL),
          const LabeledTextField(
            label: 'Phone or email on the invitation',
            hintText: 'you@example.com or +234 901 234 5678',
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: Sizes.spaceM),
          const LabeledTextField(
            label: 'Activation code',
            hintText: 'e.g GF-4567',
            prefixIcon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }
}