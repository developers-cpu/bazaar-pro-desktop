import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/settlement_master_sharing.dart';
import '../../bloc/settlement_master_sharing/settlement_master_sharing_bloc.dart';
import '../../bloc/settlement_master_sharing/settlement_master_sharing_event.dart';
import '../../bloc/settlement_master_sharing/settlement_master_sharing_state.dart';
import '../../widgets/settlement_master_sharing/assign_master_dialog.dart';

class SettlementMasterSharingPage extends StatefulWidget {
  const SettlementMasterSharingPage({super.key});
  @override
  State<SettlementMasterSharingPage> createState() =>
      _SettlementMasterSharingPageState();
}

class _SettlementMasterSharingPageState
    extends State<SettlementMasterSharingPage> {
  String? _selectedMasterName;
  @override
  void initState() {
    super.initState();
    context.read<SettlementMasterSharingBloc>().add(
      LoadMasterSharingDataEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SettlementMasterSharingBloc,
      SettlementMasterSharingState
    >(
      builder: (context, state) {
        List<MasterUser> masters = [];
        List<MasterSharingEntry> entries = [];
        int totalRecords = 0;
        if (state is SettlementMasterSharingLoaded) {
          masters = state.masters;
          entries = state.entries;
          totalRecords = state.totalRecords;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  AppDropdown(
                    type: AppDropdownType.search,
                    hintText: 'Master',
                    value: _selectedMasterName,
                    items: masters.map((m) => m.name).toList(),
                    width: 180.w,
                    onChanged: (val) {
                      if (val == null || val.isEmpty) return;
                      final master = masters.firstWhere((m) => m.name == val);
                      setState(() => _selectedMasterName = val);
                      context.read<SettlementMasterSharingBloc>().add(
                        SelectMasterEvent(
                          masterId: master.id,
                          masterName: master.name,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  if (_selectedMasterName != null)
                    ViewRecordCount(count: entries.length),
                ],
              ),
            ),
            if (state is SettlementMasterSharingLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_selectedMasterName != null && entries.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildTable(entries, masters),
                ),
              )
            else if (_selectedMasterName != null && entries.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No data found',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTable(
    List<MasterSharingEntry> entries,
    List<MasterUser> masters,
  ) {
    return ViewDataTable<MasterSharingEntry>(
      columns: [
        ViewTableColumn(id: 'index', label: 'INDEX', width: 80.w),
        ViewTableColumn(id: 'username', label: 'USERNAME', width: 200.w),
        ViewTableColumn(
          id: 'assignedMaster',
          label: 'ASSIGNED MASTER',
          width: 250.w,
        ),
        ViewTableColumn(id: 'action', label: 'ACTION', width: 200.w),
      ],
      data: entries,
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'index':
            return item.index;
          case 'username':
            return item.username;
          case 'assignedMaster':
            return item.assignedMasterCount;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) => _buildCell(item, column.id, masters),
      idExtractor: (item) => item.userId,
      autoFit: true,
    );
  }

  Widget _buildCell(
    MasterSharingEntry item,
    String colId,
    List<MasterUser> masters,
  ) {
    switch (colId) {
      case 'index':
        return ViewTextCell(
          text: item.index.toString().padLeft(2, '0'),
          isDark: false,
          isNumeric: true,
        );
      case 'username':
        return ViewTextCell(text: item.username, isDark: false);
      case 'assignedMaster':
        final text = item.assignedMasterCount > 0
            ? '${item.assignedMasterCount} Master'
            : 'No Master Assigned';
        if (item.assignedMasterCount > 0) {
          return ViewLinkCell(
            text: text,
            isDark: false,
            onTap: () => _openAssignMasterDialog(item, masters),
          );
        }
        return ViewTextCell(text: text, isDark: false);
      case 'action':
        return ViewLinkCell(
          text: 'Assign Master',
          isDark: false,
          onTap: () => _openAssignCountDialog(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _openAssignMasterDialog(
    MasterSharingEntry entry,
    List<MasterUser> masters,
  ) {
    AssignMasterDialog.show(
      context: context,
      username: entry.username,
      assignedMasters: entry.assignedMasters,
      availableMasters: masters,
    );
  }

  void _openAssignCountDialog() {
    AssignCountDialog.show(context: context, onAssign: (count) {});
  }
}