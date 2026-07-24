import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/inputs/labeled_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                          'Welcome back',
                          style: textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceS),
                        Text(
                          'Access your child\'s attendance logs, behaviour,\ngrowth and academic report.',
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
                        
                        // Email Field
                        LabeledTextField(
                          label: 'Email',
                          hintText: 'you@example.com ',
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: Sizes.spaceL),
                        LabeledTextField(
                          label: 'Password',
                          hintText: '********',
                          prefixIcon: LucideIcons.keyRound,
                        ),
                        // Password Field
                        const SizedBox(height: Sizes.spaceM),

                        // Checkbox & Forgot Password Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(() => _rememberMe = val ?? false);
                                    },
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Sizes.spaceS),
                                GestureDetector(
                                  onTap: (){
                                      setState(() => _rememberMe = !_rememberMe);
                                    },
                                  child: Text(
                                    'Remember me',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => context.push(AppRoutes.login),
                              child: Text(
                                'Forgot password ?',
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.spaceXXXL),

                        // Custom Primary Button
                        PrimaryButton(
                          label: 'Sign in',
                          onPressed: ()=> context.go(AppRoutes.home),
                        ),
                        const SizedBox(height: Sizes.spaceXXL),

                        // Sign up text
                        Center(
                          child: GestureDetector(
                            onTap: ()=> context.push(AppRoutes.signup),
                            child: RichText(
                              text: TextSpan(
                                text: 'Dont have an account? ',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.outlineVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceL),
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

  // Extracted Label Builder
  Widget _buildLabel(String text, TextTheme textTheme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceXS),
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Extracted TextField Builder
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return TextField(
      obscureText: isPassword,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.outlineVariant,
        ),
        prefixIcon: Icon(icon, color: colorScheme.outlineVariant, size: 20),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.paddingM,
          vertical: Sizes.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}