import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/app_switch.dart';
import '../../../domain/entities/server/server_entity.dart';
import '../../../../../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ServerDataTable extends StatelessWidget {
  final List<ServerEntity> data;
  final Function(String id, bool status) onToggleStatus;
  final Function(ServerEntity server) onEditServer;
  const ServerDataTable({
    super.key,
    required this.data,
    required this.onToggleStatus,
    required this.onEditServer,
  });
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No servers found',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }
    return ViewDataTable<ServerEntity>(
      data: data,
      columns: _buildColumns(),
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'index': return item.index;
          case 'serverName': return item.serverName;
          case 'updatedOn': return item.updatedOn;
          case 'updatedBy': return item.updatedBy;
          case 'status': return item.status ? 1 : 0;
          default: return '';
        }
      },
      cellBuilder: (item, column) {
        if (column.id == 'status') {
          return AppSwitch(
            value: item.status,
            onChanged: (val) => onToggleStatus(item.id, val),
          );
        }
        if (column.id == 'serverName') {
          return InkWell(
            onTap: () => onEditServer(item),
            child: Text(
              item.serverName,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                color: AppColors.primaryBlue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        return _buildCell(item, column.id);
      },
      idExtractor: (item) => item.id,
      autoFit: true,
    );
  }

  List<ViewTableColumn> _buildColumns() {
    return [
      ViewTableColumn(id: 'index', label: 'INDEX', width: 80.w),
      ViewTableColumn(id: 'serverName', label: 'SERVER NAME', width: 250.w),
      ViewTableColumn(id: 'updatedOn', label: 'UPDATED ON', width: 250.w),
      ViewTableColumn(id: 'updatedBy', label: 'UPDATED BY', width: 200.w),
      ViewTableColumn(id: 'status', label: 'STATUS', width: 120.w),
    ];
  }

  Widget _buildCell(ServerEntity item, String colId) {
    String text = '';
    switch (colId) {
      case 'index':
        text = '${item.index}'.padLeft(2, '0');
        break;
      case 'updatedOn':
        text = item.updatedOn;
        break;
      case 'updatedBy':
        text = item.updatedBy;
        break;
    }
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.primaryBlue,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
