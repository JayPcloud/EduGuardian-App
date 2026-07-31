import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DateTimeSelectionStep extends StatefulWidget {
  const DateTimeSelectionStep({super.key});

  @override
  State<DateTimeSelectionStep> createState() => _DateTimeSelectionStepState();
}

class _DateTimeSelectionStepState extends State<DateTimeSelectionStep> {
  String _selectedDate = '9';
  String _selectedTime = '10:30';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.spaceM),
          Text('Pick a day & time', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
          const SizedBox(height: Sizes.spaceXS),
          Text('Blue slots are when Lawal is free', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
          const SizedBox(height: Sizes.spaceXL),
          
          // Calendar Header
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 16, color: theme.colorScheme.outlineVariant),
              const SizedBox(width: Sizes.spaceS),
              Text('October, 2026', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),

          // Date Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateCard('WED', '9', theme),
                _buildDateCard('THU', '10', theme),
                _buildDateCard('FRI', '11', theme),
                _buildDateCard('MON', '14', theme),
                _buildDateCard('TUE', '15', theme),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXL),

          // Time Header
          Row(
            children: [
              Icon(LucideIcons.clock, size: 16, color: theme.colorScheme.outlineVariant),
              const SizedBox(width: Sizes.spaceS),
              Text('Available times', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),

          // Time Selector
          Wrap(
            spacing: Sizes.spaceM,
            runSpacing: Sizes.spaceM,
            children: [
              _buildTimeChip('09:00', theme),
              _buildTimeChip('10:30', theme),
              _buildTimeChip('12:00', theme),
              _buildTimeChip('14:30', theme),
              _buildTimeChip('15:45', theme),
            ],
          ),
          const SizedBox(height: Sizes.spaceXL),

          // Message Header
          Row(
            children: [
              Icon(LucideIcons.messageSquare, size: 16, color: theme.colorScheme.outlineVariant),
              const SizedBox(width: Sizes.spaceS),
              Text('What would you like to discuss? (optional)', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),

          // Text Area
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "e.g Ebele's Social Studies performance and homework routine",
              hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7)),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.all(Sizes.paddingM),
              
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.radiusL),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateCard(String dayStr, String dateStr, ThemeData theme) {
    final isSelected = _selectedDate == dateStr;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedDate = dateStr),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: Sizes.spaceM),
        width: 65,
        padding: const EdgeInsets.symmetric(vertical: Sizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Column(
          children: [
            Text(dayStr, style: theme.textTheme.labelSmall?.copyWith(color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
            const SizedBox(height: Sizes.spaceXS),
            Text(dateStr, style: theme.textTheme.titleMedium?.copyWith(color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time, ThemeData theme) {
    final isSelected = _selectedTime == time;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A7499) : theme.colorScheme.surface, // Distinct blue as per design
          border: Border.all(color: isSelected ? const Color(0xFF4A7499) : theme.colorScheme.primary.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(Sizes.radiusCircular),
        ),
        child: Text(
          time,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}