import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';

// --- FILTER DROPDOWN CARD ---
class TeachersAttendanceFilterDropdown extends StatefulWidget {
  final String label;
  final String initialValue;
  final List<String> items;
  final ValueChanged<String>? onSelected;

  const TeachersAttendanceFilterDropdown({
    super.key,
    required this.label,
    required this.initialValue,
    required this.items,
    this.onSelected,
  });

  @override
  State<TeachersAttendanceFilterDropdown> createState() => _TeachersAttendanceFilterDropdownState();
}

class _TeachersAttendanceFilterDropdownState extends State<TeachersAttendanceFilterDropdown> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: PopupMenuButton<String>(
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        color: theme.cardColor,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusL)),
        onSelected: (value) {
          setState(() => _currentValue = value);
          if (widget.onSelected != null) widget.onSelected!(value);
        } ,
        itemBuilder: (context) {
          return widget.items.map((item) {
            return PopupMenuItem<String>(
              value: item,
              height: 40,
              child: Text(
                item,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(Sizes.radiusL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outlineVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _currentValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  // Hide icon if it's the 'Session' field which doesn't have an arrow in your design
                  if (widget.items.isNotEmpty)
                    Icon(Icons.keyboard_arrow_down, size: 16, color: colorScheme.outlineVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// --- QUICK ACTION CHIP ---
class TeachersAttendanceQuickAction extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const TeachersAttendanceQuickAction({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      borderRadius: AppSpacingStyle.allBorderRdSm,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// --- STAT SUMMARY CARD ---
class TeachersAttendanceStatCard extends StatelessWidget {
  final String letter;
  final String count;
  final Color color;

  const TeachersAttendanceStatCard({
    super.key,
    required this.letter,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Sizes.paddingM),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(Sizes.radiusL),
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceS),
            Text(
              count,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- STUDENT ATTENDANCE LIST TILE ---
class StudentAttendanceCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String? avatarUrl;
  final String currentStatus; // 'P', 'A', 'L', or 'E'
  final void Function(String) onStatusTap;

  const StudentAttendanceCard({
    super.key,
    required this.name,
    required this.studentId,
    this.avatarUrl,
    required this.currentStatus,
    required this.onStatusTap
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      child: Row(
        children: [
          if (avatarUrl != null) ...[
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(avatarUrl??''),//NetworkImage(avatarUrl!),
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(width: Sizes.spaceM),
          ] else ...[
            // Empty space to match the "Ifeoma Eze" alignment in design
            const SizedBox(width: 8), 
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                Text(
                  studentId,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          // Status Toggles
          Row(
            children: [
              _buildStatusCircle('P', const Color(0xFF00BFA5), currentStatus == 'P', ()=>onStatusTap('present')),
              const SizedBox(width: 6),
              _buildStatusCircle('A', const Color(0xFFF44336), currentStatus == 'A', ()=>onStatusTap('absent')),
              const SizedBox(width: 6),
              _buildStatusCircle('L', const Color(0xFFFFC107), currentStatus == 'L', ()=>onStatusTap('late')),
              const SizedBox(width: 6),
              _buildStatusCircle('E', const Color(0xFF2196F3), currentStatus == 'E', ()=>onStatusTap('excuse')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusCircle(String letter, Color activeColor, bool isActive, VoidCallback onStatusTap) {
    return InkWell(
      borderRadius: AppSpacingStyle.allBorderRdMd,
      onTap: onStatusTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFE0E0E0), // Active color or light grey
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF757575), // White text if active, dark grey if inactive
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}









class TeacherAttendanceShimmer extends StatelessWidget {
  const TeacherAttendanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Column(
        children: List.generate(5, (index) => Container(
          margin: const EdgeInsets.only(bottom: Sizes.spaceM),
          height: 90,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL)),
        )),
      ),
    );
  }
}