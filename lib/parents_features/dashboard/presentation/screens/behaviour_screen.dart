import 'package:edu_guardian_app/core/widgets/common/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/app_error_widget.dart'; 
import '../controllers/behavior_providers.dart';
import '../../data/models/behaviour_model.dart';


class BehaviorScreen extends ConsumerStatefulWidget {
  const BehaviorScreen({super.key});

  @override
  ConsumerState<BehaviorScreen> createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends ConsumerState<BehaviorScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 🚨 Listen for scrolling to trigger pagination
    _scrollController.addListener(() {
      // If we are within 200 pixels of the bottom, load more!
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(wardBehaviorProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String hour = date.hour > 12 ? (date.hour - 12).toString().padLeft(2, '0') : date.hour.toString().padLeft(2, '0');
    if (hour == '00') hour = '12';
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $period'.toUpperCase();
  }

  Color _getStatusColor(String type) {
    if (type == 'merit') return const Color(0xFF009CA6); 
    if (type == 'discipline') return AppColors.redAccent; 
    return AppColors.neutralYellow; 
  }

  String _getStatusLabel(String type) {
    if (type == 'merit') return 'Positive';
    if (type == 'discipline') return 'Concerning';
    return 'Neutral';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final behaviorAsync = ref.watch(wardBehaviorProvider);
    final isFetchingMore = ref.read(wardBehaviorProvider.notifier).isFetchingMore;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Behavior', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Vertical timeline · last 7 days', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.invalidate(wardBehaviorProvider),
        child: SingleChildScrollView(
          controller: _scrollController, // 🚨 Attached the controller here!
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Column(
            children: [
              // Static Legend
              Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(
                  children: [
                    _buildStatusPill('Positive', const Color(0xFF009CA6), theme), 
                    const SizedBox(width: Sizes.spaceS),
                    _buildStatusPill('Neutral', AppColors.neutralYellow, theme), 
                    const SizedBox(width: Sizes.spaceS),
                    _buildStatusPill('Concerning', AppColors.redAccent, theme),
                  ],
                ),),
              ),
              const SizedBox(height: Sizes.spaceXL),
        
              // Dynamic Behavior Timeline
              behaviorAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const BehaviorShimmer(),
                error: (err, stack) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(wardBehaviorProvider),
                ),
                data: (paginatedData) {
                  final behaviors = paginatedData.behaviors;
        
                  if (behaviors.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: Sizes.spaceXXL),
                      child: Text("No behavior records found for the last 7 days."),
                    );
                  }
                  
                  return Column(
                    children: [
                      ...behaviors.asMap().entries.map((entry) {
                        int index = entry.key;
                        BehaviorModel item = entry.value;
                        bool isLast = index == behaviors.length - 1;
        
                        return _buildBehaviorItem(
                          theme,
                          time: _formatDate(item.date),
                          title: item.category,
                          desc: item.details,
                          teacher: item.teacher.name,
                          status: _getStatusLabel(item.type),
                          statusColor: _getStatusColor(item.type),
                          isLast: isLast && !isFetchingMore, // Keep the line going if loading more
                        );
                      }),
                      
                      // 🚨 Show a subtle spinner at the bottom if we are fetching the next page
                      if (isFetchingMore)
                        const Padding(
                          padding: EdgeInsets.all(Sizes.paddingL),
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(strokeWidth: 2.5)),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods (Untouched) ---

  Widget _buildStatusPill(String label, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: Sizes.paddingXS),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
      child: Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: Sizes.spaceXS),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBehaviorItem(ThemeData theme, {required String time, required String title, required String desc, required String teacher, required String status, required Color statusColor, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: statusColor.withValues(alpha: 0.2),
                child: Icon(Icons.check, color: statusColor, size: Sizes.iconXS),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: theme.colorScheme.outline.withValues(alpha: 0.3))),
            ],
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: Sizes.spaceL),
              padding: const EdgeInsets.all(Sizes.paddingM),
              decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(Sizes.radiusM)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 2),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
                        child: Text(status, style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceS),
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: Sizes.spaceXS),
                  Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: Sizes.spaceM),
                  Text(teacher, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class BehaviorShimmer extends StatelessWidget {
  const BehaviorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) => Padding(
          padding: const EdgeInsets.only(bottom: Sizes.spaceL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line and dot skeleton
              Column(
                children: [
                  Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  const SizedBox(height: Sizes.spaceS),
                  Container(width: 2, height: 80, color: Colors.white),
                ],
              ),
              const SizedBox(width: Sizes.spaceM),
              // Card skeleton
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusM)),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}