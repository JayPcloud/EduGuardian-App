import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/request_meeting_steps/date_time_selection_step.dart';
import '../widgets/request_meeting_steps/meeting_mode_step.dart';
import '../widgets/request_meeting_steps/review_confirm_step.dart';
import '../widgets/request_meeting_steps/teacher_selection_step.dart';

class RequestMeetingScreen extends StatefulWidget {
  const RequestMeetingScreen({super.key});

  @override
  State<RequestMeetingScreen> createState() => _RequestMeetingScreenState();
}

class _RequestMeetingScreenState extends State<RequestMeetingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.push(AppRoutes.meetingRequestedSuccess);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: _previousPage,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request meeting', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Step ${_currentIndex + 1} of $_totalPages', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
            child: Row(
              children: List.generate(
                _totalPages,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : Sizes.spaceS),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentIndex
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          TeacherSelectionStep(),
          MeetingModeStep(),
          DateTimeSelectionStep(),
          ReviewConfirmStep(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Row(
          children: [
            if (_currentIndex > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _previousPage,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius)),
                  ),
                  child: Text('Back', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
                ),
              ),
              const SizedBox(width: Sizes.spaceM),
            ],
            Expanded(
              flex: 2,
              child: PrimaryButton(label: 'Continue',onPressed: _nextPage,)
            ),
          ],
        ),
      ),
    );
  }
}