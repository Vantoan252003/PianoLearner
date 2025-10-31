import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Colors.black;
  static final Color primaryGrey900 = Colors.grey.shade900;
  static final Color primaryGrey800 = Colors.grey.shade800;
  static final Color primaryGrey700 = Colors.grey.shade700;
  static const Color primaryWhite = Colors.white;

  static LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black,
      Colors.grey.shade900,
      Colors.black,
    ],
  );

  static LinearGradient cardBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.grey.shade900,
      Colors.black,
    ],
  );

  // Feature Colors - Màu cho từng tính năng
  static final Color coursesBlue = Colors.blue.shade700;
  static final Color coursesBlueDark = Colors.blue.shade900;

  static final Color songsPurple = Colors.purple.shade700;
  static final Color songsPurpleDark = Colors.purple.shade900;

  static final Color tutorGreen = Colors.green.shade700;
  static final Color tutorGreenDark = Colors.green.shade900;

  static final Color practiceOrange = Colors.orange.shade700;
  static final Color practiceOrangeDark = Colors.orange.shade900;

  static final Color achievementGold = Colors.amber.shade400;
  static final Color achievementGoldLight = Colors.amber.shade200;

  // Status Colors
  static final Color successGreen = Colors.green.shade800;
  static final Color successGreenDark = Colors.green.shade900;

  static final Color errorRed = Colors.red.shade300;
  static final Color errorRedBackground = Colors.red.withOpacity(0.1);

  static final Color streakOrange = Colors.orange.shade400;

  // Course Card Gradients
  static List<List<Color>> courseGradients = [
    [Colors.indigo.shade700, Colors.indigo.shade900],
    [Colors.teal.shade700, Colors.teal.shade900],
    [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
    [Colors.cyan.shade700, Colors.cyan.shade900],
    [Colors.pink.shade700, Colors.pink.shade900],
  ];

  // Quick Action Gradients
  static LinearGradient courseActionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.blue.shade700, Colors.blue.shade900],
  );

  static LinearGradient songActionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.purple.shade700, Colors.purple.shade900],
  );

  static LinearGradient tutorActionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.green.shade700, Colors.green.shade900],
  );

  static LinearGradient practiceActionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.orange.shade700, Colors.orange.shade900],
  );

  // Achievement Card Gradient
  static LinearGradient achievementGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.amber.shade700.withOpacity(0.3),
      Colors.grey.shade800,
    ],
  );

  // Daily Goal Gradients
  static LinearGradient dailyGoalNormalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.grey.shade800, Colors.grey.shade900],
  );

  static LinearGradient dailyGoalCompletedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.green.shade800, Colors.green.shade900],
  );

  // Opacity helpers
  static Color whiteOpacity(double opacity) =>
      Colors.white.withOpacity(opacity);
  static Color blackOpacity(double opacity) =>
      Colors.black.withOpacity(opacity);

  // Common opacities used
  static Color white10 = Colors.white.withOpacity(0.1);
  static Color white20 = Colors.white.withOpacity(0.2);
  static Color white30 = Colors.white.withOpacity(0.3);
  static Color white50 = Colors.white.withOpacity(0.5);
  static Color white70 = Colors.white.withOpacity(0.7);
  static Color white80 = Colors.white.withOpacity(0.8);
  static Color white90 = Colors.white.withOpacity(0.9);

  // Shadows
  static BoxShadow cardShadow({Color? color, double? opacity}) => BoxShadow(
        color: (color ?? Colors.blue.shade700).withOpacity(opacity ?? 0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      );

  static BoxShadow actionButtonShadow(Color color) => BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      );
}

/// Text Styles
class AppTextStyles {
  // Headers
  static const TextStyle header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Body text
  static TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: Colors.white.withOpacity(0.8),
  );

  static TextStyle smallText = TextStyle(
    fontSize: 12,
    color: Colors.white.withOpacity(0.7),
  );

  static const TextStyle tinyText = TextStyle(
    fontSize: 10,
    color: Colors.white,
  );

  // Labels
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle stat = TextStyle(
    fontSize: 12,
    color: Colors.white.withOpacity(0.6),
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Special
  static TextStyle exp = TextStyle(
    fontSize: 12,
    color: Colors.amber.shade200,
    fontWeight: FontWeight.w600,
  );

  static TextStyle level = TextStyle(
    fontSize: 12,
    color: Colors.white.withOpacity(0.9),
    fontWeight: FontWeight.w600,
  );
}

/// Border Styles
class AppBorders {
  static Border cardBorder = Border.all(
    color: Colors.white.withOpacity(0.1),
    width: 1,
  );

  static Border accentBorder = Border.all(
    color: Colors.white.withOpacity(0.2),
    width: 1,
  );

  static Border achievementBorder = Border.all(
    color: Colors.amber.withOpacity(0.3),
    width: 1.5,
  );
}

/// Border Radius
class AppRadius {
  static BorderRadius small = BorderRadius.circular(10);
  static BorderRadius medium = BorderRadius.circular(16);
  static BorderRadius large = BorderRadius.circular(20);
  static BorderRadius round = BorderRadius.circular(12);
}

/// Spacing
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 30;
}

/// Icon Sizes
class AppIconSizes {
  static const double small = 16;
  static const double medium = 24;
  static const double large = 28;
  static const double xLarge = 32;
  static const double xxLarge = 48;
}
