import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';

class MeetingRequestedSuccessScreen extends StatelessWidget {
  const MeetingRequestedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request meeting', 
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700, 
                color: colorScheme.onPrimaryContainer
              )
            ),
            // Replicating exactly what's in the screenshot
            Text(
              'Step 1 of 4', 
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.outlineVariant
              )
            ), 
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.paddingL, 
          vertical: Sizes.spaceXXL
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: Sizes.spaceXL),

            // Success Checkmark Icon
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F7FA), // Soft Cyan background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00BCD4), // Vivid Cyan border
                      width: 2.5
                    ), 
                  ),
                  child: const Icon(
                    Icons.check, 
                    color: Color(0xFF00BCD4), 
                    size: 28
                  ),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceXL),

            // Success Text
            Text(
              'Meeting requested',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary, // Using your brand's deep blue
              ),
            ),
            const SizedBox(height: Sizes.spaceS),
            Text(
              'Mr. Lawal will confirm within 24 hours. You\'ll get a\nnotification with the final link.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outlineVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: Sizes.spaceXXXL),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(Sizes.paddingL),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: theme.colorScheme.outline
                ),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('FOR', 'Ebele Okafor', theme),
                  Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2), height: Sizes.spaceL),
                  _buildSummaryRow('TEACHER', 'Mr. Lawal · Mathematics', theme),
                  Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2), height: Sizes.spaceL),
                  _buildSummaryRow('WHEN', 'Wed 9 · 09:00', theme),
                  Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2), height: Sizes.spaceL),
                  _buildSummaryRow('MODE', 'Video call', theme),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceXXXL),

            // Back to home button
            PrimaryButton(
              label: 'Back to home',
              onPressed: ()=>context.go(AppRoutes.home),
              ),
            const SizedBox(height: Sizes.spaceXL),

            // Book another meeting button
            InkWell(
              onTap: (){
                context.pop();
                context.pop();
                context.push(AppRoutes.requestMeeting);
              } ,
              child: Text(
                'Book another meeting',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for the summary card rows
  Widget _buildSummaryRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary.withValues(alpha: 0.8), // Faded blue tone for labels
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
    );
  }
}