import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../bloc/group/group_bloc.dart';
import '../../bloc/group/group_event.dart';
import '../../bloc/group/group_state.dart';
import '../../widgets/group/add_group_dialog.dart';
import '../../widgets/group/import_group_data_dialog.dart';
import '../../widgets/group/group_data_table.dart';
import '../operations_page_wrapper.dart';
import '../../../../../injection_container.dart';

class GroupPageWithAppBar extends StatelessWidget {
  const GroupPageWithAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupBloc>()..add(LoadGroupsEvent()),
      child: Builder(
        builder: (context) {
          return OperationsPageWrapper(
            pageTitle: 'Group',
            onExportPdf: () {},
            onExportExcel: () {},
            child: const GroupPage(),
          );
        },
      ),
    );
  }
}

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final _searchCtrl = TextEditingController();
  final _breakupQtyCtrl = TextEditingController();
  final _maxQtyCtrl = TextEditingController();
  int _viewLevel = 0;
  String? _selectedExchange;
  String? _selectedGroupName;
  Set<String> _selectedIds = {};
  Map<String, bool> _hideGroupState = {};
  @override
  void dispose() {
    _searchCtrl.dispose();
    _breakupQtyCtrl.dispose();
    _maxQtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (ctx, state) {
        if (state is GroupOperationSuccess) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is GroupError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, state) {
        final groups = (state is GroupsLoaded) ? state.groups : [];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_viewLevel > 0) _buildBackHeader(),
              if (_viewLevel == 2) _buildQuantityRow(),
              _buildToolbar(groups.length),
              SizedBox(height: 10.h),
              Expanded(child: _buildBody(state, groups)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackHeader() {
    final title = _viewLevel == 1
        ? 'Group Settings (${_selectedExchange ?? ''})'
        : 'Group Settings (${_selectedGroupName ?? ''})';
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: Icon(
              Icons.arrow_back,
              size: 20.sp,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          _labelledInput('Breakup Quantity', _breakupQtyCtrl),
          SizedBox(width: 20.w),
          _labelledInput('Max Quantity', _maxQtyCtrl),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: [
                _actionBtn('Update', () {}),
                SizedBox(width: 10.w),
                _actionBtn('Import Data', _showImportDialog, width: 110.w),
                SizedBox(width: 10.w),
                _actionBtn('Download CSV', () {}, width: 120.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelledInput(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: 5.h),
        CustomInputField(
          hintText: '0.05',
          controller: ctrl,
          width: 180.w,
          height: 35.h,
        ),
      ],
    );
  }

  Widget _actionBtn(String text, VoidCallback onTap, {double? width}) {
    return CustomActionButton(
      text: text,
      onPressed: onTap,
      width: width ?? 100.w,
      height: 35.h,
      borderRadius: 8.r,
    );
  }

  Widget _buildToolbar(int count) {
    return Column(
      children: [
        Row(
          children: [
            CustomInputField(
              hintText: 'Search',
              controller: _searchCtrl,
              prefixSvgPath: AppImages.searchIcon,
              width: 300.w,
              height: 35.h,
            ),
            const Spacer(),
            if (_viewLevel <= 1)
              CustomActionButton(
                text: 'Add New Group',
                onPressed: _showAddGroupDialog,
                width: 150.w,
                height: 35.h,
                borderRadius: 8.r,
              ),
          ],
        ),
        SizedBox(height: 5.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'RECORD : $count',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(GroupState state, List<dynamic> groups) {
    if (state is GroupLoading && state is! GroupsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GroupError) {
      return Center(child: Text(state.message));
    }
    return GroupDataTable(
      viewLevel: _viewLevel,
      groups: groups,
      selectedIds: _selectedIds,
      hideGroupState: _hideGroupState,
      onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
      onHideGroupChanged: (entry) {
        setState(() => _hideGroupState[entry.key] = entry.value);
      },
      onExchangeTap: (exchange) {
        setState(() {
          _viewLevel = 1;
          _selectedExchange = exchange;
          _selectedIds.clear();
        });
      },
      onGroupNameTap: (item) {
        _showAddGroupDialog(
          isEdit: true,
          initialExchange: item.exchange,
          initialGroupName: item.groupName,
        );
      },
      onActionTap: (item) {
        setState(() {
          if (_viewLevel == 1) {
            _viewLevel = 2;
            _selectedGroupName = item.groupName;
          }
          _selectedIds.clear();
        });
      },
      onImportTap: _showImportDialog,
    );
  }

  void _goBack() {
    setState(() {
      _viewLevel--;
      if (_viewLevel == 0) _selectedExchange = null;
      if (_viewLevel == 1) _selectedGroupName = null;
      _selectedIds.clear();
    });
  }

  void _showAddGroupDialog({
    bool isEdit = false,
    String? initialExchange,
    String? initialGroupName,
    bool initialIsDefault = false,
  }) {
    AddGroupDialog.show(
      context: context,
      isEdit: isEdit,
      initialExchange: initialExchange,
      initialGroupName: initialGroupName,
      initialIsDefault: initialIsDefault,
      bloc: context.read<GroupBloc>(),
    );
  }

  void _showImportDialog() {
    ImportGroupDataDialog.show(context, bloc: context.read<GroupBloc>());
  }
}