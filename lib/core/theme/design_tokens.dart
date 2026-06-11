class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 9999;
}

class AppIconSize {
  AppIconSize._();

  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
}

class AppTapTarget {
  AppTapTarget._();

  /// Material 3 最小タップターゲット
  static const double min = 48;
}

class AppAnimation {
  AppAnimation._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
