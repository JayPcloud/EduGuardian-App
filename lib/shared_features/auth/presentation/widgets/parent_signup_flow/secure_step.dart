import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/utility/form_validators.dart';
import '../../../../../core/widgets/containers/round_rect_border.dart';
import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';

class SecureStep extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  const SecureStep({super.key, required this.passwordController, required this.confirmController});

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
              text: "Create your ",
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              children: [
                TextSpan(
                  text: "password.",
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXXL),
          
          LabeledTextField(
            label: 'Password', 
            obscureText: true,
            controller: passwordController,
            validator: FormValidators.validatePassword,
          ),
          const SizedBox(height: Sizes.spaceM),
          LabeledTextField(
            label: 'Confirm password', 
            obscureText: true,
            controller: confirmController,
            validator: (val) => FormValidators.validateConfirmPassword(val, passwordController.text),
          ),
          const SizedBox(height: Sizes.spaceL),

          // Validation Checklist Card
          RoundRectBorderContainer(
            child: Column(
              children: [
                _buildCheckItem('At least 8 characters', true, textTheme, colorScheme),
                _buildCheckItem('One uppercase letter', true, textTheme, colorScheme),
                _buildCheckItem('One number', true, textTheme, colorScheme),
                _buildCheckItem('One symbol (!@#...)', true, textTheme, colorScheme),
                _buildCheckItem('Passwords match', true, textTheme, colorScheme),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isValid, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceS),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isValid ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest, 
            ),
            child: Icon(Icons.check, size: 10, color: isValid ? colorScheme.primary : colorScheme.outline),
          ),
          const SizedBox(width: Sizes.spaceS),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: isValid ? colorScheme.primary : colorScheme.outline,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}