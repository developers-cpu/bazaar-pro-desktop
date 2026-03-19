import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/login_history/login_history.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../bloc/login_history/login_history_state.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';

class LoginHistoryTable extends StatelessWidget {
  const LoginHistoryTable({Key? key}) : super(key: key);
  List<ViewTableColumn> _getColumns(bool isClient) {
    if (isClient) {
      return const [
        ViewTableColumn(id: 'loginTime', label: 'LOGIN TIME', width: 200),
        ViewTableColumn(id: 'logoutTime', label: 'LOGOUT TIME', width: 200),
      ];
    }
    return const [
      ViewTableColumn(id: 'index', label: 'INDEX', width: 60, isNumeric: true),
      ViewTableColumn(id: 'loginTime', label: 'LOGIN TIME', width: 110),
      ViewTableColumn(id: 'logoutTime', label: 'LOGOUT TIME', width: 110),
      ViewTableColumn(id: 'userName', label: 'USER NAME', width: 80),
      ViewTableColumn(id: 'userType', label: 'USER TYPE', width: 70),
      ViewTableColumn(
        id: 'ipAddress',
        label: 'IP ADDRESS',
        width: 80,
        isNumeric: true,
      ),
      ViewTableColumn(id: 'deviceId', label: 'DEVICE ID', width: 160),
      ViewTableColumn(id: 'device', label: 'DEVICE', width: 70),
      ViewTableColumn(id: 'city', label: 'CITY', width: 90),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isClient = false;
    try {
      final authState = context.read<AuthBloc>().state;
      isClient =
          authState is AuthAuthenticated &&
          authState.user.role.toLowerCase() == 'client';
    } catch (_) {}
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
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
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
                  columns: _getColumns(isClient),
                  data: state.history,
                  cellBuilder: (history, column) =>
                      _buildCell(history, column, isClient),
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
                  autoFit: true,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCell(
    LoginHistory history,
    ViewTableColumn column,
    bool isClient,
  ) {
    switch (column.id) {
      case 'index':
        return ViewTextCell(text: history.index.toString(), isNumeric: true);
      case 'loginTime':
        return isClient
            ? ViewDateTimeCell(
                dateTime: history.loginTime,
                color: AppColors.buyColor,
              )
            : ViewDateTimeCell(dateTime: history.loginTime);
      case 'logoutTime':
        return isClient
            ? ViewDateTimeCell(
                dateTime: history.logoutTime,
                color: AppColors.sellColor,
              )
            : ViewDateTimeCell(dateTime: history.logoutTime);
      case 'userName':
        return ViewTextCell(text: history.userName);
      case 'userType':
        return ViewTextCell(text: history.userType);
      case 'ipAddress':
        return ViewTextCell(text: history.ipAddress, isNumeric: true);
      case 'deviceId':
        return ViewTextCell(text: history.deviceId);
      case 'device':
        return ViewTextCell(text: history.device);
      case 'city':
        return ViewTextCell(text: history.city);
      default:
        return const ViewTextCell(text: '-');
    }
  }
}