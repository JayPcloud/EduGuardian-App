import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/enums.dart';
import '../../../../shared_features/auth/presentation/controllers/role_provider.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/snackbar.dart';
import '../controllers/alerts_provider.dart';
import '../widgets/alerts_components.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(alertsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleAckAll() async {
    try {
      await ref.read(alertsProvider.notifier).markAllAsRead();
      if (mounted) AppSnackBar.success('All alerts marked as read', context: context);
    } catch (e) {
      if (mounted) AppSnackBar.error(e.toString(), context: context);
    }
  }

  // Helper to calculate "2 hrs ago", "Yesterday", etc.
  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return '${date.day}/${date.month}/${date.year}';
    if (diff.inDays >= 2) return '${diff.inDays} days ago';
    if (diff.inDays >= 1) return 'Yesterday';
    if (diff.inHours >= 1) return '${diff.inHours} hrs ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} min ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTeacher = ref.read(roleProvider) == UserRole.teacher;

    final alertsAsync = ref.watch(alertsProvider);
    final isFetchingMore = ref.read(alertsProvider.notifier).isFetchingMore;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: AppSpacingStyle.allBorderRdXl,
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alerts', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('School notifications', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Sizes.paddingL),
            child: Center(
              child: FilledButton(
                onPressed: alertsAsync.isLoading ? null : _handleAckAll, // Disable while loading
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimaryContainer, 
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
                ),
                child: Text('Ack all', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      body: alertsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          children: const [AlertsShimmer()],
        ),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(alertsProvider),
        ),
        data: (paginatedData) {
          final announcements = paginatedData.announcements;

          if (announcements.isEmpty) {
            return const Center(child: Text("You have no notifications."));
          }

          // 🚨 Split the data based on your UI's logic
          final recent = announcements.where((a) => !a.isRead).toList();
          final acknowledged = announcements.where((a) => a.isRead).toList();

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(Sizes.paddingL),
            children: [
              // --- RECENT SECTION ---
              if (recent.isNotEmpty) ...[
                AlertSectionHeader(icon: LucideIcons.bellRing, title: 'RECENT · ${recent.length}'),
                const SizedBox(height: Sizes.spaceM),
                ...recent.map((alert) => AlertCard(
                  title: alert.title,
                  time: _timeAgo(alert.createdAt),
                  body: alert.body,
                )),
                const SizedBox(height: Sizes.spaceL),
              ],

              // --- ACKNOWLEDGED SECTION ---
              if (acknowledged.isNotEmpty) ...[
                AlertSectionHeader(icon: LucideIcons.checkCircle, title: 'ACKNOWLEDGED · ${acknowledged.length}'),
                const SizedBox(height: Sizes.spaceM),
                ...acknowledged.map((alert) => AlertCard(
                  title: alert.title,
                  time: _timeAgo(alert.createdAt),
                  body: alert.body,
                )),
              ],

              if (isFetchingMore)
                const Padding(
                  padding: EdgeInsets.all(Sizes.paddingL),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:edu_guardian_app/core/constants/spacing_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../../core/constants/app_sizes.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
// import '../../../../core/enums/enums.dart';
// import '../../../../shared_features/auth/presentation/controllers/role_provider.dart';
// import '../widgets/alerts_components.dart';


// class AlertsScreen extends ConsumerWidget {
//   const AlertsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final isTeacher = ref.read(roleProvider)==UserRole.teacher;

//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           borderRadius: AppSpacingStyle.allBorderRdXl,
//           onTap: ()=>context.pop(),
//           child: const Icon(Icons.arrow_back_ios, size: 18)),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Alerts', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
//             Text('School notifications', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: Sizes.paddingL),
//             child: Center(
//               child: FilledButton(
//                 onPressed: () {
//                   // TODO: Handle acknowledge all
//                 },
//                 style: FilledButton.styleFrom(
//                   backgroundColor: theme.colorScheme.onPrimaryContainer, // Dark navy
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(0, 32),
//                   padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
//                 ),
//                 child: Text('Ack all', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(Sizes.paddingL),
//         children: isTeacher
//         ?[
//           const AlertSectionHeader(icon: LucideIcons.bellRing, title: 'RECENT · 2'),
//           const SizedBox(height: Sizes.spaceM),
          
//           const AlertCard(
//             title: 'Mr Bello (Chinedu\'s Parent)',
//             time: '2 hrs ago',
//             body: 'Thanks for the update. I will keep in touch...',
//           ),
//           const AlertCard(
//             title: 'Mr Kachi (Ebele\'s Parent)',
//             time: 'Yesterday',
//             body: 'My daughter scored 88% in the 2nd continuous assessment...',
//           ),
          
//           const SizedBox(height: Sizes.spaceL),
          
//           const AlertSectionHeader(icon: LucideIcons.checkCircle, title: 'ACKNOWLEDGED · 3'),
//           const SizedBox(height: Sizes.spaceM),
          
//           const AlertCard(
//             title: 'School closed tomorrow',
//             time: '10 min ago',
//             body: 'Due to a heavy rainfall warning across Lagos, all classes are suspended on Wednesday. Please keep your ward at home.',
//           ),
//           const AlertCard(
//             title: 'Attendance reminder',
//             time: '2 days ago',
//             body: 'You have not submitted assignment for today',
//           ),
//           const AlertCard(
//             title: 'NYSC medical outreach completed',
//             time: '1 week ago',
//             body: 'All JSS 1 students screened successfully by the corps members.',
//           ),

//           const SizedBox(height: Sizes.spaceL),
          
          
//         ]
//         :[
//           const AlertSectionHeader(icon: LucideIcons.bellRing, title: 'RECENT · 2'),
//           const SizedBox(height: Sizes.spaceM),
          
//           const AlertCard(
//             title: 'PTA Meeting · Saturday',
//             time: '2 hrs ago',
//             body: '2nd Term PTA meeting at 10:00 AM in the school hall. Uniform: Saturday wear.',
//           ),
//           const AlertCard(
//             title: 'Mathematics CA results published',
//             time: 'Yesterday',
//             body: 'Ebele scored 88% in the 2nd continuous assessment — full breakdown in Academics.',
//           ),
          
//           const SizedBox(height: Sizes.spaceL),
          
//           const AlertSectionHeader(icon: LucideIcons.checkCircle, title: 'ACKNOWLEDGED · 3'),
//           const SizedBox(height: Sizes.spaceM),
          
//           const AlertCard(
//             title: 'School closed tomorrow',
//             time: '10 min ago',
//             body: 'Due to a heavy rainfall warning across Lagos, all classes are suspended on Wednesday. Please keep your ward at home.',
//           ),
//           const AlertCard(
//             title: 'School fees reminder',
//             time: '2 days ago',
//             body: '2nd Term balance of ₦185,000 due by Friday. Pay via school portal or Zenith Bank.',
//           ),
//           const AlertCard(
//             title: 'NYSC medical outreach completed',
//             time: '1 week ago',
//             body: 'All JSS 1 students screened successfully by the corps members.',
//           ),
//         ],
//       ),
//     );
//   }
// }