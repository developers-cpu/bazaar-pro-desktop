import 'package:bazarpro/core/widget/custom_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_quantity_setting/user_quantity_setting.dart';
import '../../../bloc/user_quantity_settings/user_quantity_settings_bloc.dart';
import '../../../bloc/user_quantity_settings/user_quantity_settings_event.dart';
import '../../../bloc/user_quantity_settings/user_quantity_settings_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_reset_buttons.dart';
import '../../../../../../injection_container.dart';

class UserQuantitySettingsTab extends StatelessWidget {
  final User user;
  final String? groupName;

  const UserQuantitySettingsTab({
    super.key,
    required this.user,
    this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserQuantitySettingsBloc>()
            ..add(LoadUserQuantitySettings(user.id)),
      child: UserQuantitySettingsTabView(groupName: groupName),
    );
  }
}

class UserQuantitySettingsTabView extends StatefulWidget {
  final String? groupName;
  const UserQuantitySettingsTabView({super.key, this.groupName});

  @override
  State<UserQuantitySettingsTabView> createState() =>
      _UserQuantitySettingsTabViewState();
}

class _UserQuantitySettingsTabViewState
    extends State<UserQuantitySettingsTabView> {
  final TextEditingController _maxQtyController = TextEditingController();
  final TextEditingController _breakupQtyController = TextEditingController();
  final TextEditingController _maxLotController = TextEditingController();
  final TextEditingController _breakupLotController = TextEditingController();

  final Set<String> _selectedIds = {};
  bool _isAllSelected = false;

  @override
  void dispose() {
    _maxQtyController.dispose();
    _breakupQtyController.dispose();
    _maxLotController.dispose();
    _breakupLotController.dispose();
    super.dispose();
  }

  void _onSelectAll(bool? value, List<UserQuantitySetting> allSettings) {
    setState(() {
      _isAllSelected = value ?? false;
      if (_isAllSelected) {
        _selectedIds.addAll(allSettings.map((e) => e.id));
      } else {
        _selectedIds.clear();
      }
    });
  }

  void _onRowSelect(bool? value, String id) {
    setState(() {
      if (value == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
        _isAllSelected = false;
      }
    });
  }

  void _onUpdate() {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to update'),
        ),
      );
      return;
    }

    final int? maxQty = int.tryParse(_maxQtyController.text);
    final int? breakupQty = int.tryParse(_breakupQtyController.text);
    final int? maxLot = int.tryParse(_maxLotController.text);
    final int? breakupLot = int.tryParse(_breakupLotController.text);

    context.read<UserQuantitySettingsBloc>().add(
      UpdateSelectedUserQuantitySetting(
        selectedIds: _selectedIds.toList(),
        maxQty: maxQty,
        breakupQty: breakupQty,
        maxLot: maxLot,
        breakupLot: breakupLot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        _buildGroupHeader(context),
        _buildRecordCount(context),
        Expanded(child: _buildTable(context)),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: BlocBuilder<UserQuantitySettingsBloc, UserQuantitySettingsState>(
        builder: (context, state) {
          List<String> symbols = [];
          String? selectedSymbol;

          if (state is UserQuantitySettingsLoaded) {
            symbols = state.metadata?.symbols ?? [];
            selectedSymbol = state.selectedSymbol;
          }

          return Column(
            children: [
              Row(
                children: [
                  AppDropdown(
                    hintText: 'Symbol',
                    items: symbols,
                    value: selectedSymbol,
                    onChanged: (val) {
                      context.read<UserQuantitySettingsBloc>().add(
                        FilterUserQuantitySettings(symbol: val),
                      );
                    },
                    width: 160.w,
                    height: 35.h,
                    type: AppDropdownType.search,
                    searchHint: 'Search & Add',
                  ),
                  const Spacer(),
                  UserResetButtons(
                    height: 35.h,
                    width: 100.w,
                    onReset: () {
                      context.read<UserQuantitySettingsBloc>().add(
                        const FilterUserQuantitySettings(symbol: null),
                      );
                      _maxQtyController.clear();
                      _breakupQtyController.clear();
                      _maxLotController.clear();
                      _breakupLotController.clear();
                      setState(() {
                        _selectedIds.clear();
                        _isAllSelected = false;
                      });
                    },
                    onView: () {},
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Row(
                children: [
                  CustomInputField(
                    hintText: 'Breakup Qty',
                    controller: _breakupQtyController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Max Qty',
                    controller: _maxQtyController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Breakup Lot',
                    controller: _breakupLotController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomInputField(
                    hintText: 'Max Lot',
                    controller: _maxLotController,
                    height: 35.h,
                    width: 160.w,
                  ),
                  const Spacer(),
                  CustomActionButton(
                    text: 'Update',
                    onPressed: _onUpdate,
                    width: 212.w,
                    height: 35.h,
                    backgroundColor: AppColors.primaryBlue,
                    borderRadius: 8.r,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFC6DBE8),
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'Group',
            style: GoogleFonts.openSans(
              fontSize: 10.sp,
              color: const Color(0xFF1F4A66),
            ),
          ),
          Text(
            widget.groupName ?? 'NSE_4X',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: BlocBuilder<UserQuantitySettingsBloc, UserQuantitySettingsState>(
        builder: (context, state) {
          int count = 0;
          if (state is UserQuantitySettingsLoaded) {
            count = state.filteredSettings.length;
          }
          return UserRecordCount(count: count);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<UserQuantitySettingsBloc, UserQuantitySettingsState>(
      builder: (context, state) {
        if (state is UserQuantitySettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserQuantitySettingsError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        List<UserQuantitySetting> settings = [];
        if (state is UserQuantitySettingsLoaded) {
          settings = state.filteredSettings;
        }

        return UserDataTable<UserQuantitySetting>(
          columns: [
            UserTableColumn(
              id: 'checkbox',
              label: '',
              width: 50.w,
              sortable: false,
              customHeader: Checkbox(
                value: _isAllSelected,
                onChanged: (val) => _onSelectAll(val, settings),
                activeColor: AppColors.primaryBlue,
                side: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 1.5,
                ),
              ),
            ),
            UserTableColumn(id: 'symbol', label: 'Symbol', width: 230.w),
            UserTableColumn(
              id: 'maxQty',
              label: 'Max Qty',
              width: 180.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'breakupQty',
              label: 'Breakup Qty',
              width: 150.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'maxLot',
              label: 'Max Lot',
              width: 180.w,
              isNumeric: true,
            ),
            UserTableColumn(
              id: 'breakupLot',
              label: 'Breakup Lot',
              width: 180.w,
              isNumeric: true,
            ),
          ],
          data: settings,
          idExtractor: (item) => item.id,
          cellBuilder: (item, column) {
            final isSelected = _selectedIds.contains(item.id);

            switch (column.id) {
              case 'checkbox':
                return Checkbox(
                  value: isSelected,
                  onChanged: (val) => _onRowSelect(val, item.id),
                  activeColor: AppColors.primaryBlue,
                  side: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 1.5,
                  ),
                );
              case 'symbol':
                return Text(item.symbol, style: _cellStyle(isBold: true));
              case 'maxQty':
                return Text(item.maxQty.toString(), style: _cellStyle());
              case 'breakupQty':
                return Text(item.breakupQty.toString(), style: _cellStyle());
              case 'maxLot':
                return Text(item.maxLot.toString(), style: _cellStyle());
              case 'breakupLot':
                return Text(item.breakupLot.toString(), style: _cellStyle());
              default:
                return const SizedBox();
            }
          },
        );
      },
    );
  }

  TextStyle _cellStyle({bool isBold = false}) {
    return GoogleFonts.openSans(
      fontSize: 12.sp,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      color: AppColors.primaryBlue,
    );
  }
}
