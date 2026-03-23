import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/date_range_picker_button.dart';
import '../../bloc/bill_comparison/bill_comparison_bloc.dart';
import '../../bloc/bill_comparison/bill_comparison_event.dart';
import '../../bloc/bill_comparison/bill_comparison_state.dart';
import '../../widgets/bill_comparison/bill_comparison_data_table.dart';

class BillComparisonPage extends StatefulWidget {
  const BillComparisonPage({super.key});
  @override
  State<BillComparisonPage> createState() => _BillComparisonPageState();
}

class _BillComparisonPageState extends State<BillComparisonPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  DateTimeRange? _selectedDateRange;
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onViewClicked() {
    if (_selectedDateRange != null) {
      context.read<BillComparisonBloc>().add(
        LoadBillComparisonEvent(
          startDate: _selectedDateRange!.start.toIso8601String(),
          endDate: _selectedDateRange!.end.toIso8601String(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateRangePickerButton(
                width: 190.w,
                height: 35.h,
                selectedDateRange: _selectedDateRange,
                onTap: () {},
                onDateRangeSelected: (range) {
                  setState(() {
                    _selectedDateRange = range;
                  });
                },
              ),
              CustomActionButton(
                text: 'View',
                onPressed: _onViewClicked,
                width: 120.w,
                height: 38.h,
                borderRadius: 6.r,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: BlocBuilder<BillComparisonBloc, BillComparisonState>(
              builder: (context, state) {
                if (!state.hasLoadedInitialData && !state.isLoading) {
                  return const SizedBox();
                }
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomInputField(
                          controller: _searchCtrl,
                          hintText: 'Search',
                          width: 190.w,
                          height: 35.h,
                          prefixSvgPath: AppImages.searchIcon,
                          onChanged: (val) {
                            context.read<BillComparisonBloc>().add(
                              SearchBillComparisonEvent(val),
                            );
                          },
                        ),
                        Text(
                          'RECORD : ${state.filteredData.length}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: BillComparisonDataTable(data: state.filteredData),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
