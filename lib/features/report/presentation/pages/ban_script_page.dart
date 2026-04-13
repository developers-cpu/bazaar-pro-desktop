import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../injection_container.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../bloc/ban_script/ban_script_bloc.dart';
import '../bloc/ban_script/ban_script_event.dart';
import '../bloc/ban_script/ban_script_state.dart';
import '../widgets/ban_script/ban_script_filter_bar.dart';
import '../widgets/ban_script/ban_script_table.dart';
import 'report_page_wrapper.dart';

class BanScriptPageWithAppBar extends StatelessWidget {
  const BanScriptPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BanScriptBloc>()..add(const FetchBanScriptEvent(banType: 'exchange')),
      child: const ReportPageWrapper(
        pageTitle: 'Ban Script',
        child: _BanScriptPage(),
      ),
    );
  }
}

class _BanScriptPage extends StatefulWidget {
  const _BanScriptPage();

  @override
  State<_BanScriptPage> createState() => _BanScriptPageState();
}

class _BanScriptPageState extends State<_BanScriptPage> {
  int _activeTab = 0;
  final _tabs = const ['Ban by Exchange', 'Ban by Admin'];

  @override
  void initState() {
    super.initState();
  }

  void _onTabChanged(int index) {
    setState(() {
      _activeTab = index;
    });
    final banType = index == 0 ? 'exchange' : 'admin';
    context.read<BanScriptBloc>().add(FetchBanScriptEvent(banType: banType));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: AppTabBar(
            tabs: _tabs,
            activeTab: _activeTab,
            onTabChanged: _onTabChanged,
          ),
        ),
        BanScriptFilterBar(banType: _activeTab == 0 ? 'exchange' : 'admin'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<BanScriptBloc, BanScriptState>(
              builder: (context, state) {
                if (state is BanScriptLoading || state is BanScriptInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BanScriptError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.openSans(color: Colors.red),
                    ),
                  );
                } else if (state is BanScriptLoaded) {
                  return BanScriptTable(data: state.data);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}
