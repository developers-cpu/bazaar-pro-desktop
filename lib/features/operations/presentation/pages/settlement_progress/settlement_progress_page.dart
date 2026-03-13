import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/settlement_progress/settlement_progress_bloc.dart';
import '../../bloc/settlement_progress/settlement_progress_event.dart';
import '../../bloc/settlement_progress/settlement_progress_state.dart';
import '../../widgets/settlement_progress/settlement_progress_tab_bar.dart';
import '../../widgets/settlement_progress/settlement_progress_data_table.dart';
import '../../widgets/settlement_progress/dialogs/import_file_dialog.dart';
import '../../widgets/settlement_progress/dialogs/bhav_copy_preview_dialog.dart';
import '../../widgets/settlement_progress/dialogs/settlement_progress_indicator_dialog.dart';
import '../../widgets/settlement_progress/dialogs/update_database_dialog.dart';
import '../../../domain/entities/settlement_progress/bhav_copy_entity.dart';

class SettlementProgressPage extends StatefulWidget {
  const SettlementProgressPage({super.key});

  @override
  State<SettlementProgressPage> createState() => _SettlementProgressPageState();
}

class _SettlementProgressPageState extends State<SettlementProgressPage> {
  int _activeTab = 0;

  final _exchanges = const [
    'NSE',
    'MCX',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'COMEX FUTURE',
    'COMEX SPOT',
    'CRYPTO',
    'FOREX',
    'USSTOCK',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _showImportDialog(BuildContext context) {
    ImportFileDialog.show(context, bloc: context.read<SettlementProgressBloc>());
  }

  void _showPreviewDialog(BuildContext context, List<BhavCopyEntity> data) {
    BhavCopyPreviewDialog.show(
      context,
      data: data,
      bloc: context.read<SettlementProgressBloc>(),
    );
  }

  void _showProgressDialog(BuildContext context) {
    SettlementProgressIndicatorDialog.show(
      context,
      bloc: context.read<SettlementProgressBloc>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettlementProgressBloc, SettlementProgressState>(
      listener: (context, state) {
        if (state is SettlementProgressError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is BhavCopyPreviewReady) {
          _showPreviewDialog(context, state.previewData);
        } else if (state is SettlementProgressUpdating) {
          _showProgressDialog(context);
        }
      },
      builder: (context, state) {
        List<BhavCopyEntity> displayData = [];
        if (state is SettlementDataLoaded) {
          displayData = state.settlementData;
        }
        final bool hasData = displayData.isNotEmpty;
        final bool isLoading = state is SettlementProgressLoading;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SettlementProgressTabBar(
                      tabs: _exchanges,
                      activeTab: _activeTab,
                      onTabChanged: (i) {
                        setState(() => _activeTab = i);
                        context.read<SettlementProgressBloc>().add(
                          ChangeExchangeEvent(_exchanges[i]),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 15.w),
                  CustomActionButton(
                    text: 'Import Bhav copy',
                    onPressed: () => _showImportDialog(context),
                    width: 140.w,
                    height: 35.h,
                  ),
                  if (hasData) ...[
                    SizedBox(width: 10.w),
                      CustomActionButton(
                        text: 'Download Database',
                        onPressed: () {
                          UpdateDatabaseDialog.show(context);
                        },
                        width: 160.w,
                        height: 35.h,
                      ),
                  ],
                ],
              ),
              SizedBox(height: 15.h),
              if (hasData) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'RECORD : ${displayData.length}',
                    style: GoogleFonts.openSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
              if (hasData || isLoading)
                Expanded(child: _buildBody(state, displayData)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    SettlementProgressState state,
    List<BhavCopyEntity> displayData,
  ) {
    if (state is SettlementProgressLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 10.h),
            Text(state.message),
          ],
        ),
      );
    }

    if (state is SettlementDataLoaded) {
      return SettlementProgressDataTable(data: displayData);
    }

    return const SizedBox.shrink();
  }
}
