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
import 'client_breakdown_dialog.dart';

class BrokerClientDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "Broker's Client",
      isDarkMode: isDarkMode,
      width: 800.w,
      height: 600.h,
      headerColor: const Color(0xFF2C5F7A),
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
                  width: 250.w,
                  child: AppDropdown(
                    type: AppDropdownType.simple,
                    hintText: 'This Week',
                    items: const [
                      'This Week',
                      'Previous Week',
                      'Custom Period',
                    ],
                    subtitles: const [
                      '27-10-25 to 02-11-25',
                      '20-10-25 to 26-10-25',
                      'Select Date Range',
                    ],
                    onChanged: (value) {},
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
                              width: 380,
                            ),
                            ViewTableColumn(
                              id: 'brokerage',
                              label: 'BROKERAGE',
                              width: 380,
                              isNumeric: true,
                            ),
                          ],
                          data: clients,
                          idExtractor: (item) => item.name,
                          isDarkMode: isDarkMode,
                          autoFit: true,
                          headerBgColor: const Color(0xFFD3E3EC),
                          cellBuilder: (item, column) {
                            if (column.id == 'name') {
                              return ViewLinkCell(
                                text: item.name,
                                isDark: isDarkMode,
                                onTap: () {
                                  ClientBreakdownDialog.show(
                                    context: context,
                                    brokerId: 'brokerdemo01',
                                    clientName: item.name,
                                    isDarkMode: isDarkMode,
                                  );
                                },
                              );
                            }
                            return ViewTextCell(
                              text: item.brokerage.toStringAsFixed(0),
                              isDark: isDarkMode,
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
                              isDarkMode: isDarkMode,
                              backgroundColor: const Color(0xFFD3E3EC),
                              textAlign: TextAlign.center,
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
