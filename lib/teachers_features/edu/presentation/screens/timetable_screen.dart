import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/academic_components.dart';

class TeachersTimetableScreen extends StatefulWidget {
  const TeachersTimetableScreen({super.key});

  @override
  State<TeachersTimetableScreen> createState() => _TeachersTimetableScreenState();
}

class _TeachersTimetableScreenState extends State<TeachersTimetableScreen> {
  String _selectedDate = '18';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18, color: colorScheme.onPrimaryContainer),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timetable',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'Term 1 · Week 1',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outlineVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.spaceM),
          
          // Horizontal Date Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
            child: Row(
              children: [
                DateSelectorChip(day: 'Mon', date: '18', isSelected: _selectedDate == '18', onTap: () => setState(() => _selectedDate = '18')),
                DateSelectorChip(day: 'Tue', date: '19', isSelected: _selectedDate == '19', onTap: () => setState(() => _selectedDate = '19')),
                DateSelectorChip(day: 'Wed', date: '20', isSelected: _selectedDate == '20', onTap: () => setState(() => _selectedDate = '20')),
                DateSelectorChip(day: 'Thu', date: '21', isSelected: _selectedDate == '21', onTap: () => setState(() => _selectedDate = '21')),
                DateSelectorChip(day: 'Fri', date: '22', isSelected: _selectedDate == '22', onTap: () => setState(() => _selectedDate = '22')),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXL),
          
          // Timetable List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
              children: const [
                TimetableCard(timeH: '12:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', duration: '45 min', studentCount: '32 students'),
                TimetableCard(timeH: '12:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', duration: '45 min', studentCount: '32 students'),
                TimetableCard(timeH: '12:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', duration: '45 min', studentCount: '32 students'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}