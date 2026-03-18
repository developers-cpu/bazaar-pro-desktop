import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../domain/entities/settlement_master_sharing.dart';

class AssignMasterDialog extends StatefulWidget {
  final String username;
  final List<AssignedMaster> assignedMasters;
  final List<MasterUser> availableMasters;
  final VoidCallback onClose;
  const AssignMasterDialog({
    super.key,
    required this.username,
    required this.assignedMasters,
    required this.availableMasters,
    required this.onClose,
  });
  static void show({
    required BuildContext context,
    required String username,
    required List<AssignedMaster> assignedMasters,
    required List<MasterUser> availableMasters,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Assign master',
      showButtons: false,
      width: 500.w,
      contentBuilder: (context, onClose) => AssignMasterDialog(
        username: username,
        assignedMasters: assignedMasters,
        availableMasters: availableMasters,
        onClose: onClose,
      ),
    );
  }

  @override
  State<AssignMasterDialog> createState() => _AssignMasterDialogState();
}

class _AssignMasterDialogState extends State<AssignMasterDialog> {
  late TextEditingController _percentSharingController;
  late List<_MasterRow> _rows;
  final Set<int> _selectedRows = {};
  bool _selectAll = false;
  @override
  void initState() {
    super.initState();
    _percentSharingController = TextEditingController(text: '% Sharing');
    _rows = widget.assignedMasters
        .map(
          (m) => _MasterRow(
            selectedMasterName: m.name,
            percentSharing: m.percentSharing,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _percentSharingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 280.w,
          height: 38.h,
          child: TextField(
            controller: _percentSharingController,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: AppColors.billDataText,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.primaryBlue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ViewDataTable<_MasterRow>(
          columns: [
            ViewTableColumn(
              id: 'checkbox',
              label: '',
              width: 50.w,
              sortable: false,
              customHeaderWidget: Checkbox(
                value: _selectAll,
                onChanged: (val) {
                  setState(() {
                    _selectAll = val ?? false;
                    if (_selectAll) {
                      _selectedRows.addAll(
                        List.generate(_rows.length, (i) => i),
                      );
                    } else {
                      _selectedRows.clear();
                    }
                  });
                },
                activeColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
              ),
            ),
            ViewTableColumn(
              id: 'assignedMasters',
              label: 'ASSIGNED MASTERS',
              width: 250.w,
            ),
            ViewTableColumn(
              id: 'percentSharing',
              label: '% SHARING',
              width: 120.w,
              isNumeric: true,
            ),
          ],
          data: _rows,
          comparatorBuilder: (item, columnId) {
            switch (columnId) {
              case 'master':
                return item.selectedMasterName ?? '';
              case 'percentSharing':
                return item.percentSharing;
              default:
                return '';
            }
          },
          cellBuilder: (item, column) {
            final index = _rows.indexOf(item);
            if (column.id == 'checkbox') {
              return Checkbox(
                value: _selectedRows.contains(index),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedRows.add(index);
                    } else {
                      _selectedRows.remove(index);
                    }
                    _selectAll = _selectedRows.length == _rows.length;
                  });
                },
                activeColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
              );
            }
            if (column.id == 'assignedMasters') {
              return AppDropdown(
                type: AppDropdownType.search,
                hintText: 'Select',
                value: item.selectedMasterName,
                items: widget.availableMasters.map((m) => m.name).toList(),
                height: 30.h,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _rows[index] = _MasterRow(
                      selectedMasterName: val,
                      percentSharing: item.percentSharing,
                    );
                  });
                },
              );
            }
            if (column.id == 'percentSharing') {
              return ViewTextCell(
                text: item.percentSharing.toStringAsFixed(0),
                isDark: false,
                isNumeric: true,
              );
            }
            return const SizedBox.shrink();
          },
          idExtractor: (item) => _rows.indexOf(item).toString(),
          autoFit: true,
          shrinkWrap: true,
          rowHeight: 40.h,
        ),
        SizedBox(height: 16.h),
        Center(
          child: CustomActionButton(
            text: 'Update',
            onPressed: widget.onClose,
            width: 120.w,
            height: 38.h,
            backgroundColor: AppColors.primaryBlue,
            borderRadius: 8.r,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}

class _MasterRow {
  final String? selectedMasterName;
  final double percentSharing;
  _MasterRow({this.selectedMasterName, required this.percentSharing});
}

class AssignCountDialog {
  static void show({
    required BuildContext context,
    required Function(int count) onAssign,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Assign master',
      showButtons: false,
      width: 350.w,
      contentBuilder: (context, onClose) =>
          _AssignCountContent(onAssign: onAssign, onClose: onClose),
    );
  }
}

class _AssignCountContent extends StatefulWidget {
  final Function(int count) onAssign;
  final VoidCallback onClose;
  const _AssignCountContent({
    Key? key,
    required this.onAssign,
    required this.onClose,
  }) : super(key: key);
  @override
  State<_AssignCountContent> createState() => _AssignCountContentState();
}

class _AssignCountContentState extends State<_AssignCountContent> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 280.w,
          height: 38.h,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              color: AppColors.billDataText,
            ),
            decoration: InputDecoration(
              hintText: 'Count of Master to Assign',
              hintStyle: GoogleFonts.openSans(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primaryBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.primaryBlue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        CustomActionButton(
          text: 'Assign',
          onPressed: () {
            final count = int.tryParse(_controller.text) ?? 0;
            widget.onAssign(count);
            widget.onClose();
          },
          width: 120.w,
          height: 38.h,
          backgroundColor: AppColors.primaryBlue,
          borderRadius: 8.r,
          fontSize: 13.sp,
        ),
      ],
    );
  }
}
