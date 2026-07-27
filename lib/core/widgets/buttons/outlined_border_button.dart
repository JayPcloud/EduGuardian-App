import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

class OutlinedBorderButton extends StatelessWidget {
  const OutlinedBorderButton({super.key,required this.label,this.onPressed,});

  final String label;
  final VoidCallback? onPressed;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
                  ),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
  }
}