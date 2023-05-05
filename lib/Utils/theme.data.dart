import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
      ).fontFamily,
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 30,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
      ).fontFamily,
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
