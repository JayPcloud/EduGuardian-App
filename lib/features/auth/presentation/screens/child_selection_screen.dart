
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/containers/selection_tile.dart';

class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({super.key});

  @override
  State<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen> {
  // Using a Set because the text says "Select all children", allowing multi-select
  final Set<String> _selectedChildren = {'Ebele Okafor'}; 

  void _toggleSelection(String name) {
    setState(() {
      if (_selectedChildren.contains(name)) {
        _selectedChildren.remove(name);
      } else {
        _selectedChildren.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.spaceXXL), 
              
              Text(
                'Who are you parenting',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onPrimaryContainer, // Dark navy
                ),
              ),
              const SizedBox(height: Sizes.spaceSm),
              
              Text(
                'Select all children linked to your account. You can switch between them anytime',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // Children List
              Expanded(
                child: ListView(
                  children: [
                    _buildChildTile('Ebele Okafor', 'Primary 4', context),
                    _buildChildTile('Chinedu Okafor', 'Primary 4', context),
                    _buildChildTile('Amaka Okafor', 'Primary 4', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: PrimaryButton(
          label: 'Continue',
          onPressed: ()=>context.go(AppRoutes.home),
          ),
      ),
    );
  }

  // Helper method to build the customized tile
  Widget _buildChildTile(String name, String grade, BuildContext context) {
    final isSelected = _selectedChildren.contains(name);
    final colorScheme = Theme.of(context).colorScheme;

    return SelectionTile(
      title: name,
      subtitle: grade,
      isSelected: isSelected,
      onTap: () => _toggleSelection(name),
      // Custom Prefix Icon setup
      prefixIcon: CircleAvatar(
        radius: 22,
        backgroundColor: colorScheme.primaryContainer, 
        child: Icon(Icons.domain, color: colorScheme.primary, size: 20), // Building icon
      ),
      // Custom Trailing Radio-style setup
      trailingIcon: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.primaryContainer,
            width: isSelected ? 6 : 4,
          ),
          color: isSelected ? colorScheme.onPrimary : colorScheme.primaryContainer,
        ),
      ),
    );
  }
}