import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  final double width;
  final double height;

  Responsive(this.context)
    : width = MediaQuery.of(context).size.width,
      height = MediaQuery.of(context).size.height;

  // Percentage of screen width
  double w(double percent) => width * percent / 100;

  // Percentage of screen height
  double h(double percent) => height * percent / 100;

  // Responsive font size — scales relative to 375px base (iPhone 14)
  double sp(double size) => size * (width / 375).clamp(0.85, 1.3);

  // Responsive spacing
  double get xs => w(1.5); // ~4-6px
  double get sm => w(2.5); // ~8-10px
  double get md => w(4.5); // ~16-18px
  double get lg => w(6.5); // ~24px
  double get xl => w(8.5); // ~32px
  double get xxl => w(12.0); // ~44px

  // Device type helpers
  bool get isSmall => width < 360; // small Androids, SE
  bool get isMedium => width < 430; // most phones
  bool get isLarge => width >= 430; // Pro Max, tablets
}
