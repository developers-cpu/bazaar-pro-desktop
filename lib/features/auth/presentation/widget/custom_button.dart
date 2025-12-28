import 'package:flutter/material.dart';

/// Custom Button Widget

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color disabledBackgroundColor;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFF1F4A66),
    this.textColor = Colors.white,
    this.borderColor = const Color(0xFF1F4A66),
    this.disabledBackgroundColor = const Color(0xFFBDBDBD),
    this.width = 500,
    this.height = 45,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: 1),
          ),
          elevation: 0,
          padding: const EdgeInsets.all(10),
        ),
        child: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: textColor,
            strokeWidth: 2,
          ),
        )
            : Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}