import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/spacing_style.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

// --- DASHBOARD HEADER ---
class TeacherDashboardHeader extends StatelessWidget {
  const TeacherDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.only(
        top: Sizes.spaceXXXL, // Accounts for SafeArea
        left: Sizes.paddingL,
        right: Sizes.paddingL,
        bottom: Sizes.paddingXL,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            transform: GradientRotation(2.1),
            colors: [AppColors.accentBlue, AppColors.primaryDark,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(Sizes.radiusXXL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GOOD MORNING',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mrs. Okafor',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Friday, July 17',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () =>context.push(AppRoutes.alerts),
                    customBorder: RoundedRectangleBorder(borderRadius: AppSpacingStyle.allBorderRdMd),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Badge(
                        backgroundColor: AppColors.yellowAccent,
                        child: Icon(LucideIcons.bell, size: Sizes.iconM, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  const CircleAvatar(
                    backgroundColor: Color(0xFF002244), // Darker blue
                    radius: 20,
                    child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: Sizes.spaceXL),
          
          // Inner Info Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Sizes.radiusL),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 18),
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You have', style: textTheme.labelSmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 2),
                      Text(
                        '3 lessons and 2 pending attendance',
                        style: textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- STAT CARD ---
class StatCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const StatCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: Sizes.paddingM),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.radiusL),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: Sizes.spaceS),
            Text(count, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
    );
  }
}

// --- QUICK ACTION BUTTON ---
class QuickActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  const QuickActionBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        children: [
          InkWell(
            borderRadius: AppSpacingStyle.allBorderRdMd,
            onTap: onTap,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Icon(icon, color: iconColor, size: Sizes.iconM),
            ),
          ),
          const SizedBox(height: Sizes.spaceS),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCHEDULE CARD ---
class ScheduleCard extends StatelessWidget {
  final String timeH;
  final String timeM;
  final String subject;
  final String className;
  final String details;
  final String status;

  const ScheduleCard({
    super.key,
    required this.timeH,
    required this.timeM,
    required this.subject,
    required this.className,
    required this.details,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Row(
        children: [
          // Time Column
          Column(
            children: [
              Text(timeH, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(timeM, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(width: Sizes.spaceM),
          // Vertical Divider
          Container(height: 40, width: 1, color: theme.colorScheme.outline),
          const SizedBox(width: Sizes.spaceM),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$subject $className', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                const SizedBox(height: 4),
                FittedBox(
                  child: Row(
                    children: [
                      Icon(LucideIcons.users, size: 14, color: theme.colorScheme.outlineVariant),
                      const SizedBox(width: 4),
                      Text(details, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA), // Light Cyan
              borderRadius: BorderRadius.circular(Sizes.radiusS),
            ),
            child: Text(
              status,
              style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF00ACC1), fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}