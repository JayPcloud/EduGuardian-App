import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';

class ReviewConfirmStep extends StatelessWidget {
  const ReviewConfirmStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.spaceM),
          Text('Review & confirm', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
          const SizedBox(height: Sizes.spaceXS),
          Text("We'll notify Mr. Lawal once your submit", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
          const SizedBox(height: Sizes.spaceXL),
          
          Container(
            padding: const EdgeInsets.all(Sizes.paddingL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(Sizes.radiusXL),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFF4A7499), // Deep blue from avatar
                      child: Text('TL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                    const SizedBox(width: Sizes.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mr. Lawal', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                          Text('Mathematics teacher', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceL),
                Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                const SizedBox(height: Sizes.spaceS),
                
                _buildReviewRow('FOR', 'Ebele Okafor', theme),
                _buildReviewRow('WHEN', 'Wed 9 Oct · 09:00', theme),
                _buildReviewRow('MODE', 'Video call', theme),
                _buildReviewRow('NOTES', '—', theme, isLast: true),
              ],
            ),
          ),
          
          const SizedBox(height: Sizes.spaceXL),
          Text(
            'By requesting, you agree to school communication guidelines. The teacher has 24 hours to confirm or propose another slot.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, ThemeData theme, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Sizes.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700, 
              color: theme.colorScheme.outlineVariant,
              letterSpacing: 0.5,
            )
          ),
          const SizedBox(width: Sizes.spaceL),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600, 
                color: theme.colorScheme.onPrimaryContainer
              )
            ),
          ),
        ],
      ),
    );
  }
}