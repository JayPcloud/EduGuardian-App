import 'package:edu_guardian_app/shared_features/auth/presentation/controllers/auth_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/controllers/role_provider.dart';
import '../widgets/settings_components.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
  late bool pushEnabled;
  late bool emailEnabled;

 @override
  void initState() {
    final user = ref.read(authStatusNotifierProvider);
    pushEnabled= user.value?.pushNotificationsEnabled??false;
    emailEnabled = user.value?.emailNotificationsEnabled??false;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context,) {
    final theme = Theme.of(context);
    final isParent = ref.read(roleProvider)==UserRole.parent;
    // final user = ref.watch(authStatusNotifierProvider);

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
                    value: pushEnabled,
                    onChanged: (val) {
                      setState(() {
                        pushEnabled=val;
                      });
                      ref.read(authStatusNotifierProvider.notifier).updateAndCacheUser(pushEnabled: val);
                    },
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
                    title: 'Email Notifications',
                    subtitle: 'Get notified of new sign-ins', // Kept as in your design
                    value: emailEnabled,
                    onChanged: (val)async{
                      setState(() {
                        emailEnabled=val;
                      });
                     ref.read(authStatusNotifierProvider.notifier).updateAndCacheUser(emailEnabled: val);
                    },
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SettingsActionTile(
                    icon: LucideIcons.logOut,
                    title: 'Log out',
                    isDestructive: true,
                    onTap: ()=> ref.read(authStatusNotifierProvider.notifier).logout(),
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