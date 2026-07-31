import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../theme/app_colors.dart';
import '../buttons/primary_button.dart';


class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

    static Future<void> show(
    BuildContext context, {
    required String title,
    required String buttonText,
    required String message,
    required void Function()? onButtonPressed,
    bool? barrierDismissible
  }) {
    return showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        buttonText: buttonText,
        message: message, 
        onButtonPressed: onButtonPressed??() { },
      ),
      barrierDismissible: barrierDismissible??true,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      backgroundColor: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 48,
                color: AppColors.success,
              ),
            ),
            
            const SizedBox(height: Sizes.spaceL),
            
            // Title
            Text(
              title,
              style: TextTheme.of(context).titleLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: Sizes.spaceM),
            
            // Message
            Text(
              message,
              style:TextTheme.of(context).bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: Sizes.spaceXL),
            
            // Button
            PrimaryButton(
              label: buttonText,
              onPressed: onButtonPressed, 
              isLoading: false,
              trailingIcon: null,
            ),
          ],
        ),
      ),
    );
  }
}