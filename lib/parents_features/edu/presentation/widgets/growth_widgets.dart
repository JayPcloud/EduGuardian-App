import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class ActivityCard extends StatelessWidget {
  final String iconEmoji;
  final String title;
  final String subtitle;
  final String tag1;
  final String tag2;

  const ActivityCard({
    super.key, required this.iconEmoji, required this.title,
    required this.subtitle, required this.tag1, required this.tag2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(iconEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: Sizes.spaceS),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 11)),
          const SizedBox(height: Sizes.spaceM),
          _buildTag(tag1, const Color(0xFFFFB300), theme)
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color, ThemeData theme) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Sizes.radiusCircular),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, size: 5, color:const Color(0xFFE65100)),
            Text(' MVP',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
            SizedBox(width: Sizes.spaceXS,),
            Icon(Icons.circle, size: 5, color:const Color(0xFFE65100)),
            Text(tag2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer,)),
          ],
        ),
      ),
    );
  }
}

class DevelopmentalRadarCard extends StatelessWidget {
  const DevelopmentalRadarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('Developmental radar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer))),
              Text('1–5 scale', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: Sizes.spaceXXL),
          SizedBox(
            height: 200, // Increased slightly to give the labels room to breathe
            width: double.infinity,
            child: CustomPaint(
              painter: _RadarChartPainter(
                primaryColor: theme.colorScheme.primary,
                outlineColor: theme.colorScheme.outlineVariant,
                textTheme: theme.textTheme,
              )
            ),
          ),
          const SizedBox(height: Sizes.spaceXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreBottom('🧠', '4.5', theme),
              _buildScoreBottom('👑', '4.2', theme),
              _buildScoreBottom('💛', '3.8', theme),
              _buildScoreBottom('🎨', '4.7', theme),
              _buildScoreBottom('🌟', '4', theme),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScoreBottom(String icon, String score, ThemeData theme) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(score, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// --- RADAR CHART PAINTER ---
class _RadarChartPainter extends CustomPainter {
  final Color primaryColor;
  final Color outlineColor;
  final TextTheme textTheme;

  _RadarChartPainter({
    required this.primaryColor, 
    required this.outlineColor,
    required this.textTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Subtracting 30 from the radius so the labels don't clip off the edges of the canvas
    final radius = (math.min(size.width, size.height) / 2) - 30; 
    
    final paintGrid = Paint()
      ..color = outlineColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke;
    
    // 1. Draw 3 concentric pentagons & Spokes
    for (int step = 1; step <= 4; step++) {
      final r = radius * (step / 3);
      final path = Path();
      for (int i = 0; i < 5; i++) {
        final angle = (i * 2 * math.pi / 5) - math.pi / 2;
        final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
        
        // Draw the spokes from the center to the outer edge
        if (step == 4) { 
          canvas.drawLine(center, point, paintGrid);
        }
      }
      path.close();
      canvas.drawPath(path, paintGrid);
    }

    // 2. Draw data polygon
    final dataScores = [0.9, 0.84, 0.76, 0.94, 0.8]; // Relative 1-5 scale matching the scores below
    final dataPath = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      final r = radius * dataScores[i];
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    // Fill with a yellowish/blueish translucency 
    canvas.drawPath(dataPath, Paint()..color = const Color(0xFFDCE775).withValues(alpha: 0.5)..style = PaintingStyle.fill);
    // Border for the data
    canvas.drawPath(dataPath, Paint()..color = primaryColor..strokeWidth = 2..style = PaintingStyle.stroke);

    // 3. Draw Labels
    final labels = ['Critical Thinking', 'Teamwork', 'Emotional IQ', 'Creativity', 'Leadership'];
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      
      // Push the text outside the new 4th pentagon (which sits at radius * 4/3)
      final labelRadius = (radius * (4 / 3)) + 20; 
      
      final point = Offset(center.dx + labelRadius * math.cos(angle), center.dy + labelRadius * math.sin(angle));

      final span = TextSpan(
        style: textTheme.labelSmall?.copyWith(fontSize: 9, color: outlineColor, fontWeight: FontWeight.w600), 
        text: labels[i]
      );
      final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      
      // Center the text exactly on the calculated point
      tp.paint(canvas, Offset(point.dx - (tp.width / 2), point.dy - (tp.height / 2)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- PARENT FEEDBACK CARD ---
class ParentFeedbackCard extends StatelessWidget {
  const ParentFeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Parent feedback', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onPrimaryContainer)),
          const SizedBox(height: 4),
          Text('Share observations from home.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          const SizedBox(height: Sizes.spaceM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  maxLines: 2, // Makes the field tall enough to look like the design
                  minLines: 2,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'e.g. Ebele has been practicing\nchess every evening...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7), 
                      fontStyle: FontStyle.italic
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
                   
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.radiusL),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    
                  ),
                ),
              ),
              const SizedBox(width: Sizes.spaceS),
              // The Send Button
              InkWell(
                onTap: () {
                  
                },
                borderRadius: BorderRadius.circular(50),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFB0C4DE), // Hardcoded matching light steel blue from the design
                  child: Icon(Icons.send_rounded, color: Colors.white, size: Sizes.iconS),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}