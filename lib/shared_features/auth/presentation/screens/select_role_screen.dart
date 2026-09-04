import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/containers/selection_tile.dart';
import '../controllers/role_provider.dart';
import '../widgets/auth_header.dart';


class SelectRoleScreen extends ConsumerWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedRole = ref.watch(roleProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.paddingL).copyWith(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Sizes.spaceM),
                      const AuthHeader(),
                      const SizedBox(height: Sizes.spaceXXXL),
                      
                      Text(
                        'Select Role',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary, // Matches the deep blue from the design
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceXS),
                      Text(
                        'Pick your role to continue, We\'ll remember\nit next time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outlineVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceXXL),

                      // Parent Tile
                      SelectionTile(
                        title: 'Parent',
                        subtitle: 'Track your child\'s grades, behaviour and activities',
                        isSelected: selectedRole == UserRole.parent,
                        onTap: () => ref.read(roleProvider.notifier).setRole(UserRole.parent),
                        prefixIcon: _buildPrefixIcon(LucideIcons.shieldUser, theme),
                        trailingIcon: _buildRadioIcon(selectedRole == UserRole.parent, theme),
                      ),

                      // Student Tile
                      SelectionTile(
                        title: 'Student',
                        subtitle: 'View assignments, attendance and your achievements',
                        isSelected: selectedRole == UserRole.student,
                        onTap: () => ref.read(roleProvider.notifier).setRole(UserRole.student),
                        prefixIcon: _buildPrefixIcon(LucideIcons.graduationCap, theme),
                        trailingIcon: _buildRadioIcon(selectedRole == UserRole.student, theme),
                      ),
                      // Teacher Tile
                      SelectionTile(
                        title: 'Teacher',
                        subtitle: 'Manage your classes attendance and reports',
                        isSelected: selectedRole == UserRole.teacher,
                        onTap: () => ref.read(roleProvider.notifier).setRole(UserRole.teacher),
                        prefixIcon: _buildPrefixIcon(LucideIcons.fileEdit, theme),
                        trailingIcon: _buildRadioIcon(selectedRole == UserRole.teacher, theme),
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned Continue Button
              const SizedBox(height: Sizes.spaceM),
              PrimaryButton(
                label: 'Continue',
                onPressed: selectedRole != null 
                    ? ()=> context.go(AppRoutes.login)
                    : null, // Disables the button if no role is selected
              ),
              const SizedBox(height: Sizes.spaceM),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable helper for the circular blue prefix icons
  Widget _buildPrefixIcon(IconData icon, ThemeData theme) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      child: Icon(
        icon,
        color: theme.colorScheme.primary,
        size: 22,
      ),
    );
  }

  // Reusable helper for the radio button indicators
  Widget _buildRadioIcon(bool isSelected, ThemeData theme) {
    return Icon(
      Icons.radio_button_checked,
      // The design uses a faded version of the active radio icon for the unselected state
      color: isSelected 
          ? theme.colorScheme.primary 
          : theme.colorScheme.primary.withValues(alpha: 0.3),
      size: 24,
    );
  }
}