import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/settings_components.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final darkNavy = const Color(0xFF101828); // Hardcoded specific brand color from screenshot

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy & security', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('How we handle your data', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          children: [
            SettingsHeroCard(
              gradientColors: [AppColors.primaryDark,darkNavy],
              title: "Your child's data, protected.",
              subtitle: "Last updated: 4 July 2026 · Version 1.2",
              pillText: "NDPA 2023 COMPLIANT",
              pillIcon: LucideIcons.shieldCheck,
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            PrivacyInfoCard(
              icon: LucideIcons.database,
              title: 'What we collect',
              body: 'Student profile (name, class, admission number), attendance and behaviour logs entered by teachers, academic scores from your child\'s school (e.g. Chrisland College), and parent contact details you provide during onboarding.',
            ),
            PrivacyInfoCard(
              icon: LucideIcons.userCog,
              title: 'How we use it',
              body: 'To show you your child\'s day-to-day school life — attendance, behaviour, academics and activities — and to send timely alerts. We never use student data for advertising or profiling.',
            ),
            PrivacyInfoCard(
              icon: LucideIcons.share2,
              title: 'Who we share with',
              body: 'Only your child\'s school administrators and the teachers assigned to their class. We do not sell data. Aggregated, anonymised statistics may be shared with the Ministry of Education where required by law.',
            ),
            PrivacyInfoCard(
              icon: LucideIcons.lock,
              title: 'How we protect it',
              body: 'Data is encrypted in transit (TLS 1.3) and at rest. Access is role-based and audited. Biometric login on your device keeps casual access out. Servers are hosted in a Nigeria-region data centre.',
            ),
            PrivacyInfoCard(
              icon: LucideIcons.shieldCheck,
              title: 'Your rights',
              body: 'You can request an export of your child\'s data, correct inaccurate records, or ask us to delete data no longer needed, subject to Nigeria Data Protection Act (NDPA 2023) retention rules for school records.',
            ),
            PrivacyInfoCard(
              icon: LucideIcons.mail,
              title: 'Contact our DPO',
              body: 'Data Protection Officer · privacy@eduguardian.ng · +234 809 000 1234',
              actionButton: FilledButton(
                onPressed: () {
                  // TODO: Handle email launch
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // Dark Navy matching the top banner
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusL)),
                ),
                child: const Text('Email privacy team', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}