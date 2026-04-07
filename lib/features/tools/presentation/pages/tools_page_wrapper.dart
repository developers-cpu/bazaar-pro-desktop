import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import 'tools_sub_pages.dart';
import 'rules_page.dart';
import 'market_timing_page.dart';

class ToolsPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  const ToolsPageWrapper({
    Key? key,
    required this.pageTitle,
    required this.child,
    this.onExportPdf,
    this.onExportExcel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userRole;
        if (state is AuthAuthenticated) {
          userRole = state.user.role;
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBarSection(
            selectedTabIndex: userRole == 'Client' ? 4 : 5,
            userRole: userRole,
            currentPageTitle: pageTitle,
            onTabSelected: (_) {},
            onExportPdf: onExportPdf,
            onExportExcel: onExportExcel,
            showExportByDefault: false,
          ),
          body: child,
        );
      },
    );
  }
}

class AboutPageWithAppBar extends StatelessWidget {
  const AboutPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(pageTitle: 'About', child: AboutPage());
  }
}

class ChangePasswordPageWithAppBar extends StatelessWidget {
  const ChangePasswordPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'Change Password',
      child: ChangePasswordPage(),
    );
  }
}

class MarketTimingPageWithAppBar extends StatelessWidget {
  const MarketTimingPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'Market Timing',
      child: MarketTimingPage(),
    );
  }
}

class MessagePageWithAppBar extends StatelessWidget {
  const MessagePageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(pageTitle: 'Message', child: MessagePage());
  }
}

class AnnouncementPageWithAppBar extends StatelessWidget {
  const AnnouncementPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'Announcement',
      child: AnnouncementPage(),
    );
  }
}

class RulesRegulationsPageWithAppBar extends StatelessWidget {
  const RulesRegulationsPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'Rules & Regulations',
      child: RulesPage(),
    );
  }
}

class ShortcutsPageWithAppBar extends StatelessWidget {
  const ShortcutsPageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'ShortCuts',
      child: ShortcutsPage(),
    );
  }
}

class ToolsTotalVolumePageWithAppBar extends StatelessWidget {
  const ToolsTotalVolumePageWithAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const ToolsPageWrapper(
      pageTitle: 'Total Volume',
      child: TotalVolumePage(),
    );
  }
}
