import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../domain/entities/broker_list/broker_client.dart';
import '../../bloc/broker_list/broker_list_bloc.dart';
import '../../bloc/broker_list/broker_list_event.dart';
import '../../bloc/broker_list/broker_list_state.dart';
import '../../../../../core/widget/table/view_data_table_footer.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../../../core/widget/date_range_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'client_breakdown_dialog.dart';

class BrokerClientDialog extends StatefulWidget {
  final String brokerName;
  final bool isDarkMode;
  const BrokerClientDialog({
    Key? key,
    required this.brokerName,
    this.isDarkMode = false,
  }) : super(key: key);
  static void show({
    required BuildContext context,
    required String brokerName,
    bool isDarkMode = false,
  }) {
    context.read<BrokerListBloc>().add(
      LoadBrokerClientsEvent(brokerName: brokerName),
    );
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.54),
      builder: (_) => BlocProvider.value(
        value: context.read<BrokerListBloc>(),
        child: BrokerClientDialog(
          brokerName: brokerName,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  @override
  State<BrokerClientDialog> createState() => _BrokerClientDialogState();
}

class _BrokerClientDialogState extends State<BrokerClientDialog> {
  String _customPeriodLabel = 'Select Date Range';
  String _selectedDateRange = 'This Week';

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "Broker's Client",
      isDarkMode: widget.isDarkMode,
      width: 600.w,
      height: 450.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    type: AppDropdownType.simple,
                    hintText: 'This Week',
                    value: _selectedDateRange,
                    items: const [
                      'This Week',
                      'Previous Week',
                      'Custom Period',
                    ],
                    subtitles: [
                      '27-10-25 to 02-11-25',
                      '20-10-25 to 26-10-25',
                      _customPeriodLabel,
                    ],
                    onChanged: (value) async {
                      if (value == 'Custom Period') {
                        final DateTimeRange? picked =
                            await CustomDateRangePickerDialog.show(
                              context,
                              showSimpleUI: true,
                            );
                        if (picked != null) {
                          setState(() {
                            _selectedDateRange = value!;
                            _customPeriodLabel =
                                '${DateFormat('dd-MM-yy').format(picked.start)} to ${DateFormat('dd-MM-yy').format(picked.end)}';
                          });
                        }
                      } else if (value != null) {
                        setState(() {
                          _selectedDateRange = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocBuilder<BrokerListBloc, BrokerListState>(
                builder: (context, state) {
                  if (state is BrokerListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is! BrokerClientsLoaded) {
                    return const Center(child: Text('Loading clients...'));
                  }
                  final clients = state.clients;
                  return Column(
                    children: [
                      ViewRecordCount(count: clients.length),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: ViewDataTable<BrokerClient>(
                          columns: const [
                            ViewTableColumn(
                              id: 'name',
                              label: 'CLIENT NAME',
                              width: 100,
                            ),
                            ViewTableColumn(
                              id: 'brokerage',
                              label: 'BROKERAGE',
                              width: 100,
                              isNumeric: true,
                            ),
                          ],
                          data: clients,
                          idExtractor: (item) => item.name,
                          isDarkMode: widget.isDarkMode,
                          autoFit: true,
                          headerBgColor: const Color(0xFFD3E3EC),
                          comparatorBuilder: (item, columnId) {
                            switch (columnId) {
                              case 'name':
                                return item.name;
                              case 'brokerage':
                                return item.brokerage;
                              default:
                                return '';
                            }
                          },
                          cellBuilder: (item, column) {
                            if (column.id == 'name') {
                              return ViewLinkCell(
                                text: item.name,
                                isDark: widget.isDarkMode,
                                onTap: () {
                                  ClientBreakdownDialog.show(
                                    context: context,
                                    brokerId: 'brokerdemo01',
                                    clientName: item.name,
                                    isDarkMode: widget.isDarkMode,
                                  );
                                },
                              );
                            }
                            return ViewNumberCell(
                              value: item.brokerage,
                              displayText: item.brokerage.toStringAsFixed(0),
                              isDark: widget.isDarkMode,
                              colorByValue: false,
                              fixedColor: widget.isDarkMode
                                  ? Colors.white
                                  : AppColors.black,
                            );
                          },
                          footerBuilder: (columns) {
                            return ViewDataTableFooter(
                              columns: columns,
                              values: {
                                'name': 'TOTAL',
                                'brokerage': clients
                                    .fold(
                                      0.0,
                                      (sum, item) => sum + item.brokerage,
                                    )
                                    .toStringAsFixed(0),
                              },
                              isDarkMode: widget.isDarkMode,
                              backgroundColor: const Color(0xFFD3E3EC),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
