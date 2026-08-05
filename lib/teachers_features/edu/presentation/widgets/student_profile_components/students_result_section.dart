// ==========================================
// TAB 3: RESULTS SECTION
// ==========================================
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../parents_features/edu/presentation/widgets/academic_widgets.dart';

class StudentResultsSection extends StatefulWidget {
  const StudentResultsSection({super.key});

  @override
  State<StudentResultsSection> createState() => _StudentResultsSectionState();
}

class _StudentResultsSectionState extends State<StudentResultsSection> {
  
  String _selectedClass = 'Jss3';
  String _selectedTerm = '1st Term';
  String _selectedSubject = 'Mathematics';

  // Dummy dropdown data
  final List<String> _classes = ['Jss1', 'Jss2', 'Jss3', 'Ss1', 'Ss2', 'Ss3'];
  final List<String> _terms = ['1st Term', '2nd Term', '3rd Term'];
  final List<String> _subjects = ['Mathematics', 'English', 'Basic Science', 'Physics', 'Chemistry'];
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AcademicFilterDropdown(
                initialLabel: _selectedClass,
                items: _classes,
                onSelected: (newValue) {
                  setState(() => _selectedClass = newValue);
                },
              ),
              const SizedBox(width: Sizes.spaceS),
              AcademicFilterDropdown(
                initialLabel: _selectedTerm,
                items: _terms,
                isBlueText: true, // Applies the blue text style you added for terms
                onSelected: (newValue) {
                  setState(() => _selectedTerm = newValue);
                },
              ),
              const SizedBox(width: Sizes.spaceS),
              AcademicFilterDropdown(
                initialLabel: _selectedSubject,
                items: _subjects,
                onSelected: (newValue) {
                  setState(() => _selectedSubject = newValue);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),
        
        // Result Card
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(Sizes.radiusL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingSm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(Sizes.radiusM), topLeft: Radius.circular(Sizes.radiusM)),
                ),
                child: Text('Mathematics', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: const EdgeInsets.all(Sizes.paddingL),
                child: Row(
                  children: [
                    // flex: 3 keeps the inputs perfectly sized relative to each other
                    Expanded(flex: 3, child: _buildGradeInputBox('CA', '10', theme)),
                    const SizedBox(width: Sizes.spaceS),
                    Expanded(flex: 3, child: _buildGradeInputBox('AS', '25', theme)),
                    const SizedBox(width: Sizes.spaceS),
                    Expanded(flex: 3, child: _buildGradeInputBox('EX', '45', theme)),
                    const SizedBox(width: Sizes.spaceS),
                    // flex: 4 gives the TOTAL column the extra horizontal space it needs to not crash
                    Expanded(
                      flex: 4, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOTAL', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          // scaleDown ensures it only shrinks as a last resort on extremely narrow devices
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text('80', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(width: 4),
                                Text('A', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF1E88E5))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.onPrimaryContainer),
        ],
      ),
    );
  }

  Widget _buildGradeInputBox(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Container(
          // Snugger horizontal padding (6 down from 8) to give the text more room to breathe
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(Sizes.radiusS),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 2), // Tiny buffer so text never touches the arrows
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.keyboard_arrow_up, size: 10, color: theme.colorScheme.outlineVariant),
                  Icon(Icons.keyboard_arrow_down, size: 10, color: theme.colorScheme.outlineVariant),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}