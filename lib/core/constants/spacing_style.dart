import 'package:flutter/material.dart';

import 'app_sizes.dart';

class AppSpacingStyle {
  AppSpacingStyle._();

  static const pagePadding = EdgeInsets.all(Sizes.paddingM);

  static const sectionPadding = EdgeInsets.symmetric(
    vertical: Sizes.paddingXL,
    horizontal: Sizes.paddingM,
  );

  static const buttonStylePadding = EdgeInsets.symmetric(
    vertical: Sizes.paddingM,
    horizontal: Sizes.spaceS,
  );

  static const itemPadding = EdgeInsets.all(Sizes.spaceS);

  static const defaultPadding = EdgeInsets.symmetric(
    vertical: Sizes.paddingM,
    horizontal: Sizes.paddingM,
  );

  static const horizontalPadding = EdgeInsets.symmetric(
    horizontal: Sizes.paddingM,
  );

  static const verticalPadding = EdgeInsets.symmetric(
    vertical: Sizes.paddingM,
  );

  /// Standard horizontal screen gutter used across the onboarding flow.
  static const screenPadding = EdgeInsets.symmetric(
    horizontal: Sizes.screenPaddingHorizontal,
    vertical: Sizes.screenPaddingVertical,
  );

  // Border Radius
  static BorderRadius allBorderRdSm = BorderRadius.circular(Sizes.radiusS);
  static BorderRadius allBorderRdMd = BorderRadius.circular(Sizes.radiusM);
  static BorderRadius allBorderRdL = BorderRadius.circular(Sizes.radiusL);
  static BorderRadius allBorderRdXl = BorderRadius.circular(Sizes.radiusXL);
}