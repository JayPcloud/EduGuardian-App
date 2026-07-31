import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';

class DashboardTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final bool isFaded;

  const DashboardTimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.isDone,
    this.isActive = false,
    required this.isFirst,
    required this.isLast,
    this.isFaded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Made the dash colors slightly more faint (alpha 0.4 for active, 0.2 for inactive)
    final topDashColor = isDone || isActive 
        ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.4) 
        : theme.colorScheme.outline.withValues(alpha: 0.2);
        
    final bottomDashColor = isDone 
        ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.4) 
        : theme.colorScheme.outline.withValues(alpha: 0.2);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Expanded(child: isFirst ? const SizedBox() : _DashedLine(color: topDashColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    width: 24, 
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.surface,
                      border: Border.all(
                        color: isDone || isActive 
                            ? theme.colorScheme.onPrimaryContainer 
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1.5, // Slightly thinner outer ring
                      ),
                    ),
                    child: Center(
                      child: Container(
                        // Inner circle shrunk from 8 to 6
                        width: 6, 
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive 
                              ? theme.colorScheme.surface 
                              : (isDone ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.outline.withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: isLast ? const SizedBox() : _DashedLine(color: bottomDashColor)),
              ],
            ),
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Opacity(
              opacity: isFaded ? 0.5 : 1.0,
              child: Container(
                margin: const EdgeInsets.only(bottom: Sizes.spaceL),
                padding: const EdgeInsets.all(Sizes.paddingM),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border.all(color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(Sizes.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title, 
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700, 
                              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface
                            )
                          )
                        ),
                        Text(
                          time, 
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isActive ? AppColors.yellowAccent : theme.colorScheme.outlineVariant, 
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.spaceS),
                    Text(
                      subtitle, 
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant)
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Custom Dashed Line Widget
class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2 // Thinned down from 2.5 for that delicate look
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace = 5.0;
    double startY = 0;

    final centerX = size.width / 2;

    while (startY < size.height) {
      final endY = startY + dashHeight;
      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, endY > size.height ? size.height : endY),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}