import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';


class DatePickerDropDown extends StatefulWidget {
  final String initialValue;
  final ValueChanged<DateTime>? onDateSelected;

  const DatePickerDropDown({
    super.key,
    required this.initialValue,
    this.onDateSelected
  });

  @override
  State<DatePickerDropDown> createState() => _DatePickerDropDownState();
}

class _DatePickerDropDownState extends State<DatePickerDropDown> {
  late String _currentValue;
  DateTime _selectedDate = DateTime.now(); // Defaults to today

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  // Helper to format date like "18th July, 2026"
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    String suffix = 'th';
    if (date.day % 10 == 1 && date.day != 11) suffix = 'st';
    else if (date.day % 10 == 2 && date.day != 12) suffix = 'nd';
    else if (date.day % 10 == 3 && date.day != 13) suffix = 'rd';

    return '${date.day}$suffix ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomCalendarDialog(initialDate: _selectedDate);
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _currentValue = _formatDate(picked);
      });
      if (widget.onDateSelected != null) widget.onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: _pickDate,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)), // Matched opacity from your other dropdowns
            borderRadius: BorderRadius.circular(Sizes.radiusL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DATE', // Uppercased to match your "CLASS" and "SESSION" labels
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

// --- CUSTOM CALENDAR DIALOG ---
class CustomCalendarDialog extends StatefulWidget {
  final DateTime initialDate;

  const CustomCalendarDialog({super.key, required this.initialDate});

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calendar math
    final int daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final int firstWeekday = _displayedMonth.weekday; // 1 = Monday, 7 = Sunday
    final int emptySlots = firstWeekday - 1; // Offset for Monday start

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month & Year Header
            Text(
              '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            
            // Days of the Week
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final isWeekend = index == 5 || index == 6; // Saturday or Sunday
                return Expanded(
                  child: Center(
                    child: Text(
                      _weekDays[index],
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isWeekend ? const Color(0xFFFF5252) : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 12),

            // Days Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 40, 
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: emptySlots + daysInMonth,
              itemBuilder: (context, index) {
                if (index < emptySlots) {
                  return const SizedBox.shrink();
                }

                final int day = index - emptySlots + 1;
                final DateTime dateOfCell = DateTime(_displayedMonth.year, _displayedMonth.month, day);
                final bool isSelected = _selectedDate.year == dateOfCell.year && _selectedDate.month == dateOfCell.month && _selectedDate.day == dateOfCell.day;
                
                // For UI display matching screenshot: Fake "past" days for days before the 12th in the visual example
                // In a real app, you'd compare with DateTime.now() to grey out past dates.
                final bool isPast = dateOfCell.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)); 
                
                final bool isWeekend = index % 7 == 5 || index % 7 == 6; // Sat/Sun
                
                Color textColor;
                if (isSelected) {
                  textColor = Colors.white;
                } else if (isPast) {
                  textColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5); // Faded grey for past
                } else if (isWeekend) {
                  textColor = const Color(0xFFFF5252); // Red for future weekends
                } else {
                  textColor = theme.colorScheme.onSurface; // Black/Dark for future weekdays
                }

                return GestureDetector(
                  onTap: () {
                    // Close dialog and return selected date
                    Navigator.of(context).pop(dateOfCell);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4A68FF) : Colors.transparent, // Solid blue for selected
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}