import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/app_radio_button.dart';
import '../../../../../../injection_container.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import 'package:bazarpro/features/users/domain/entities/user.dart';
import '../../../../domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import '../../../bloc/user_brokerage/user_brokerage_bloc.dart';
import '../../../bloc/user_brokerage/user_brokerage_event.dart';
import '../../../bloc/user_brokerage/user_brokerage_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';

class UserBrokerageTab extends StatelessWidget {
  final User user;

  const UserBrokerageTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<UserBrokerageBloc>()..add(LoadUserBrokerage(user.id)),
      child: const UserBrokerageTabView(),
    );
  }
}

class UserBrokerageTabView extends StatefulWidget {
  const UserBrokerageTabView({super.key});

  @override
  State<UserBrokerageTabView> createState() => _UserBrokerageTabViewState();
}

class _UserBrokerageTabViewState extends State<UserBrokerageTabView> {
  final TextEditingController _exchangeBrkController = TextEditingController();
  final TextEditingController _symbolBrkController = TextEditingController();

  final Set<String> _selectedIds = {};
  bool _isAllSelected = false;

  @override
  void dispose() {
    _exchangeBrkController.dispose();
    _symbolBrkController.dispose();
    super.dispose();
  }

  void _onSelectAll(bool? value, List<UserBrokerageSetting> allSettings) {
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

  void _onUpdate(String viewType) {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select items to update')),
      );
      return;
    }

    double? turnoverBrk;
    double? symbolBrk = double.tryParse(_symbolBrkController.text);

    if (viewType == 'Exchange') {
      turnoverBrk = double.tryParse(_exchangeBrkController.text);
    }

    context.read<UserBrokerageBloc>().add(
      UpdateBrokerageSettings(
        selectedIds: _selectedIds.toList(),
        turnoverWiseBrk: turnoverBrk,
        symbolWiseBrk: symbolBrk,
      ),
    );

    _exchangeBrkController.clear();
    _symbolBrkController.clear();
    setState(() {
      _selectedIds.clear();
      _isAllSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBrokerageBloc, UserBrokerageState>(
      builder: (context, state) {
        if (state is UserBrokerageLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserBrokerageLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
              _buildFilterBar(context, state),
              _buildRecordCount(context, state),
              _buildTable(context, state),
            ],
          );
        }

        if (state is UserBrokerageError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildFilterBar(BuildContext context, UserBrokerageLoaded state) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: Row(
        children: [
          AppDropdown(
            hintText: 'Exchange',
            items: state.exchanges,
            value: state.selectedExchange,
            onChanged: (val) {
              context.read<UserBrokerageBloc>().add(
                FilterBrokerage(exchange: val),
              );
            },
            width: 200.w,
            height: 35.h,
            type: AppDropdownType.simple,
          ),
          SizedBox(width: 8.w),
          if (state.viewType == 'Exchange')
            CustomInputField(
              hintText: 'Type exchange wise brk',
              controller: _exchangeBrkController,
              height: 35.h,
              width: 200.w,
            )
          else
            CustomInputField(
              hintText: 'Type brokerage price',
              controller: _symbolBrkController,
              height: 35.h,
              width: 200.w,
            ),
          const Spacer(),
          CustomActionButton(
            text: 'Update',
            onPressed: () => _onUpdate(state.viewType),
            width: 212.w,
            height: 35.h,
            backgroundColor: AppColors.primaryBlue,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserBrokerageLoaded state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: AppColors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadioButton<String>(
            value: 'Exchange',
            groupValue: state.viewType,
            label: 'Exchange Wise',
            onChanged: (val) {
              context.read<UserBrokerageBloc>().add(ToggleBrokerageType(val!));
              _exchangeBrkController.clear();
              _symbolBrkController.clear();
              setState(() {
                _selectedIds.clear();
                _isAllSelected = false;
              });
            },
            activeColor: const Color(0xFF1F4A66),
            labelColor: AppColors.textGrey,
          ),
          SizedBox(width: 16.w),
          AppRadioButton<String>(
            value: 'Symbol',
            groupValue: state.viewType,
            label: 'Symbol Wise',
            onChanged: (val) {
              context.read<UserBrokerageBloc>().add(ToggleBrokerageType(val!));
              _exchangeBrkController.clear();
              _symbolBrkController.clear();
              setState(() {
                _selectedIds.clear();
                _isAllSelected = false;
              });
            },
            activeColor: const Color(0xFF1F4A66),
            labelColor: AppColors.textGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context, UserBrokerageLoaded state) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: UserRecordCount(count: state.filteredSettings.length),
    );
  }

  Widget _buildTable(BuildContext context, UserBrokerageLoaded state) {
    final isExchangeWise = state.viewType == 'Exchange';

    return Expanded(
      child: UserDataTable<UserBrokerageSetting>(
        columns: [
          UserTableColumn(
            id: 'checkbox',
            label: '',
            width: 50.w,
            sortable: false,
            customHeader: Checkbox(
              value: _isAllSelected,
              onChanged: (val) => _onSelectAll(val, state.filteredSettings),
              activeColor: AppColors.primaryBlue,
              side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
          ),
          UserTableColumn(id: 'exchange', label: 'EXCHANGE', width: 320.w),

          if (isExchangeWise)
            UserTableColumn(
              id: 'turnover',
              label: 'TURNOVER WISE (Rs.PER1/CR)',
              width: 320.w,
              isNumeric: true,
            )
          else
            UserTableColumn(id: 'symbol', label: 'SYMBOL', width: 320.w),

          UserTableColumn(
            id: 'symbolBrk',
            label: 'SYMBOL WISE BRK (Rs.)',
            width: 320.w,
            isNumeric: true,
          ),
        ],
        data: state.filteredSettings,
        idExtractor: (item) => item.id,
        cellBuilder: (item, column) {
          final isSelected = _selectedIds.contains(item.id);
          final commonStyle = GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          );

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
            case 'exchange':
              return Text(item.exchange, style: commonStyle);
            case 'turnover':
              return Text(
                item.turnoverWiseBrk.toStringAsFixed(0),
                style: commonStyle,
              );
            case 'symbol':
              return Text(item.symbol ?? '-', style: commonStyle);
            case 'symbolBrk':
              return Text(
                item.symbolWiseBrk.toStringAsFixed(0),
                style: commonStyle,
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
