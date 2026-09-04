import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utility/form_validators.dart';
import '../../../../../core/constants/app_sizes.dart';

class ActivationStep extends StatelessWidget {
  final TextEditingController emailController;

  const ActivationStep({super.key, required this.emailController});

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
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              children: [
                TextSpan(
                  text: "parent account.",
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
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
          LabeledTextField(
            label: 'Phone or email on the invitation',
            hintText: 'you@example.com or +234 901 234 5678',
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            validator: FormValidators.validateEmail, // 🚨 Wired validation
          ),
          // Note: If you want them to enter the code here instead of the next screen, 
          // add the second controller. Based on your _handleNextOrSubmit, we only send email here.
        ],
      ),
    );
  }
}