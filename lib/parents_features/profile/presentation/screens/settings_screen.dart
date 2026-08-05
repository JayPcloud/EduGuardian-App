import 'package:edu_guardian_app/shared_features/auth/presentation/providers/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/settings_components.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isParent = ref.read(roleProvider)==UserRole.parent;

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
             ProfileHeroCard(
              isTeacher: !isParent,
            ),
            const SizedBox(height: Sizes.spaceXL),

            // Unified Settings List
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Column(
                children: [
                  SettingsSwitchTile(
                    icon: LucideIcons.bellRing,
                    title: 'Push notifications',
                    // subtitle: 'Alerts, grades and behavior',
                    value: true,
                    onChanged: (val) {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  
                  // SettingsActionTile(
                  //   icon: LucideIcons.shieldCheck,
                  //   title: 'Privacy & security',
                  //   onTap: ()=> context.push(AppRoutes.privacyAndSecurity),
                  // ),
                  SettingsActionTile(
                    icon: LucideIcons.key,
                    title: 'Change Password',
                    subtitle: 'Last changed 30 days ago',
                    onTap: ()=> context.push(AppRoutes.changePassword),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.shieldCheck,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Extra Security for your account',
                    onTap: ()=> context.push(AppRoutes.setup2FA),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                 
                  SettingsSwitchTile(
                    icon: LucideIcons.key,
                    title: 'Login Alerts',
                    subtitle: 'Get notified of new sign-ins', // Kept as in your design
                    value: true,
                    onChanged: (val) {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.logOut,
                    title: 'Log out',
                    isDestructive: true,
                    onTap: ()=>context.go(AppRoutes.selectRole),
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