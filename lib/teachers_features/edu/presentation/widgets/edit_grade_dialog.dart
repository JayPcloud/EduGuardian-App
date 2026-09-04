import 'package:flutter/material.dart';
import '../../data/models/result_models.dart'; // Adjust path
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';

class EditGradeDialog extends StatefulWidget {
  final String studentName;
  final String subject;
  final List<ResultConfigModel> configs;
  final Map<String, String> initialScores;
  final void Function(Map<String, String>) onSaveScore;

  const EditGradeDialog({
    super.key,
    required this.studentName,
    required this.subject,
    required this.configs,
    required this.initialScores,
    required this.onSaveScore,
  });

  static void show(
    BuildContext context, {
    required String studentName,
    required String subject,
    required List<ResultConfigModel> configs,
    required Map<String, String> initialScores,
    required void Function(Map<String, String>) onSaveScore,
  }) {
    showDialog(
      context: context,
      builder: (context) => EditGradeDialog(
        studentName: studentName,
        subject: subject,
        configs: configs,
        initialScores: initialScores,
        onSaveScore: onSaveScore,
      ),
    );
  }

  @override
  State<EditGradeDialog> createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<EditGradeDialog> {
  final Map<String, TextEditingController> _controllers = {};
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers dynamically
    for (var config in widget.configs) {
      final ctrl = TextEditingController(text: widget.initialScores[config.id] ?? '');
      ctrl.addListener(_calculateTotal);
      _controllers[config.id] = ctrl;
    }
    _calculateTotal(); // Calculate initial total
  }

  @override
  void dispose() {
    for (var ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _calculateTotal() {
    int total = 0;
    for (var ctrl in _controllers.values) {
      total += int.tryParse(ctrl.text) ?? 0;
    }
    setState(() {
      _totalScore = total;
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
      child: SingleChildScrollView(
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
            
            // SCORE INPUTS (Dynamically Generated)
            Row(
              children: widget.configs.map((config) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: config != widget.configs.last ? Sizes.spaceS : 0),
                    child: _buildScoreInput(
                      label: '${config.assessmentType} (${config.percentage})',
                      controller: _controllers[config.id]!,
                      theme: theme,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Sizes.spaceL),

            // TOTAL SCORE CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F0FF),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
                border: Border.all(color: const Color(0xFFB3D4F5)),
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
                final Map<String, String> results = {};
                for (var config in widget.configs) {
                  results[config.id] = _controllers[config.id]!.text;
                }
                widget.onSaveScore(results);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScoreInput({required String label, required TextEditingController controller, required ThemeData theme}) {
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
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}