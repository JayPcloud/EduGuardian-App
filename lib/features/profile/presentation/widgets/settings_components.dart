import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// --- PROFILE HERO CARD ---
class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary])
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingL),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: const Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mrs. Okafor', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Parent  ·  3 students linked', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                radius: Sizes.radiusL,
                backgroundColor: Colors.white24,
                child: const Icon(LucideIcons.bell, color: Colors.white, size: Sizes.iconS)),
            )
          ],
        ),
      ),
    );
  }
}

// --- REUSABLE HERO CARD (Change Password & Privacy) ---
class SettingsHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? pillText;
  final IconData? pillIcon;
  final List<Color>? gradientColors;

  const SettingsHeroCard({
    super.key, required this.title, required this.subtitle, this.icon, this.pillText, this.pillIcon,this.gradientColors
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors:gradientColors??[theme.colorScheme.primary, theme.colorScheme.tertiary]),
         borderRadius: BorderRadius.circular(Sizes.radiusL)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pillText != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (pillIcon != null) Icon(pillIcon, size: 12, color: const Color(0xFFFFD700)),
                if (pillIcon != null) const SizedBox(width: 4),
                Text(pillText!, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white70)),
              ],
            ),
            const SizedBox(height: Sizes.spaceS),
          ],
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2)),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: Sizes.spaceS),
              ],
              Expanded(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: Sizes.spaceXS),
          Padding(
            padding: EdgeInsets.only(left: icon != null ? 36.0 : 0),
            child: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
          )
        ],
      ),
    );
  }
}

// --- SETTINGS TILES ---
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({super.key, required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.outlineVariant, size: 20),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: theme.colorScheme.primary,
          )
        ],
      ),
    );
  }
}

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const SettingsActionTile({super.key, required this.icon, required this.title, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive ? const Color(0xFFD84315) : theme.colorScheme.outlineVariant;
    final textColor = isDestructive ? const Color(0xFFD84315) : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: Sizes.spaceM),
            Expanded(child: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: textColor))),
            Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

// --- PRIVACY INFO CARD ---
class PrivacyInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? actionButton;

  const PrivacyInfoCard({super.key, required this.icon, required this.title, required this.body, this.actionButton});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5), shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: theme.colorScheme.outlineVariant),
              ),
              const SizedBox(width: Sizes.spaceS),
              Flexible(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer))),
            ],
          ),
          const SizedBox(height: Sizes.spaceS),
          Text(body, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, height: 1.4)),
          if (actionButton != null) ...[
            const SizedBox(height: Sizes.spaceM),
            actionButton!,
          ]
        ],
      ),
    );
  }
}