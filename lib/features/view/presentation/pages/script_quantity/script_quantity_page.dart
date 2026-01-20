import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/script_quantity/script_quantity_bloc.dart';
import '../../bloc/script_quantity/script_quantity_event.dart';
import '../../bloc/script_quantity/script_quantity_state.dart';
import '../../widget/script_quantity/script_quantity_dialog.dart';
import '../../widget/script_quantity/script_quantity_filter_bar.dart';

/// Script Quantity Page
/// Shows only filter dropdowns by default
/// Opens dialog with data when filters are applied
class ScriptQuantityPage extends StatefulWidget {
  const ScriptQuantityPage({Key? key}) : super(key: key);

  @override
  State<ScriptQuantityPage> createState() => _ScriptQuantityPageState();
}

class _ScriptQuantityPageState extends State<ScriptQuantityPage> {
  @override
  void initState() {
    super.initState();
    // Load filter options on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScriptQuantityBloc>().add(const LoadFiltersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScriptQuantityBloc, ScriptQuantityState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            // Filter Bar
            const ScriptQuantityFilterBar(),

            // Divider
            Container(
              height: 1.h,
              color: AppColors.greyBorder,
            ),

            // Empty space (no table shown by default)
            Expanded(
              child: Center(
                child: Text(
                  'Select Exchange and Group, then click View to see script quantities',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, ScriptQuantityState state) {
    if (state is ScriptQuantityDataLoaded) {
      // Show dialog with loaded data
      ScriptQuantityDialog.show(
        context: context,
        quantities: state.quantities,
        exchange: state.exchange,
        group: state.group,
        totalRecords: state.totalRecords,
      );

      // After showing dialog, revert to filters loaded state
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<ScriptQuantityBloc>().add(const LoadFiltersEvent());
        }
      });
    }

    if (state is ScriptQuantityError) {
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