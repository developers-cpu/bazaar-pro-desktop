import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/deals/deals_bloc.dart';
import '../../bloc/deals/deals_event.dart';
import '../../bloc/deals/deals_state.dart';
import '../../widget/deals/deals_filter_bar.dart';
import '../../widget/deals/deals_table.dart';
class DealsPage extends StatefulWidget {
  const DealsPage({Key? key}) : super(key: key);
  @override
  State<DealsPage> createState() => _DealsPageState();
}
class _DealsPageState extends State<DealsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DealsBloc>().add(const LoadDealsEvent());
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<DealsBloc, DealsState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const DealsFilterBar(),
            Container(
              height: 1.h,
              color: AppColors.greyBorder,
            ),
            const Expanded(
              child: DealsTable(
                showDeviceInfo: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _handleStateChange(BuildContext context, DealsState state) {
    if (state is DealsExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is DealsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
