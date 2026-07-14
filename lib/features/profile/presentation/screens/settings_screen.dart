import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/settings_components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('Beyond the classroom', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          children: [
            const ProfileHeroCard(),
            const SizedBox(height: Sizes.spaceXL),

            // Unified Settings List
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Column(
                children: [
                  SettingsSwitchTile(
                    icon: LucideIcons.bellRing,
                    title: 'Push notifications',
                    subtitle: 'Alerts, grades and behavior',
                    value: true,
                    onChanged: (val) {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsSwitchTile(
                    icon: LucideIcons.moon,
                    title: 'Dark mode',
                    subtitle: 'Alerts, grades and behavior', // Kept as in your design
                    value: false,
                    onChanged: (val) {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.shieldCheck,
                    title: 'Privacy & security',
                    onTap: ()=> context.push(AppRoutes.privacyAndSecurity),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.keyRound,
                    title: 'Change Password',
                    onTap: ()=> context.push(AppRoutes.changePassword),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.logOut,
                    title: 'Log out & switch role',
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}