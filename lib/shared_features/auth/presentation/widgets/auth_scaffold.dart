import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.titleHeader, required this.subtitle, required this.children});
  final String titleHeader;
  final String subtitle;
  final List<Widget> children;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        // --- GRADIENT BACKGROUND ---
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(2),
            colors: [AppColors.accentBlue, AppColors.primaryDark,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // --- TOP HEADER SECTION ---
            SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  // Faded Background Watermark SVG Logo
                  Positioned(
                    right: -20,
                    top: 20,
                    child: SvgPicture.asset(
                      AppAssets.appLogoSvg,
                      height: 240,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withValues(alpha: 0.05),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.paddingL,
                      vertical: Sizes.spaceXXL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Logo & Brand Name
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.appLogoSvg,
                              height: 28,
                            ),
                            const SizedBox(width: Sizes.spaceS),
                            Text(
                              'EduGuardian',
                              style: textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.spaceXXL),
                        
                        // Welcome Text
                        Text(
                          titleHeader,
                          style: textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceS),
                        Text(
                          subtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceL),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- BOTTOM WHITE FORM SECTION ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.radiusXXL), // Curves the top edges
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.radiusXXL),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Sizes.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Sizes.spaceM),
                        ...children
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}