import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/growth_widgets.dart';

class GrowthActivitiesScreen extends StatefulWidget {
  const GrowthActivitiesScreen({super.key});

  @override
  State<GrowthActivitiesScreen> createState() => _GrowthActivitiesScreenState();
}

class _GrowthActivitiesScreenState extends State<GrowthActivitiesScreen> {
  int _selectedTab = 0;
  final tabs = ['Sports', 'Arts', 'Clubs', 'Projects'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=>context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Growth & activities', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Beyond the classroom', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = _selectedTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: Sizes.spaceS),
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ?null: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                        gradient: isSelected ? LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary]):null
                      ),
                      child: Text(
                        tabs[index],
                        style: textTheme.labelMedium?.copyWith(
                          color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: Sizes.spaceL),

            // Activity Cards
            const Row(
              children: [
                Expanded(child: ActivityCard(iconEmoji: '⚽', title: 'Football', subtitle: 'Midfielder — Green House', tag1: ' MVP', tag2: ' Inter-House')),
                SizedBox(width: Sizes.spaceM),
                Expanded(child: ActivityCard(iconEmoji: '🏃‍♂️', title: 'Athletics', subtitle: '200m Sprint', tag1: ' MVP', tag2: ' Inter-House')),
              ],
            ),
            const SizedBox(height: Sizes.spaceL),

            const DevelopmentalRadarCard(),
            const SizedBox(height: Sizes.spaceL),

            // THE CUTOFF SECTION FROM IMAGE 2
            const ParentFeedbackCard(),
            const SizedBox(height: Sizes.spaceXL),
          ],
        ),
      ),
    );
  }
}