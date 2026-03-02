import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../bloc/intraday_history/intraday_history_bloc.dart';
import '../../bloc/intraday_history/intraday_history_event.dart';
import '../../bloc/intraday_history/intraday_history_state.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';

class IntradaySecondsFilterBar extends StatefulWidget {
  const IntradaySecondsFilterBar({Key? key}) : super(key: key);
  @override
  State<IntradaySecondsFilterBar> createState() =>
      _IntradaySecondsFilterBarState();
}

class _IntradaySecondsFilterBarState extends State<IntradaySecondsFilterBar> {
  DateTime? _selectedDate;
  String? _selectedExchange;
  String? _selectedSymbol;
  final List<String> _exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'GIFT',
    'FOREX',
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
        final authState = context.read<AuthBloc>().state;
        final isClient =
            authState is AuthAuthenticated &&
            authState.user.role.toLowerCase() == 'client';

        _selectedDate ??= state.date;
        _selectedExchange ??= state.exchange.isNotEmpty ? state.exchange : null;
        _selectedSymbol ??= state.symbol.isNotEmpty ? state.symbol : null;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              Row(children: [_buildBackButton(context)]),
              SizedBox(height: 12.h),
              Row(
                children: [
                  AppDatePicker(
                    label: '',
                    value: _selectedDate,
                    onChanged: (value) {
                      setState(() {
                        _selectedDate = value;
                      });
                    },
                    width: 200.w,
                    height: 35.h,
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 200.w,
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
                  SizedBox(
                    width: 200.w,
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
                  if (!isClient) ...[
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
                        if (_selectedSymbol == null ||
                            _selectedSymbol!.isEmpty) {
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
                            startTime: state.startTime,
                            endTime: state.endTime,
                          ),
                        );
                      },
                    ),
                  ],
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
            size: 20.sp,
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
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
