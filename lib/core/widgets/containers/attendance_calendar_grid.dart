import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class AttendanceCalendarGrid extends StatefulWidget {
  final Map<DateTime, String> statusMap;

  const AttendanceCalendarGrid({super.key, required this.statusMap});

  @override
  State<AttendanceCalendarGrid> createState() => _AttendanceCalendarGridState();
}

class _AttendanceCalendarGridState extends State<AttendanceCalendarGrid> {
  // Track the currently viewed month. Defaults to the current actual month.
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Normalize to the 1st of the current month
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    // --- CALENDAR MATH ---
    // 1. How many days in this specific month?
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    // 2. What day of the week does the 1st fall on? (Dart: 1=Mon, 7=Sun)
    final firstWeekday = _currentMonth.weekday; 
    // 3. Convert to 0-indexed where 0=Sunday (to match your daysOfWeek array)
    final prefixEmptyCells = firstWeekday % 7; 
    // 4. Total boxes needed in the grid
    final totalCells = prefixEmptyCells + daysInMonth;

    // Helper for formatting the header
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final headerText = '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _prevMonth,
                icon: Icon(Icons.arrow_back_ios, size: 16, color: theme.colorScheme.outlineVariant),
              ),
              Text(headerText, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _nextMonth,
                icon: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.outlineVariant),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceL),
          
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((d) => Text(
              d, 
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700, 
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)
              )
            )).toList(),
          ),
          const SizedBox(height: Sizes.spaceM),
          
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 48, 
            ),
            itemCount: totalCells, 
            itemBuilder: (context, index) {
              // Render empty box if before the 1st of the month
              if (index < prefixEmptyCells) return const SizedBox.shrink();

              // Calculate actual day number
              final day = index - prefixEmptyCells + 1;
              final currentDate = DateTime(_currentMonth.year, _currentMonth.month, day);
              
              // 🚨 CHECK API DATA FOR THIS DATE
              final status = widget.statusMap[currentDate]?.toLowerCase();

              Color bgColor;
              Color textColor;
              bool hasDot = true;

              if (status == 'present') {
                bgColor = const Color(0xFFE8F5E9); 
                textColor = const Color(0xFF00BFA5); 
              } else if (status == 'late') {
                bgColor = const Color(0xFFFFF8E1); 
                textColor = const Color(0xFFFFB300); 
              } else if (status == 'absent') {
                bgColor = const Color(0xFFFFEBEE); 
                textColor = const Color(0xFFF44336); 
              } else if (status == 'excused') {
                bgColor = const Color(0xFFE3F2FD); 
                textColor = const Color(0xFF2196F3); 
              } else {
                // No record / Future / Weekends
                bgColor = theme.colorScheme.surfaceContainer.withValues(alpha: 0.3);
                textColor = theme.colorScheme.outlineVariant;
                hasDot = false;
              }

              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(Sizes.radiusS),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    if (hasDot) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceL),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Present', const Color(0xFF00BFA5), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Late', const Color(0xFFFFB300), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Absent', const Color(0xFFF44336), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Excused', const Color(0xFF2196F3), theme),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, ThemeData theme) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Flexible(child: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 10))),
        ],
      ),
    );
  }
}