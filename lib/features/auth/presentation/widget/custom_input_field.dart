import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String? svgIconPath;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.svgIconPath,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.validator,
  }) : super(key: key);

  static const Color primaryTextColor = Color(0xFF1F4A66);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 48,
        maxWidth: 500,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,

        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.15,
          color: primaryTextColor,
        ),

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0.15,
            color: primaryTextColor,
          ),

          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),

          errorStyle: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
            color: primaryTextColor,
          ),

          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
          errorBorder: _border(),
          focusedErrorBorder: _border(),

          suffixIcon: suffixIcon != null
              ? IconButton(
            icon: Icon(
              suffixIcon,
              size: 24,
              color: primaryTextColor,
            ),
            onPressed: onSuffixIconPressed,
          )
              : (svgIconPath != null
              ? Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              svgIconPath!,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          )
              : null),
        ),

        validator: validator,
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: primaryTextColor,
        width: 2,
      ),
    );
  }
}
