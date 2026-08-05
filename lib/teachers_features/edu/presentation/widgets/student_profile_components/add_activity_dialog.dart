
// ==========================================
// DATA MODEL
// ==========================================
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';

class ActivityItem {
  final String title;
  final String role;
  final List<String> tags;
  final IconData icon;

  ActivityItem({required this.title, required this.role, required this.tags, required this.icon});
}

// ==========================================
// ADD ACTIVITY DIALOG (Functional Form)
// ==========================================
class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final _titleController = TextEditingController();
  final _roleController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedCategory = 'Sports';

  final List<String> _categories = ['Sports', 'Academic', 'Arts', 'Leadership'];

  @override
  void dispose() {
    _titleController.dispose();
    _roleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    IconData icon = Icons.star;
    if (_selectedCategory == 'Sports') icon = Icons.sports_soccer;
    if (_selectedCategory == 'Academic') icon = Icons.menu_book;
    if (_selectedCategory == 'Arts') icon = Icons.palette;
    if (_selectedCategory == 'Leadership') icon = Icons.groups;

    final newActivity = ActivityItem(
      title: _titleController.text.trim(),
      role: _roleController.text.trim(),
      tags: tags,
      icon: icon,
    );

    Navigator.pop(context, newActivity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add New Activity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: theme.colorScheme.outlineVariant, size: 20),
                )
              ],
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            // Title & Category Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInputSection(
                    'Activity Title',
                    'e.g Football, Athletic',
                    child: TextFormField(
                      controller: _titleController,
                      style: theme.textTheme.labelMedium,
                      decoration: _inputDecoration(theme, 'e.g Football, Athletic'),
                    ),
                    theme: theme,
                  ),
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  flex: 2,
                  child: _buildInputSection(
                    'Category',
                    '',
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      icon: Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.outlineVariant),
                      style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface),
                      decoration: _inputDecoration(theme, ''),
                      isExpanded: true,
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceM),

            // Role / Position
            _buildInputSection(
              'Role/Position/Subtitle',
              '',
              child: TextFormField(
                controller: _roleController,
                style: theme.textTheme.labelMedium,
                decoration: _inputDecoration(theme, 'e.g Midfielder - Green House or 200m'),
              ),
              theme: theme,
            ),
            const SizedBox(height: Sizes.spaceM),

            // Tags
            _buildInputSection(
              'Tags(Comma Separated)',
              '',
              child: TextFormField(
                controller: _tagsController,
                style: theme.textTheme.labelMedium,
                decoration: _inputDecoration(theme, 'e.g MVP, Inter-House'),
              ),
              theme: theme,
            ),
            const SizedBox(height: Sizes.spaceXL),

            // Submit Button
            PrimaryButton(label: 'Add Activity', onPressed: _submit,trailingIcon: null,height: 40,)
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, String hint, {required Widget child, required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant),
     
    );
  }
}