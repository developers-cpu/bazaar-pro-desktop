import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);
  static const Color _primaryColor = Color(0xFF1F4A66);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 80,
            color: _primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Report',
            style: GoogleFonts.openSans(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Reports and analytics will be displayed here',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: _primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
