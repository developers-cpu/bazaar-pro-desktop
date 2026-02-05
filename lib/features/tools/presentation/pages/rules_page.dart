import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../domain/entities/rule_entity.dart';
import '../bloc/rules/rules_bloc.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RulesBloc>()..add(LoadRules()),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                dividerColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: const Color(0xFF9E9E9E),
                indicatorColor: AppColors.primaryBlue,
                labelPadding: EdgeInsets.symmetric(horizontal: 24.w),
                labelStyle: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'ENGLISH'),
                  Tab(text: 'HINDI'),
                  Tab(text: 'GUJARATI'),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RulesBloc, RulesState>(
              builder: (context, state) {
                if (state is RulesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RulesError) {
                  return Center(child: Text(state.message));
                } else if (state is RulesLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRulesList(state.rules, 'en'),
                      _buildRulesList(state.rules, 'hi'),
                      _buildRulesList(state.rules, 'gu'),
                    ],
                  );
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
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18.sp,
                color: const Color(0xFF536C7C),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  rule.rule,
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF536C7C),
                    height: 1.5,
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
