import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/broker_list/broker.dart';
import '../../bloc/broker_list/broker_list_bloc.dart';
import '../../bloc/broker_list/broker_list_state.dart';
import '../common/view_data_table.dart';
import '../common/view_table_cell_styles.dart';
import 'broker_client_dialog.dart';

class BrokerListTable extends StatelessWidget {
  final bool isDarkMode;

  const BrokerListTable({Key? key, this.isDarkMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrokerListBloc, BrokerListState>(
      builder: (context, state) {
        if (state is BrokerListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BrokerListError) {
          return Center(child: Text(state.message));
        }

        List<Broker> brokers = [];
        if (state is BrokerListLoaded) {
          brokers = state.brokers;
        } else if (state is BrokerClientsLoaded) {
          brokers = state.brokers;
        } else {
          return const Center(child: Text('No data loaded'));
        }

        return ViewDataTable<Broker>(
          columns: _getColumns(),
          data: brokers,
          idExtractor: (item) => item.index.toString(),
          isDarkMode: isDarkMode,
          autoFit: true,
          headerBgColor: const Color(0xFFD3E3EC),
          cellBuilder: (item, column) => _buildCell(context, item, column),
        );
      },
    );
  }

  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'index', label: 'INDEX', width: 100),
      ViewTableColumn(id: 'createdAt', label: 'CREATED AT', width: 200),
      ViewTableColumn(id: 'name', label: 'BROKER NAME', width: 200),
      ViewTableColumn(id: 'clientsCount', label: 'CLIENTS COUNT', width: 200),
      ViewTableColumn(
        id: 'totalBrokerage',
        label: 'TOTAL BROKERAGE',
        width: 200,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 200),
    ];
  }

  Widget _buildCell(BuildContext context, Broker item, ViewTableColumn column) {
    switch (column.id) {
      case 'index':
        return ViewTextCell(text: item.index.toString(), isDark: isDarkMode);
      case 'createdAt':
        return ViewDateTimeCell(dateTime: item.createdAt, isDark: isDarkMode);
      case 'name':
        return ViewTextCell(text: item.name, isDark: isDarkMode);
      case 'clientsCount':
        return ViewLinkCell(
          text: item.clientsCount.toString(),
          isDark: isDarkMode,
          onTap: () {
            BrokerClientDialog.show(
              context: context,
              brokerName: item.name,
              isDarkMode: isDarkMode,
            );
          },
        );
      case 'totalBrokerage':
        return ViewNumberCell(
          value: item.totalBrokerage,
          isDark: isDarkMode,
          colorByValue: false,
          fixedColor: isDarkMode ? Colors.white : AppColors.black,
        );
      case 'updatedOn':
        return ViewDateTimeCell(dateTime: item.updatedOn, isDark: isDarkMode);
      default:
        return const SizedBox.shrink();
    }
  }
}
