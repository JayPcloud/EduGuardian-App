import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/success_dialog.dart';
import '../widgets/academic_components.dart';
import '../widgets/attendance_components.dart';

class ResultEntryScreen extends StatelessWidget {
  const ResultEntryScreen({super.key});

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
              'Result Entry',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'First Term',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outlineVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Main Area
          Expanded(
            child: Column(
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.spaceM),
                  child: Row(
                    children: const [
                      TeachersAttendanceFilterDropdown(
                        label: 'CLASS',
                        initialValue: 'JSS 3A',
                        items: ['JSS 1B', 'JSS 2C', 'SSS 1E', 'SSS 2C'],
                      ),
                      SizedBox(width: Sizes.spaceM),
                      TeachersAttendanceFilterDropdown(
                        label: 'SUBJECT',
                        initialValue: 'Mathematics',
                        items: ['Mathematics', 'Physics', 'English'],
                      ),
                    ],
                  ),
                ),
                
                // Expandable & Scrollable Table
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(Sizes.radiusL),
                      ),
                      child: Column(
                        children: [
                          // Fixed Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingS),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(Sizes.radiusM),
                                topLeft: Radius.circular(Sizes.radiusM),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text('STUDENT', style: _headerStyle(theme))),
                                const SizedBox(width: Sizes.spaceS),
                                Expanded(flex: 2, child: Text('CA', style: _headerStyle(theme))),
                                const SizedBox(width: Sizes.spaceXS),
                                Expanded(flex: 2, child: Text('AS', style: _headerStyle(theme))),
                                const SizedBox(width: Sizes.spaceXS),
                                Expanded(flex: 2, child: Text('EX', style: _headerStyle(theme))),
                                const SizedBox(width: Sizes.spaceS),
                                Expanded(flex: 1, child: Text('TOTAL', style: _headerStyle(theme), textAlign: TextAlign.center)),
                              ],
                            ),
                          ),
                          
                          // Scrollable Table List
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero, // Keeps the first item flush against the header
                              children: const [
                                ResultEntryRow(name: 'Ifeoma Eze', studentId: 'EDU/JSS3A/001', caScore: '10', asScore: '25', exScore: '45', total: '80', grade: 'A', gradeColor: Color(0xFF1E88E5)),
                                ResultEntryRow(name: 'Kunle Musa', studentId: 'EDU/JSS3A/001', caScore: '10', asScore: '25', exScore: '45', total: '77', grade: 'A', gradeColor: Color(0xFF1E88E5)),
                                ResultEntryRow(name: 'Obinna Nw..', studentId: 'EDU/JSS3A/001', caScore: '10', asScore: '10', exScore: '20', total: '40', grade: 'E', gradeColor: Colors.purpleAccent),
                                ResultEntryRow(name: 'Blessing Be..', studentId: 'EDU/JSS3A/001', caScore: '10', asScore: '25', exScore: '45', total: '77', grade: 'A', gradeColor: Color(0xFF1E88E5)),
                                ResultEntryRow(name: 'Chioma Ed..', studentId: 'EDU/JSS3A/001', caScore: '05', asScore: '15', exScore: '45', total: '65', grade: 'B', gradeColor: Color(0xFF5E35B1)),
                                ResultEntryRow(name: 'Sarah Edwa..', studentId: 'EDU/JSS3A/001', caScore: '05', asScore: '05', exScore: '10', total: '20', grade: 'F', gradeColor: Color(0xFFE53935)),
                                ResultEntryRow(name: 'Sarah Edwa..', studentId: 'EDU/JSS3A/001', caScore: '05', asScore: '05', exScore: '10', total: '20', grade: 'F', gradeColor: Color(0xFFE53935)),
                                ResultEntryRow(name: 'Sarah Edwa..', studentId: 'EDU/JSS3A/001', caScore: '05', asScore: '05', exScore: '10', total: '20', grade: 'F', gradeColor: Color(0xFFE53935)),
                                // Add more records here; they will smoothly scroll!
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Pinned Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.paddingM,
              vertical: Sizes.paddingS
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: ()=> SuccessDialog.show(
                      context, 
                      title: 'Submitted for Approval', 
                      buttonText: 'Done', 
                      message: 'Your result sheet has been forwarded to the Head of department for review', 
                      onButtonPressed:()=>context.pop()
                      ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius)),
                    ),
                    child: Text(
                      'Save',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Submit',
                    onPressed: ()=> SuccessDialog.show(
                      context, 
                      title: 'Scores Saved', 
                      buttonText: 'Done', 
                      message: '10 student records for JSS 3A have been saved', 
                      onButtonPressed:()=>context.pop()
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(ThemeData theme) {
    return theme.textTheme.labelSmall!.copyWith(
      color: theme.colorScheme.outlineVariant,
      fontWeight: FontWeight.w700,
      fontSize: 10,
    );
  }
}