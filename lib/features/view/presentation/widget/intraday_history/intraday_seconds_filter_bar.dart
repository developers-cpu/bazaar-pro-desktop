import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/single_date_picker_dialog.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import '../common/view_reset_buttons.dart';

class IntradaySecondsFilterBar extends StatefulWidget {
  const IntradaySecondsFilterBar({Key? key}) : super(key: key);

  @override
  State<IntradaySecondsFilterBar> createState() =>
      _IntradaySecondsFilterBarState();
}

class _IntradaySecondsFilterBarState extends State<IntradaySecondsFilterBar> {
  
  String? _selectedExchange;
  String? _selectedSymbol;
  DateTime? _startTime;
  DateTime? _endTime;

  final List<String> _exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'GIFT',
    'FOREX'
  ];

  final List<String> _symbols = [
    'SGX GIFTNIFTY Oct 28',
    'NSE NIFTY Oct 28',
    'NSE BANKNIFTY Oct 28',
    'MINI GOLDMINI Dec 05',
    'MINI SILVERMINI Dec 05',
    'OTHER DOW Dec 19',
    'OTHER NASDAQ Dec 19',
    'OTHER S & P Dec 19',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntradayHistoryBloc, IntradayHistoryState>(
      builder: (context, state) {
        if (state is! IntradayHistorySecondsView) {
          return const SizedBox.shrink();
        }

        
        _selectedExchange ??= state.exchange.isNotEmpty ? state.exchange : null;
        _selectedSymbol ??= state.symbol.isNotEmpty ? state.symbol : null;
        _startTime ??= state.startTime;
        _endTime ??= state.endTime;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              
              Row(
                children: [
                  _buildBackButton(context),
                ],
              ),
              SizedBox(height: 12.h),

              
              Row(
                children: [
                  
                  Expanded(
                    child: _buildDatePicker(context, state),
                  ),
                  SizedBox(width: 12.w),

                  
                  Expanded(
                    child: AppDropdown(
                      type: AppDropdownType.simple,
                      hintText: 'Exchange',
                      value: _selectedExchange,
                      items: _exchanges,
                      onChanged: (value) {
                        setState(() {
                          _selectedExchange = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),

                  
                  Expanded(
                    child: AppDropdown(
                      type: AppDropdownType.search,
                      hintText: 'Symbol',
                      value: _selectedSymbol,
                      items: _symbols,
                      onChanged: (value) {
                        setState(() {
                          _selectedSymbol = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),

                  
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      'Start Time',
                      _startTime!,
                          (time) {
                        setState(() {
                          _startTime = time;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),

                  
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      'End Time',
                      _endTime!,
                          (time) {
                        setState(() {
                          _endTime = time;
                        });
                      },
                    ),
                  ),

                  const Spacer(),

                  
                  ViewResetButtons(
                    onReset: () {
                      context.read<IntradayHistoryBloc>().add(
                        const BackToListViewEvent(),
                      );
                    },
                    onView: () {
                      
                      if (_selectedExchange == null ||
                          _selectedExchange!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an Exchange'),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                        return;
                      }

                      if (_selectedSymbol == null || _selectedSymbol!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a Symbol'),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                        return;
                      }

                      
                      context.read<IntradayHistoryBloc>().add(
                        LoadSecondsDataEvent(
                          date: state.date,
                          exchange: _selectedExchange!,
                          symbol: _selectedSymbol!,
                          startTime: _startTime!,
                          endTime: _endTime!,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            context.read<IntradayHistoryBloc>().add(
              const BackToListViewEvent(),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24.sp,
            color: AppColors.primaryBlue,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        SizedBox(width: 8.w),
        Text(
          'Intraday History In Seconds',
          style: GoogleFonts.openSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
      BuildContext context, IntradayHistorySecondsView state) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primaryBlue, width: 2.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dateFormat.format(state.date),
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.calendar_today,
            size: 20.sp,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
      BuildContext context,
      String label,
      DateTime time,
      Function(DateTime) onTimeSelected,
      ) {
    final hour =
    time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final timeText = '${hour.toString().padLeft(2, '0')}:$minute $period';

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(time),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primaryBlue,
                  onPrimary: AppColors.white,
                  surface: AppColors.white,
                  onSurface: AppColors.primaryTextColor,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          final newTime = DateTime(
            time.year,
            time.month,
            time.day,
            picked.hour,
            picked.minute,
          );
          onTimeSelected(newTime);
        }
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primaryBlue, width: 2.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                timeText,
                style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.access_time,
              size: 20.sp,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}