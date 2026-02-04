import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/login_history/login_history.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../bloc/login_history/login_history_state.dart';
import '../common/view_data_table.dart';
import '../common/view_record_count.dart';
import '../common/view_table_cell_styles.dart';
class LoginHistoryTable extends StatelessWidget {
  const LoginHistoryTable({Key? key}) : super(key: key);
  static final List<ViewTableColumn> _columns = [
    const ViewTableColumn(id: 'index', label: 'INDEX', width: 80, isNumeric: true),
    const ViewTableColumn(id: 'loginTime', label: 'LOGIN TIME', width: 180),
    const ViewTableColumn(id: 'loginTime2', label: 'LOGIN TIME', width: 180),
    const ViewTableColumn(id: 'userName', label: 'USER NAME', width: 150),
    const ViewTableColumn(id: 'userType', label: 'USER TYPE', width: 150),
    const ViewTableColumn(id: 'ipAddress', label: 'IP ADDRESS', width: 150),
    const ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 550),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginHistoryBloc, LoginHistoryState>(
      builder: (context, state) {
        if (state is LoginHistoryInitial) {
          return Center(
            child: Text(
              'Please select a client to view login history',
              style: GoogleFonts.openSans(
                fontSize: 16.sp,
                color: AppColors.secondaryTextColor,
              ),
            ),
          );
        }
        if (state is LoginHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
          );
        }
        if (state is LoginHistoryError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          );
        }
        if (state is LoginHistoryLoaded) {
          return Column(
            children: [
              ViewRecordCount(count: state.totalRecords),
              Expanded(
                child: ViewDataTable<LoginHistory>(
                  columns: _columns,
                  data: state.history,
                  cellBuilder: _buildCell,
                  idExtractor: (history) => history.id,
                  onSort: (columnId, ascending) {
                    context.read<LoginHistoryBloc>().add(
                      SortLoginHistoryByColumnEvent(
                        columnId: columnId,
                        ascending: ascending,
                      ),
                    );
                  },
                  sortColumn: state.sortColumn,
                  sortAscending: state.sortAscending,
                  emptyMessage: 'No login history found',
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
  Widget _buildCell(LoginHistory history, ViewTableColumn column) {
    switch (column.id) {
      case 'index':
        return ViewTextCell(text: history.index.toString());
      case 'loginTime':
      case 'loginTime2':
        return ViewDateTimeCell(dateTime: history.loginTime);
      case 'userName':
        return ViewTextCell(text: history.userName);
      case 'userType':
        return ViewTextCell(
          text: history.userType,
          color: history.userType == 'MASTER'
              ? AppColors.primaryBlue
              : AppColors.secondaryTextColor,
          fontWeight: FontWeight.w600,
        );
      case 'ipAddress':
        return ViewTextCell(text: history.ipAddress);
      case 'deviceId':
        return ViewTextCell(text: history.deviceId);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}
