import 'package:edu_guardian_app/shared_features/auth/presentation/controllers/auth_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/containers/selection_tile.dart';
import '../../../../parents_features/dashboard/presentation/controllers/student_providers.dart';
import '../../data/models/user_model.dart';

class ChildSelectionScreen extends ConsumerStatefulWidget {
  const ChildSelectionScreen({super.key, this.user});

  final UserModel? user;
  
  @override
  ConsumerState<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends ConsumerState<ChildSelectionScreen> {
  final Set<String> _selectedChildrenIds = {}; 

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedChildrenIds.contains(id)) {
        _selectedChildrenIds.remove(id);
      } else {
        _selectedChildrenIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final wardsAsync = ref.watch(myWardsProvider); // Fetching live data

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
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: Sizes.spaceSm),
              Text(
                'Select all children linked to your account. You can switch between them anytime',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.outlineVariant, height: 1.4),
              ),
              const SizedBox(height: Sizes.spaceXXL),

              // 🚨 LIVE CHILDREN LIST
              Expanded(
                child: wardsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error loading children: $err')),
                  data: (wards) {
                    if (wards.isEmpty) {
                      return const Center(child: Text("No children linked to this account."));
                    }
                    return ListView.builder(
                      itemCount: wards.length,
                      itemBuilder: (context, index) {
                        final ward = wards[index];
                        final name = ward.fullName;
                        final id = ward.id.toString();
                        final grade = ward.classCategory; // Adjust JSON keys to your API
                        
                        return _buildChildTile(id, name, grade, context);
                      },
                    );
                  },
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
          // Only allow continue if they picked at least one child (Optional)
          onPressed: _selectedChildrenIds.isEmpty 
              ? null 
              : () {
                if(widget.user!=null){
                  ref.read(authStatusNotifierProvider.notifier).updateState(widget.user);
                }else{
                  ref.read(authStatusNotifierProvider.notifier).updateAuthStatusWithCache();
                }
              },
        ),
      ),
    );
  }

  Widget _buildChildTile(String id, String name, String grade, BuildContext context) {
    final isSelected = _selectedChildrenIds.contains(id);
    final colorScheme = Theme.of(context).colorScheme;

    return SelectionTile(
      title: name,
      subtitle: grade,
      isSelected: isSelected,
      onTap: () => _toggleSelection(id),
      prefixIcon: CircleAvatar(
        radius: 22,
        backgroundColor: colorScheme.primaryContainer, 
        child: Icon(Icons.person, color: colorScheme.primary, size: 20),
      ),
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