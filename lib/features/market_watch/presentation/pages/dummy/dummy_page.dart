import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class DummyPage extends StatelessWidget {
  final String title;
  final String description;
  final Color accentColor;
  final IconData icon;
  const DummyPage({
    Key? key,
    required this.title,
    required this.description,
    this.accentColor = const Color(0xFF2563EB),
    this.icon = Icons.dashboard,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: accentColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 60.sp,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: accentColor, size: 24.sp),
                          SizedBox(width: 12.w),
                          Text(
                            'Page Information',
                            style: GoogleFonts.openSans(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoRow('Status', 'Active', accentColor),
                      _buildInfoRow('Type', 'Dummy Page', accentColor),
                      _buildInfoRow('Created', DateTime.now().toString().substring(0, 10), accentColor),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back, size: 20.sp),
                  label: Text(
                    'Go Back',
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
class PendingOrdersPage extends StatelessWidget {
  const PendingOrdersPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Pending Orders',
      description: 'View and manage all your pending_order orders in one place.',
      accentColor: Color(0xFF2563EB),
      icon: Icons.pending_actions,
    );
  }
}
class TradesPage extends StatelessWidget {
  const TradesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Trades',
      description: 'Monitor your trading activity and transaction history.',
      accentColor: Color(0xFF059669),
      icon: Icons.trending_up,
    );
  }
}
class DealsPage extends StatelessWidget {
  const DealsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Deals',
      description: 'Review completed deals and negotiations.',
      accentColor: Color(0xFFDC2626),
      icon: Icons.handshake,
    );
  }
}
class NetPositionPage extends StatelessWidget {
  const NetPositionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Net Position',
      description: 'Analyze your current net position and holdings.',
      accentColor: Color(0xFF7C3AED),
      icon: Icons.account_balance,
    );
  }
}
class RejectionLogPage extends StatelessWidget {
  const RejectionLogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Rejection Log',
      description: 'View rejected orders and understand the reasons.',
      accentColor: Color(0xFFEA580C),
      icon: Icons.cancel,
    );
  }
}
class LoginHistoryPage extends StatelessWidget {
  const LoginHistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Login History',
      description: 'Track your login activity and security events.',
      accentColor: Color(0xFF0891B2),
      icon: Icons.history,
    );
  }
}
class IntradayHistoryPage extends StatelessWidget {
  const IntradayHistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Intraday History',
      description: 'Review your intraday trading activities and patterns.',
      accentColor: Color(0xFF8B5CF6),
      icon: Icons.calendar_today,
    );
  }
}
class ScriptMasterPage extends StatelessWidget {
  const ScriptMasterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Script Master',
      description: 'Manage and configure trading scripts.',
      accentColor: Color(0xFF059669),
      icon: Icons.code,
    );
  }
}
class ScriptQuantityPage extends StatelessWidget {
  const ScriptQuantityPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Script Quantity',
      description: 'Set and adjust script quantity parameters.',
      accentColor: Color(0xFF2563EB),
      icon: Icons.format_list_numbered,
    );
  }
}
class BulkTradePage extends StatelessWidget {
  const BulkTradePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Bulk Trade',
      description: 'Execute multiple trades simultaneously.',
      accentColor: Color(0xFFDC2626),
      icon: Icons.dashboard_customize,
    );
  }
}
class TotalVolumePage extends StatelessWidget {
  const TotalVolumePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Total Volume',
      description: 'View comprehensive volume statistics.',
      accentColor: Color(0xFF7C3AED),
      icon: Icons.bar_chart,
    );
  }
}
class DeletedTradePage extends StatelessWidget {
  const DeletedTradePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Deleted Trade',
      description: 'Review deleted trades and transactions.',
      accentColor: Color(0xFFEA580C),
      icon: Icons.delete_forever,
    );
  }
}
class ManualTradePage extends StatelessWidget {
  const ManualTradePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Manual Trade',
      description: 'Enter and execute manual trades.',
      accentColor: Color(0xFF0891B2),
      icon: Icons.edit,
    );
  }
}
class CreateUserPage extends StatelessWidget {
  const CreateUserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Create User',
      description: 'Add new users to your system.',
      accentColor: Color(0xFF059669),
      icon: Icons.person_add,
    );
  }
}
class InactiveUserPage extends StatelessWidget {
  const InactiveUserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'In-Active User',
      description: 'Manage inactive user accounts.',
      accentColor: Color(0xFFEA580C),
      icon: Icons.person_off,
    );
  }
}
class SearchUserPage extends StatelessWidget {
  const SearchUserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Search User',
      description: 'Find and manage user accounts.',
      accentColor: Color(0xFF2563EB),
      icon: Icons.search,
    );
  }
}
class DailyReportPage extends StatelessWidget {
  const DailyReportPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Daily Report',
      description: 'View daily performance and activity reports.',
      accentColor: Color(0xFF2563EB),
      icon: Icons.today,
    );
  }
}
class WeeklyReportPage extends StatelessWidget {
  const WeeklyReportPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Weekly Report',
      description: 'Analyze weekly trends and performance.',
      accentColor: Color(0xFF059669),
      icon: Icons.calendar_view_week,
    );
  }
}
class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Monthly Report',
      description: 'Review monthly summaries and insights.',
      accentColor: Color(0xFF7C3AED),
      icon: Icons.calendar_month,
    );
  }
}
class CustomReportPage extends StatelessWidget {
  const CustomReportPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const DummyPage(
      title: 'Custom Report',
      description: 'Create custom reports with your criteria.',
      accentColor: Color(0xFFDC2626),
      icon: Icons.tune,
    );
  }
}
