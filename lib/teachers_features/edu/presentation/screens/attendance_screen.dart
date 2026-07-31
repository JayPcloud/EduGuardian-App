import 'package:edu_guardian_app/core/widgets/buttons/outlined_border_button.dart';
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:edu_guardian_app/core/widgets/common/success_dialog.dart';
import 'package:edu_guardian_app/core/widgets/inputs/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/attendance_components.dart';

class TeachersAttendanceScreen extends StatelessWidget {
  const TeachersAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'Term 1',
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
          // --- SCROLLABLE CONTENT AREA ---
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Sizes.spaceS,),
                  // 1. Dropdown Filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM,),
                    child: Row(
                      children: [
                        TeachersAttendanceFilterDropdown(
                          label: 'CLASS',
                          initialValue: 'JSS 3A',
                          items: ['JSS 1B', 'JSS 2C', 'SSS 1E', 'SSS 2C'],
                        ),
                        SizedBox(width: Sizes.spaceM),
                        DatePickerDropDown(
                          initialValue: '18th July, 2026', // Your default starting date
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
                    child: Row(
                      children: const [
                        TeachersAttendanceFilterDropdown(
                          label: 'CLASS', // From design screenshot
                          initialValue: 'Mathematics',
                          items: ['Mathematics', 'Physics'],
                        ),
                        SizedBox(width: Sizes.spaceM),
                        TeachersAttendanceFilterDropdown(
                          label: 'SESSION',
                          initialValue: 'Morning',
                          items: [], // Empty list hides the dropdown arrow
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceXL),

                  // 2. Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceM),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search Student',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outlineVariant),
                        prefixIcon: Icon(LucideIcons.search, size: 18, color: colorScheme.outlineVariant),
                        fillColor: theme.colorScheme.primaryContainer, // Very light blue tint from design
                        
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceXL),

                  // 3. Quick Action Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        SizedBox(width: Sizes.spaceM,),
                        TeachersAttendanceQuickAction(label: 'All present', bgColor: Color(0xFFE0F7FA), textColor: Color(0xFF00ACC1)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceQuickAction(label: 'All absent', bgColor: Color(0xFFFFEBEE), textColor: Color(0xFFE53935)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceQuickAction(label: 'Late', bgColor: Color(0xFFFFF8E1), textColor: Color(0xFFFFB300)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceQuickAction(label: 'Reset', bgColor: Color(0xFFEEEEEE), textColor: Color(0xFF757575)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceXL),

                  // 4. Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:Sizes.spaceM),
                    child: Row(
                      children: const [
                        TeachersAttendanceStatCard(letter: 'P', count: '30', color: Color(0xFF00BFA5)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceStatCard(letter: 'A', count: '2', color: Color(0xFFF44336)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceStatCard(letter: 'L', count: '1', color: Color(0xFFFFC107)),
                        SizedBox(width: Sizes.spaceS),
                        TeachersAttendanceStatCard(letter: 'E', count: '0', color: Color(0xFF2196F3)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceXL),
                  
                  // 5. Student List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:Sizes.spaceM),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                  const StudentAttendanceCard(
                    name: 'Chioma Eze',
                    studentId: 'EDU/JSS3A/001',
                    avatarUrl: 'assets/images/Ellipse 2752 (1).png',
                    currentStatus: 'P',
                  ),
                  const StudentAttendanceCard(
                    name: 'Kunle Musa',
                    studentId: 'EDU/JSS3A/002',
                    avatarUrl: 'assets/images/Ellipse 2752 (3).png', // Placeholder avatar
                    currentStatus: 'P',
                  ),
                  const StudentAttendanceCard(
                    name: 'Paul Munroe',
                    studentId: 'EDU/JSS3A/001',
                    avatarUrl: 'assets/images/Ellipse 2752 (2).png', // Placeholder avatar
                    currentStatus: 'P',
                  ),
                  const StudentAttendanceCard(
                    name: 'Oge Eze',
                    studentId: 'EDU/JSS3A/001',
                    avatarUrl: 'assets/images/Ellipse 2752 (1).png',
                    currentStatus: 'L',
                  ),
                  const StudentAttendanceCard(
                    name: 'Ifeoma Eze',
                    studentId: 'EDU/JSS3A/001',
                    avatarUrl: 'assets/images/Ellipse 2752.png',
                    currentStatus: 'P',
                  ),
                  const StudentAttendanceCard(
                    name: 'Ifeoma Eze',
                    studentId: 'EDU/JSS3A/001',
                    currentStatus: 'P',
                    avatarUrl: 'assets/images/Ellipse 2752.png',
                  ),
                      ],
                    ),
                  )
                  
                ],
              ),
            ),
          ),

          // --- PINNED BOTTOM NAVIGATION (Action Buttons) ---
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.paddingM,
              vertical: Sizes.paddingM,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedBorderButton(
                    label: 'Save draft',
                    onPressed: ()=> SuccessDialog.show(
                      context, 
                      title: 'Attendance saved', 
                      buttonText: 'Continue Marking', 
                      message: '10 students attendance for JS3A have been saved.', 
                      onButtonPressed:()=>context.pop()
                      ),
                    )
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Submit',
                    onPressed: ()=> SuccessDialog.show(
                      context, 
                      title: 'Attendance Submitted', 
                      buttonText: 'Done', 
                      message: 'Parents have been notified in the parents app.', 
                      onButtonPressed:()=>context.pop()
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}