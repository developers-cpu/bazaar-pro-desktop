import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TableTextStyleHelper {
  TableTextStyleHelper._();

  static FontWeight getFontWeight(String fontStyle) {
    switch (fontStyle.toLowerCase()) {
      case 'thin':
      case 'thin italic':
        return FontWeight.w100;
      case 'regular':
      case 'regular italic':
        return FontWeight.w400;
      case 'semibold':
      case 'semibold italic':
        return FontWeight.w600;
      case 'bold':
      case 'bold italic':
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  static bool isItalic(String fontStyle) {
    return fontStyle.toLowerCase().contains('italic');
  }
  static TextStyle getTextStyle({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    FontStyle? fontStyle,
  }) {
    final style = fontStyle ?? FontStyle.normal;

    switch (fontFamily.toLowerCase()) {
      case 'inter':
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'lato':
        return GoogleFonts.lato(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'montserrat':
        return GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'nunito sans':
        return GoogleFonts.nunitoSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'open sans':
        return GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'poppins':
        return GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'roboto':
        return GoogleFonts.roboto(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'gilroy':
        return GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'airal':
        return TextStyle(
          fontFamily: 'Arial',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      case 'monrope':
        return GoogleFonts.manrope(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
      default:
        return GoogleFonts.openSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: style,
        );
    }
  }
}