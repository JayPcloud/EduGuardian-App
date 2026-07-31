import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class AcademicFilterDropdown extends StatefulWidget {
  final String initialLabel;
  final List<String> items;
  final Function(String) onSelected;
  final bool isBlueText; // Used for the "Term" dropdown which has blue text in your design

  const AcademicFilterDropdown({
    super.key,
    required this.initialLabel,
    required this.items,
    required this.onSelected,
    this.isBlueText = false,
  });

  @override
  State<AcademicFilterDropdown> createState() => _AcademicFilterDropdownState();
}

class _AcademicFilterDropdownState extends State<AcademicFilterDropdown> {
  late String _currentLabel;

  @override
  void initState() {
    super.initState();
    _currentLabel = widget.initialLabel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      color: theme.cardColor,
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusL)),
      onSelected: (value) {
        setState(() => _currentLabel = value);
        widget.onSelected(value);
      },
      itemBuilder: (context) {
        return widget.items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            height: 40, // Keeps the items tightly packed like the design
            child: Text(
              item, 
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                // Apply specific color if requested, otherwise default text color
                color: widget.isBlueText ? const Color(0xFF1E4C7A) : theme.colorScheme.onSurface,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingSm, vertical: Sizes.paddingXS),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5), 
          borderRadius: BorderRadius.circular(Sizes.radiusCircular)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentLabel, 
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary, 
                fontWeight: FontWeight.w600
              )
            ),
            const SizedBox(width: Sizes.spaceXS),
            Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}