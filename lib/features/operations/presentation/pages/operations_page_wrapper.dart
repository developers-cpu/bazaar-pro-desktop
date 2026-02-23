import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';

class OperationsPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;

  const OperationsPageWrapper({
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
          backgroundColor: AppColors.white,
          appBar: AppBarSection(
            selectedTabIndex: 6,
            userRole: userRole,
            currentPageTitle: pageTitle,
            onTabSelected: (_) {},
            onExportPdf: onExportPdf,
            onExportExcel: onExportExcel,
            showExportByDefault: true,
          ),
          body: child,
        );
      },
    );
  }
}

class ExchangeSettingsPageWithAppBar extends StatelessWidget {
  const ExchangeSettingsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Exchange Settings',
      child: Center(child: Text('Exchange Settings Page - Coming Soon')),
    );
  }
}

class TradeSettingsPageWithAppBar extends StatelessWidget {
  const TradeSettingsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Trade Settings',
      child: Center(child: Text('Trade Settings Page - Coming Soon')),
    );
  }
}

class DateSettingsPageWithAppBar extends StatelessWidget {
  const DateSettingsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Date Settings',
      child: Center(child: Text('Date Settings Page - Coming Soon')),
    );
  }
}

class ScriptSettingsPageWithAppBar extends StatelessWidget {
  const ScriptSettingsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Script Settings',
      child: Center(child: Text('Script Settings Page - Coming Soon')),
    );
  }
}

class SurveillancePageWithAppBar extends StatelessWidget {
  const SurveillancePageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Surveillance',
      child: Center(child: Text('Surveillance Page - Coming Soon')),
    );
  }
}

class SettlementProgressPageWithAppBar extends StatelessWidget {
  const SettlementProgressPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Settlement Progress',
      child: Center(child: Text('Settlement Progress Page - Coming Soon')),
    );
  }
}

class ServerPageWithAppBar extends StatelessWidget {
  const ServerPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Server',
      child: Center(child: Text('Server Page - Coming Soon')),
    );
  }
}

class BillComparisonPageWithAppBar extends StatelessWidget {
  const BillComparisonPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Bill Comparison',
      child: Center(child: Text('Bill Comparison Page - Coming Soon')),
    );
  }
}

class InactivityManagementPageWithAppBar extends StatelessWidget {
  const InactivityManagementPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Inactivity Management',
      child: Center(child: Text('Inactivity Management Page - Coming Soon')),
    );
  }
}
