import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/alerts_components.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: AppSpacingStyle.allBorderRdXl,
          onTap: ()=>context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alerts', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('School notifications', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.paddingL),
            child: Center(
              child: FilledButton(
                onPressed: () {
                  // TODO: Handle acknowledge all
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimaryContainer, // Dark navy
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
                ),
                child: Text('Ack all', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        children: [
          const AlertSectionHeader(icon: LucideIcons.bellRing, title: 'RECENT · 2'),
          const SizedBox(height: Sizes.spaceM),
          
          const AlertCard(
            title: 'PTA Meeting · Saturday',
            time: '2 hrs ago',
            body: '2nd Term PTA meeting at 10:00 AM in the school hall. Uniform: Saturday wear.',
          ),
          const AlertCard(
            title: 'Mathematics CA results published',
            time: 'Yesterday',
            body: 'Ebele scored 88% in the 2nd continuous assessment — full breakdown in Academics.',
          ),
          
          const SizedBox(height: Sizes.spaceL),
          
          const AlertSectionHeader(icon: LucideIcons.checkCircle, title: 'ACKNOWLEDGED · 3'),
          const SizedBox(height: Sizes.spaceM),
          
          const AlertCard(
            title: 'School closed tomorrow',
            time: '10 min ago',
            body: 'Due to a heavy rainfall warning across Lagos, all classes are suspended on Wednesday. Please keep your ward at home.',
          ),
          const AlertCard(
            title: 'School fees reminder',
            time: '2 days ago',
            body: '2nd Term balance of ₦185,000 due by Friday. Pay via school portal or Zenith Bank.',
          ),
          const AlertCard(
            title: 'NYSC medical outreach completed',
            time: '1 week ago',
            body: 'All JSS 1 students screened successfully by the corps members.',
          ),
        ],
      ),
    );
  }
}