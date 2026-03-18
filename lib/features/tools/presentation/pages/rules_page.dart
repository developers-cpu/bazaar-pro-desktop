import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_tab_bar.dart';
import '../../../../../injection_container.dart';
import '../../domain/entities/rule_entity.dart';
import '../bloc/rules/rules_bloc.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});
  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  int _activeTab = 0;
  static const _tabs = ['ENGLISH', 'HINDI', 'GUJARATI'];
  static const _languages = ['en', 'hi', 'gu'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RulesBloc>()..add(LoadRules()),
      child: Column(
        children: [
          AppTabBar(
            tabs: _tabs,
            activeTab: _activeTab,
            onTabChanged: (i) => setState(() => _activeTab = i),
          ),
          Expanded(
            child: BlocBuilder<RulesBloc, RulesState>(
              builder: (context, state) {
                if (state is RulesLoading) {
                  return const SizedBox.shrink();
                } else if (state is RulesError) {
                  return Center(child: Text(state.message));
                } else if (state is RulesLoaded) {
                  return _buildRulesList(state.rules, _languages[_activeTab]);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesList(List<RuleEntity> allRules, String languageCode) {
    final rules = allRules.where((r) => r.language == languageCode).toList();
    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20.sp,
                color: const Color(0xFF536C7C),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  rule.rule,
                  style: GoogleFonts.openSans(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColors.primaryBlue,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
