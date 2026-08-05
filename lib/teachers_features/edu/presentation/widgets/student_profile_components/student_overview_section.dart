import 'dart:math' as math;
import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../../core/constants/app_sizes.dart';

// ==========================================
// TAB 1: OVERVIEW SECTION
// ==========================================
class StudentOverviewSection extends StatelessWidget {
  const StudentOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent Contact
        Text('Parent Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: Sizes.spaceM),
        Container(
          padding: const EdgeInsets.all(Sizes.paddingL),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: AppDecorations.defaultShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Parent Avatar
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Francisca Obu', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700,), maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text('EDU/JSS3A/001', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('78%', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                      Text('Excellent', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.outlineVariant),
                ],
              ),
              const SizedBox(height: Sizes.spaceL),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.radiusXXL),
                        gradient: AppDecorations.primaryGradient(context),
                      ),
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.messageCircle, size: 16),
                        label: const Text('Message', maxLines: 1, overflow: TextOverflow.ellipsis),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.phone, size: 16),
                      label: const Text('Call', maxLines: 1, overflow: TextOverflow.ellipsis),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(color: theme.colorScheme.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),

        // Attendance Overview (Header moved INSIDE the container)
        Container(
          padding: const EdgeInsets.all(Sizes.paddingXL),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: AppDecorations.defaultShadow,
          ),
          child: Column(
            children: [
              // Header is perfectly aligned inside the card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text('Attendance Overview', maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                  Row(
                    children: [
                      Text('This Term', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.outlineVariant),
                    ],
                  )
                ],
              ),
              const SizedBox(height: Sizes.spaceXL),
              Row(
                children: [
                  // Custom Segmented Donut Chart
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: _SegmentedDonutChartPainter(
                              values: [23, 1, 1, 1], // Present, Absent, Late, Excused
                              colors: [
                                const Color(0xFF004D99), // Present
                                const Color(0xFFF44336), // Absent
                                const Color(0xFF2196F3), // Late (Light Blue)
                                const Color(0xFFFFB300), // Excused (Yellow)
                              ],
                            ),
                          ),
                        ),
                        Text('23', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF004D99))),
                      ],
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceL), // Swapped XXL for L to prevent overflow on small screens
                  // Legend wrapped in FittedBox for deep responsiveness
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendRow('Present', '23', const Color(0xFF004D99), theme),
                          const SizedBox(height: 8),
                          _buildLegendRow('Absent', '1', const Color(0xFFF44336), theme),
                          const SizedBox(height: 8),
                          _buildLegendRow('Late', '1', const Color(0xFF2196F3), theme),
                          const SizedBox(height: 8),
                          _buildLegendRow('Excused', '1', const Color(0xFFFFB300), theme),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.spaceXL),

        // Academic Overview
        Text('Academic Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: Sizes.spaceM),
        Row(
          children: [
            Expanded(child: _buildAcademicCard('Average Score', '84%', 'Good', const Color(0xFF2196F3), theme)),
            const SizedBox(width: Sizes.spaceS),
            Expanded(child: _buildAcademicCard('Class Rank', '5', 'out of 32', const Color(0xFF8E24AA), theme)),
            const SizedBox(width: Sizes.spaceS),
            Expanded(child: _buildAcademicCard('Grade', 'A', 'Excellent', const Color(0xFF2196F3), theme)),
          ],
        ),
        const SizedBox(height: Sizes.spaceXL),
      ],
    );
  }

  Widget _buildLegendRow(String label, String value, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            SizedBox(
              width: 60, // Fixed width ensures the numbers align perfectly in a column
              child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
            ),
          ],
        ),
        Text(value, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildAcademicCard(String title, String mainValue, String subValue, Color color, ThemeData theme) {
    return Container(
      height: 160, // Fixed height to keep them uniform
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Sizes.radiusL),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: AppDecorations.defaultShadow,
      ),
      child: Stack(
        children: [
          // Sharp Zigzag Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Sizes.radiusL)),
              child: SizedBox(
                height: 45,
                child: CustomPaint(
                  painter: _ZigzagPainter(color: color),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(Sizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600,), textAlign: TextAlign.center, maxLines: 1),
                const Spacer(),
                // FittedBox prevents the large 84% from overflowing on narrow screens like iPhone SE
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(mainValue, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
                ),
                const SizedBox(height: 2),
                Text(subValue, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant,), maxLines: 1),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CUSTOM PAINTERS
// ==========================================

class _SegmentedDonutChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _SegmentedDonutChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0; 
    final double radius = (size.width - strokeWidth) / 2;
    
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - strokeWidth,
      height: size.height - strokeWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double total = values.fold(0, (a, b) => a + b);
    
    // StrokeCap.round adds length equal to half the strokeWidth to BOTH ends of the arc.
    // We mathematically convert that physical pixel length into its angle equivalent (radians)
    // so we can force a true visible gap.
    final double capAngle = (strokeWidth / 2) / radius;
    
    // Total gap = the overlap from the 2 rounded caps + the actual empty space you want to see (0.15)
    final double gap = (capAngle * 2) + 0.15; 
    
    // Starting angle (Top right, matching screenshot)
    double startAngle = -math.pi * 0.25; 

    // Calculate total available angle by subtracting the required gaps
    int activeSegments = values.where((v) => v > 0).length;
    double totalAvailableAngle = (2 * math.pi) - (activeSegments * gap);

    for (int i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;

      final double sweepAngle = (values[i] / total) * totalAvailableAngle;
      
      paint.color = colors[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      
      // Move starting angle forward by the size of the arc + the dynamically calculated gap
      startAngle += sweepAngle + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ZigzagPainter extends CustomPainter {
  final Color color;

  _ZigzagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round; 

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Your EXACT shape, just shifted UP uniformly by 0.3 to leave the gap at the bottom
    path.moveTo(0, size.height * 0.45);
    path.lineTo(size.width * 0.2, size.height * 0.60);
    path.lineTo(size.width * 0.5, size.height * 0.25);
    path.lineTo(size.width * 0.8, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.35);

    // Draw the sharp line on top
    canvas.drawPath(path, strokePaint);

    // Close the path to fill the area underneath with the gradient
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}