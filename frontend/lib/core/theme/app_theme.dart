import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {

  static ThemeData theme = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurple),
    textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );

}
