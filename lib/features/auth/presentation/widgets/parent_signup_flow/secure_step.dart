import 'package:edu_guardian_app/core/widgets/containers/round_rect_border.dart';
import 'package:edu_guardian_app/core/widgets/inputs/labeled_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';

class SecureStep extends StatelessWidget {
  const SecureStep({super.key});

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
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: "password.",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceSm),
          RichText(
            text: TextSpan(
              text: "You'll use this with ",
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              children: [
                TextSpan(
                  text: "chukwukaigboaka@gmail.com",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: " to sign in."),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXXL),
          
          LabeledTextField(label: 'Password', obscureText: true,),
          const SizedBox(height: Sizes.spaceM),
          LabeledTextField(label: 'Confirm password', obscureText: true,),
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
              color: colorScheme.primaryContainer, 
            ),
            child: Icon(Icons.check, size: 10, color: colorScheme.primary),
          ),
          const SizedBox(width: Sizes.spaceS),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}