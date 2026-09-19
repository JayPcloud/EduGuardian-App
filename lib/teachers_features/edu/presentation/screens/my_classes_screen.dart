import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../controllers/my_classes_providers.dart';

class MyClassesScreen extends ConsumerWidget {
  const MyClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final classesAsync = ref.watch(teacherClassesProvider);
    
    // 🚨 Watch the new Flattened Provider
    final filteredFlattenedClasses = ref.watch(filteredFlattenedClassesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 80, 
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Classes', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)),
            Text(
              classesAsync.valueOrNull != null 
                  ? '${classesAsync.value!.counts.totalClasses} Classes · ${classesAsync.value!.counts.totalStudents} Students'
                  : 'Loading...', 
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)
            ),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.refresh(teacherClassesProvider.future),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
              child: TextFormField(
                onChanged: (value) => ref.read(teacherClassesSearchQueryProvider.notifier).state = value,
                decoration: InputDecoration(
                  hintText: 'Search classes or subjects',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                  prefixIcon: Icon(LucideIcons.search, size: 18, color: theme.colorScheme.onPrimaryContainer),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceM),

            // 🚨 NEW: Subject Filter Tabs
            _buildSubjectTabs(context, ref),
            
            const SizedBox(height: Sizes.spaceM),

            // Classes List
            Expanded(
              child: classesAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                  child: TeacherClassesShimmer(),
                ),
                error: (err, stack) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(teacherClassesProvider),
                ),
                data: (_) {
                  if (filteredFlattenedClasses.isEmpty) {
                    return const Center(child: Text("No classes found."));
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                    itemCount: filteredFlattenedClasses.length,
                    itemBuilder: (context, index) {
                      final item = filteredFlattenedClasses[index];
                      final parentClass = item.parentClass;
                      final arm = item.arm;

                      // Display the currently selected subject if filtering, or fallback to the first subject
                      final activeSubject = ref.watch(selectedSubjectProvider);
                      final displaySubject = activeSubject != null 
                          ? activeSubject.name 
                          : (parentClass.subjects.isNotEmpty ? parentClass.subjects.first.name : 'No Subject Assigned');

                      return GestureDetector(
                        onTap: () => context.push(AppRoutes.classManagement, extra: item,),
                        child: _buildClassCard(
                          theme: theme,
                          initials: parentClass.initials,
                          className: item.displayClassName,
                          subjectName: displaySubject,
                          totalStudents: arm.totalStudents.toString(), // Uses the arm's specific student count
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🚨 UI Builder for the Horizontal Subject Tabs
  Widget _buildSubjectTabs(BuildContext context, WidgetRef ref) {
    final uniqueSubjects = ref.watch(uniqueSubjectsProvider);
    final selectedSubject = ref.watch(selectedSubjectProvider);
    final theme = Theme.of(context);

    if (uniqueSubjects.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
        children: [
          // "All" Tab
          _buildTabChip(
            theme: theme,
            label: 'All',
            isSelected: selectedSubject == null,
            onTap: () => ref.read(selectedSubjectProvider.notifier).state = null,
          ),
          
          // Dynamic Subject Tabs
          ...uniqueSubjects.map((subject) {
            return _buildTabChip(
              theme: theme,
              label: subject.name,
              isSelected: selectedSubject?.id == subject.id,
              onTap: () => ref.read(selectedSubjectProvider.notifier).state = subject,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabChip({
    required ThemeData theme,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: Sizes.spaceS),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingXS),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required ThemeData theme,
    required String initials,
    required String className,
    required String subjectName,
    required String totalStudents,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE3F2FD), // Light blue
            child: Text(
              initials,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF004D99), // Deep blue
              ),
            ),
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(className, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                    Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.outlineVariant),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subjectName, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.users, size: 14, color: theme.colorScheme.outlineVariant),
                    const SizedBox(width: 4),
                    Flexible(child: Text('$totalStudents students', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Next: Today 10:30',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF004D99), // Deep blue
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TeacherClassesShimmer extends StatelessWidget {
  const TeacherClassesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          children: List.generate(4, (index) => Container(
            margin: const EdgeInsets.only(bottom: Sizes.spaceM),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.radiusXL),
            ),
          )),
        ),
      ),
    );
  }
}