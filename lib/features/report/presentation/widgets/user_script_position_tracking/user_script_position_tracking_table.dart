import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../users/domain/entities/user.dart';
import '../../../../users/presentation/widgets/user_details/user_details_dialog.dart';
import '../../../../users/presentation/widgets/create_user/client_form_dialog.dart';
import '../../../../users/presentation/widgets/create_user/update_access_dialog.dart';
import '../../../../report/domain/entities/user_script_position_tracking.dart';
import '../../bloc/user_script_position_tracking/user_script_position_tracking_bloc.dart';
import '../../bloc/user_script_position_tracking/user_script_position_tracking_state.dart';

class UserScriptPositionTrackingTable extends StatelessWidget {
  final bool isDarkMode;
  const UserScriptPositionTrackingTable({super.key, this.isDarkMode = false});
  List<ViewTableColumn> _getColumns() {
    return const [
      ViewTableColumn(id: 'positionDate', label: 'POSITION DATE', width: 180),
      ViewTableColumn(id: 'userName', label: 'USERNAME', width: 150),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 150),
      ViewTableColumn(id: 'position', label: 'POSITION', width: 100),
      ViewTableColumn(id: 'openAPrice', label: 'OPEN A PRICE', width: 120),
      ViewTableColumn(id: 'days', label: 'DAYS', width: 80),
    ];
  }

  Widget _buildCell(
    BuildContext context,
    UserScriptPositionTracking item,
    ViewTableColumn column,
    bool isDark,
  ) {
    switch (column.id) {
      case 'positionDate':
        return ViewTextCell(text: item.positionDate, isDark: isDark);
      case 'userName':
        return ViewLinkCell(
          text: item.userName,
          isDark: isDark,
          onTap: () {
            final dummyUser = User(
              id: item.id,
              userName: item.userName,
              name: item.userName,
              parentUser: '',
              type: 'Client',
              plPercent: 0,
              brkPercent: 0,
              leverage: '',
              credit: 0,
              pl: 0,
              equity: 0,
              totalMargin: 0,
              usedMargin: 0,
              freeMargin: 0,
              createdDate: DateTime.now(),
              status: 'Active',
            );
            UserDetailsDialog.show(
              context,
              dummyUser,
              onEdit: (ctx) {
                ClientFormDialog.showEdit(
                  context: ctx,
                  userData: {
                    'name': dummyUser.name,
                    'username': dummyUser.userName,
                  },
                  onComplete: () {},
                );
              },
              onAction: (ctx) {
                UpdateAccessDialog.show(
                  context: ctx,
                  userId: dummyUser.id,
                  userName: dummyUser.userName,
                  currentSettings: {
                    'bet': true,
                    'closeOnly': false,
                    'viewOnly': false,
                    'status': true,
                    'allowChat': true,
                    'positionCut15Days': false,
                    'freshLimitSL': true,
                    'lockUser': false,
                  },
                  onUpdate: (settings) {
                    Navigator.pop(ctx);
                  },
                );
              },
            );
          },
        );
      case 'symbol':
        return ViewTextCell(text: item.symbol, isDark: isDark);
      case 'position':
        return ViewTextCell(text: item.position, isDark: isDark);
      case 'openAPrice':
        return ViewNumberCell(
          value: item.openAPrice,
          isDark: isDark,
          colorByValue: false,
        );
      case 'days':
        return ViewTextCell(text: item.days.toString(), isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      UserScriptPositionTrackingBloc,
      UserScriptPositionTrackingState
    >(
      builder: (context, state) {
        if (state is UserScriptPositionTrackingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserScriptPositionTrackingError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is! UserScriptPositionTrackingLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ViewRecordCount(count: state.reports.length),
            Flexible(
              fit: FlexFit.loose,
              child: ViewDataTable<UserScriptPositionTracking>(
                columns: _getColumns(),
                data: state.reports,
                idExtractor: (item) => item.id,
                sortColumn: null,
                sortAscending: true,
                autoFit: true,
                isDarkMode: isDarkMode,
                emptyMessage: 'No records found',
                cellBuilder: (item, column) =>
                    _buildCell(context, item, column, isDarkMode),
              ),
            ),
          ],
        );
      },
    );
  }
}
