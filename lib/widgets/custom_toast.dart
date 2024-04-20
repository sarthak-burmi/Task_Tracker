import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';

void customToast(
  String message,
  Color bgColor, {
  required BuildContext context,
}) {
  showToastWidget(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: bgColor,
      ),
      child: Text(
        message,
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ), // Custom text style
      ),
    ),
    context: context,
    alignment: Alignment.bottomCenter,
    duration: const Duration(seconds: 2),
    position: StyledToastPosition.top,
    animDuration: const Duration(milliseconds: 500),
  );
}
