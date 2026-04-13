import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../injection_container.dart';
import '../../domain/entities/spraed_report_entity.dart';
import '../bloc/spraed_report/spraed_report_bloc.dart';
import '../bloc/spraed_report/spraed_report_event.dart';
import '../bloc/spraed_report/spraed_report_state.dart';
import '../widgets/spraed_report/spraed_report_table.dart';
import 'report_page_wrapper.dart';

class SpraedReportPageWithAppBar extends StatelessWidget {
  const SpraedReportPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SpraedReportBloc>()..add(const FetchSpraedReportEvent(exchange: 'NSE')),
      child: const ReportPageWrapper(
        pageTitle: 'Spraed Report',
        child: _SpraedReportPage(),
      ),
    );
  }
}

class _SpraedReportPage extends StatefulWidget {
  const _SpraedReportPage();

  @override
  State<_SpraedReportPage> createState() => _SpraedReportPageState();
}

class _SpraedReportPageState extends State<_SpraedReportPage> {
  String? _selectedExchange = 'NSE';

  @override
  Widget build(BuildContext context) {
    final exchangesList = [
      'All', 'NSE', 'MCX', 'CE/PE', 'OTHERS', 'COMEX FUTURE', 'COMEX SPOT', 'CRYPTO', 'GIFT', 'FOREX'
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: exchangesList,
                value: _selectedExchange,
                onChanged: (value) {
                  setState(() {
                    _selectedExchange = value;
                  });
                  context.read<SpraedReportBloc>().add(
                    FetchSpraedReportEvent(
                      exchange: value == 'All' ? null : value,
                    ),
                  );
                },
                width: 200.w,
                height: 35.h,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<SpraedReportBloc, SpraedReportState>(
              builder: (context, state) {
                if (state is SpraedReportLoading || state is SpraedReportInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SpraedReportError) {
                  return Center(
                    child: Text(
                      state.message, 
                      style: GoogleFonts.openSans(color: Colors.red),
                    ),
                  );
                } else if (state is SpraedReportLoaded) {
                  return SpraedReportTable(data: state.data);
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
