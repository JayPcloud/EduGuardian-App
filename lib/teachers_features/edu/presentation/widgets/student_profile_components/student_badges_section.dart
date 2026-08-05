// ==========================================
// TAB 4: BADGES SECTION
// ==========================================
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';

class StudentBadgesSection extends StatelessWidget {
  const StudentBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Search Bar
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Search Badges',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outlineVariant),
            prefixIcon: Icon(LucideIcons.search, size: 18, color: colorScheme.outlineVariant),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.radiusL), borderSide: BorderSide(color: theme.colorScheme.outline)),
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),
        
        // Badges Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: Sizes.spaceM,
            crossAxisSpacing: Sizes.spaceM,
            childAspectRatio: 0.65, // Makes the cards taller
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            // Setup exactly like the design
            if (index == 1) {
              return _buildBadgeCard('Track Star', AppAssets.trackStarBadge, const Color(0xFF43A047), 'Delivered eloquent debate presentations and public speaking at school assembly.', false, theme);
            } else if (index == 2) {
              return _buildBadgeCard('Math Genius',  AppAssets.mathsGeniusBadge, const Color(0xFF1E88E5), 'Scored 90+ in Mathematics', false, theme);
            } else if (index == 3) {
              return _buildBadgeCard('Star Orator', AppAssets.perfectAttendanceBadge, const Color(0xFFFFB300), 'Delivered eloquent debate presentations and public speaking at school assembly.', true, theme);
            }
            return _buildBadgeCard('Star Orator', AppAssets.perfectAttendanceBadge, const Color(0xFFFFB300), 'Delivered eloquent debate presentations and public speaking at school assembly.', false, theme);
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard(String title, String initials, Color iconColor, String desc, bool isRevoke, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Sizes.spaceS),
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor,
            child: Image.asset(initials),
          ),
          const SizedBox(height: Sizes.spaceM),
          Text(title,maxLines: 1,overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          const SizedBox(height: Sizes.spaceS),
          Expanded(
            child: Text(
              desc,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: Sizes.fontSizeXS),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isRevoke ? const Color(0xFFF44336) : const Color(0xFF004D99),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
                padding: const EdgeInsets.symmetric(vertical: 0), // Keeps it tight
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                isRevoke ? 'Revoke Badge' : 'Award Badge',
                maxLines: 1,overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}