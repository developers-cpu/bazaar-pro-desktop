import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RulesBloc>()..add(LoadRules()),
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              final newIndex = (_tabController.index + 1) % _tabController.length;
              _tabController.animateTo(newIndex);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              final newIndex =
                  (_tabController.index - 1 + _tabController.length) %
                  _tabController.length;
              _tabController.animateTo(newIndex);
            }
          }
        },
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
                indicatorWeight: 1.0,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: const Color(0xFF9E9E9E),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: AppColors.primaryBlue,
                    width: 1.5,
                  ),
                  insets: EdgeInsets.only(bottom: 2.h),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.symmetric(horizontal: 40.w),
                labelStyle: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Tab(height: 26.h, text: 'ENGLISH'),
                  Tab(height: 26.h, text: 'HINDI'),
                  Tab(height: 26.h, text: 'GUJARATI'),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<RulesBloc, RulesState>(
              builder: (context, state) {
                if (state is RulesLoading) {
                  return const SizedBox.shrink();
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
