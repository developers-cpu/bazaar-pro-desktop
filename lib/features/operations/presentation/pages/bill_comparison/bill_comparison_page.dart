import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
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
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedStartDate = '';
  String _selectedEndDate = '';
  @override
  void dispose() {
    _dateCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }
  void _onViewClicked() {
    if (_selectedStartDate.isNotEmpty && _selectedEndDate.isNotEmpty) {
      context.read<BillComparisonBloc>().add(
        LoadBillComparisonEvent(
          startDate: _selectedStartDate,
          endDate: _selectedEndDate,
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
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomInputField(
                    controller: _dateCtrl,
                    hintText: 'Select Date Range',
                    width: 250.w,
                    height: 35.h,
                    suffixIcon: Icons.calendar_today,
                    readOnly: true,
                  ),
                  Positioned.fill(
                    child: InkWell(
                      onTap: () async {
                        final picked = await CustomDateRangePickerDialog.show(
                          context,
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedStartDate = picked.start.toIso8601String();
                            _selectedEndDate = picked.end.toIso8601String();
                            _dateCtrl.text =
                                "${picked.start.toLocal().toString().split(' ')[0]} to ${picked.end.toLocal().toString().split(' ')[0]}";
                          });
                        }
                      },
                    ),
                  ),
                ],
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
                          width: 250.w,
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
