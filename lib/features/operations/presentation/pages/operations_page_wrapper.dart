import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../../../../injection_container.dart';
import '../bloc/date_settings/date_settings_bloc.dart';
import '../bloc/date_settings/date_settings_event.dart';
import '../bloc/script_settings/script_settings_bloc.dart';
import '../bloc/script_settings/script_settings_event.dart';
import '../bloc/surveillance/surveillance_bloc.dart';
import '../bloc/surveillance/surveillance_event.dart';
import '../bloc/message/operations_message_bloc.dart';
import '../bloc/server/server_bloc.dart';
import 'date_settings/date_settings_page.dart';
import 'message/operations_message_page.dart';
import 'script_settings/script_settings_page.dart';
import 'surveillance/surveillance_page.dart';
import 'server/server_page.dart';

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

class DateSettingsPageWithAppBar extends StatelessWidget {
  const DateSettingsPageWithAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DateSettingsBloc>()..add(LoadDateSettingsEvent()),
      child: Builder(
        builder: (context) {
          return const OperationsPageWrapper(
            pageTitle: 'Date Settings',
            child: DateSettingsPage(),
          );
        },
      ),
    );
  }
}

class ScriptSettingsPageWithAppBar extends StatelessWidget {
  const ScriptSettingsPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScriptSettingsBloc>()..add(LoadScriptSettingsEvent()),
      child: Builder(
        builder: (context) {
          return const OperationsPageWrapper(
            pageTitle: 'Script Settings',
            child: ScriptSettingsPage(),
          );
        },
      ),
    );
  }
}

class SurveillancePageWithAppBar extends StatelessWidget {
  const SurveillancePageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SurveillanceBloc>()..add(LoadSurveillanceDataEvent()),
      child: Builder(
        builder: (context) {
          return const OperationsPageWrapper(
            pageTitle: 'Surveillance',
            child: SurveillancePage(),
          );
        },
      ),
    );
  }
}

class OperationsMessagePageWithAppBar extends StatelessWidget {
  const OperationsMessagePageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OperationsMessageBloc>(),
      child: const OperationsMessagePageWrapper(),
    );
  }
}

class OperationsMessagePageWrapper extends StatelessWidget {
  const OperationsMessagePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const OperationsPageWrapper(
      pageTitle: 'Message',
      child: OperationsMessagePage(),
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
  const ServerPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServerBloc>(),
      child: const OperationsPageWrapper(
        pageTitle: 'Server',
        child: ServerPage(),
      ),
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
