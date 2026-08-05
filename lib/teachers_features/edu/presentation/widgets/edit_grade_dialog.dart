import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';

class EditGradeDialog extends StatefulWidget {
  final String studentName;
  final String subject;

  const EditGradeDialog({
    super.key,
    this.studentName = 'Ifeoma Eze',
    this.subject = 'Mathematics',
  });

  @override
  State<EditGradeDialog> createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<EditGradeDialog> {
  // Controllers pre-filled with the exact data from your design
  final _assignmentCtrl = TextEditingController(text: '18');
  final _textCtrl = TextEditingController(text: '17');
  final _examCtrl = TextEditingController(text: '50');

  int _totalScore = 85;

  @override
  void initState() {
    super.initState();
    // Add listeners to auto-calculate the total whenever the user types
    _assignmentCtrl.addListener(_calculateTotal);
    _textCtrl.addListener(_calculateTotal);
    _examCtrl.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _assignmentCtrl.dispose();
    _textCtrl.dispose();
    _examCtrl.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final assign = int.tryParse(_assignmentCtrl.text) ?? 0;
    final test = int.tryParse(_textCtrl.text) ?? 0;
    final exam = int.tryParse(_examCtrl.text) ?? 0;
    
    setState(() {
      _totalScore = assign + test + exam;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
      backgroundColor: theme.cardColor,
      insetPadding: const EdgeInsets.all(Sizes.paddingL),
      child: SingleChildScrollView( // Prevents overflow when keyboard pops up
        padding: const EdgeInsets.all(Sizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Grade for ${widget.studentName}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subject,
                        style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.outlineVariant),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.close, color: colorScheme.outlineVariant, size: 20),
                  ),
                )
              ],
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            // SCORE INPUTS (Responsive)
            Row(
              children: [
                Expanded(
                  child: _buildScoreInput(
                    label: 'Assignment(20)',
                    controller: _assignmentCtrl,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: Sizes.spaceS),
                Expanded(
                  child: _buildScoreInput(
                    label: 'Test (20)', 
                    controller: _textCtrl,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: Sizes.spaceS),
                Expanded(
                  child: _buildScoreInput(
                    label: 'Exam (60)',
                    controller: _examCtrl,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceL),

            // TOTAL SCORE CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F0FF), // Soft blue background
                borderRadius: BorderRadius.circular(Sizes.radiusL),
                border: Border.all(color: const Color(0xFFB3D4F5)), // Slightly darker blue border
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Score',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.radiusM),
                    ),
                    child: Text(
                      '$_totalScore',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceXL),

            // SAVE BUTTON
            PrimaryButton(
              label: 'Save Score',
              trailingIcon: null,
              height: 35,
              onPressed: () {
                // Pass the updated scores back when closed
                Navigator.pop(context, {
                  'assignment': int.tryParse(_assignmentCtrl.text) ?? 0,
                  'test': int.tryParse(_textCtrl.text) ?? 0,
                  'exam': int.tryParse(_examCtrl.text) ?? 0,
                  'total': _totalScore,
                });
              },
              
            )
          ],
        ),
      ),
    );
  }

  // Reusable input widget for the 3 fields
  Widget _buildScoreInput({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outlineVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          
        ),
      ],
    );
  }
}