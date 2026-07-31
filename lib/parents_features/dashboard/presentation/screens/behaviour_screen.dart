import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';

class BehaviorScreen extends StatelessWidget {
  const BehaviorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap:()=>context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Behavior', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Vertical timeline · last 7 days', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatusPill('Positive', Color(0xFF009CA6), theme), // Cyan
                const SizedBox(width: Sizes.spaceS),
                _buildStatusPill('Neutral', AppColors.neutralYellow, theme), // Yellow/Orange
                const SizedBox(width: Sizes.spaceS),
                _buildStatusPill('Concerning', AppColors.redAccent, theme),
              ],
            ),
            const SizedBox(height: Sizes.spaceXL),

            _buildBehaviorItem(theme, time: 'TODAY 09:00 AM', title: 'Present at morning assembly', desc: 'Recited the National Pledge — arrived before the bell.', teacher: 'Mrs Adanna', status: 'Positive', statusColor: Color(0xFF009CA6), isLast: false),
            _buildBehaviorItem(theme, time: 'TODAY 09:00 AM', title: 'Class prefect commendation', desc: 'Led group work on Simultaneous Equations during Maths.', teacher: 'Mrs Adanna', status: 'Positive', statusColor: Color(0xFF009CA6), isLast: false),
            _buildBehaviorItem(theme, time: 'TODAY 09:00 AM', title: 'Minor disruption', desc: 'Talking during Quiet Reading period. Verbal reminder given.', teacher: 'Mrs Adanna', status: 'Neutral', statusColor: AppColors.neutralYellow, isLast: false),
            _buildBehaviorItem(theme, time: 'TODAY 09:00 AM', title: 'Incomplete assignment', desc: 'Yoruba composition (Ìtàn Àkànṣe) not submitted.', teacher: 'Mrs Adanna', status: 'Concerning', statusColor: AppColors.redAccent, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String label, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: Sizes.paddingXS),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
      child: Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: Sizes.spaceXS),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBehaviorItem(ThemeData theme, {required String time, required String title, required String desc, required String teacher, required String status, required Color statusColor, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius:10,
                backgroundColor: statusColor.withValues(alpha:0.2),
                child: Icon(Icons.check, color: statusColor, size: Sizes.iconXS)),
              if (!isLast) Expanded(child: Container(width: 2, color: theme.colorScheme.outline.withValues(alpha: 0.3))),
            ],
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: Sizes.spaceL),
              padding: const EdgeInsets.all(Sizes.paddingM),
              decoration: BoxDecoration( border: Border.all(color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(Sizes.radiusM)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 2),
                        decoration: BoxDecoration( color:statusColor.withValues(alpha:0.2), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
                        child: Text(status, style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceS),
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: Sizes.spaceXS),
                  Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: Sizes.spaceM),
                  Text(teacher, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}