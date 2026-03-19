import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_dropdown.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../../../core/widget/custom_outlined_button.dart';
import '../../../../../core/widget/table/success_dialog.dart';
import '../../../../../core/widget/table/view_data_table.dart';
import '../../../../../core/widget/table/view_record_count.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bazarpro/features/auth/presentation/bloc/auth_state.dart';
import '../../../../../core/widget/table/view_table_cell_styles.dart';

class RollOverDialog {
  static void show({required BuildContext context}) {
    CommonDialog.show(
      context: context,
      title: 'Roll Over',
      width: 650.w,
      height: 600.h,
      showButtons: false,
      contentPadding: EdgeInsets.zero,
      scrollable: false,
      content: _RollOverDialogContent(pageContext: context),
    );
  }
}

class _RollOverDialogContent extends StatefulWidget {
  final BuildContext pageContext;
  const _RollOverDialogContent({Key? key, required this.pageContext})
    : super(key: key);
  @override
  State<_RollOverDialogContent> createState() => _RollOverDialogContentState();
}

class _RollOverDialogContentState extends State<_RollOverDialogContent> {
  String _selectedExchange = 'Exchange';
  String _selectedSymbol = 'Symbol';
  final Color headerColor = AppColors.primaryBlue;
  Set<int> _selectedIndices = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
  };
  bool _selectAll = true;
  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedIndices = Set.from(List.generate(15, (index) => index));
      } else {
        _selectedIndices.clear();
      }
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        _selectAll = false;
      } else {
        _selectedIndices.add(index);
        if (_selectedIndices.length == 15) {
          _selectAll = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isClient =
        authState is AuthAuthenticated &&
        authState.user.role.toLowerCase() == 'client';
    return Column(
      children: [
        if (!isClient)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    type: AppDropdownType.simple,
                    value: _selectedExchange,
                    hintText: 'Exchange',
                    items: const [
                      'NSE',
                      'MCX',
                      'CE/PE',
                      'OTHERS',
                      'COMEX',
                      'CRYPTO',
                      'GIFT',
                      'FOREX',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedExchange = val);
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 200.w,
                  child: AppDropdown(
                    type: AppDropdownType.search,
                    value: _selectedSymbol,
                    hintText: 'Symbol',
                    items: const [
                      'GIFTNIFTY Oct 28',
                      'NIFTY Oct 28',
                      'BANKNIFTY Oct 28',
                      'MINI GOLDMINI Dec 05',
                      'MINI SILVERMINI Dec 05',
                      'DOW Dec 19',
                      'NASDAQ Dec 19',
                      'S & P Dec 19',
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSymbol = val);
                    },
                  ),
                ),
              ],
            ),
          ),
        ViewRecordCount(count: 15),
        Expanded(child: _buildTable()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ViewDataTable<int>(
              columns: _getColumns(),
              data: List.generate(15, (index) => index),
              idExtractor: (item) => item.toString(),
              comparatorBuilder: (item, columnId) {
                return item;
              },
              cellBuilder: (item, column) => _buildCell(item, column),
              isDarkMode: false,
              autoFit: true,
            ),
          ),
        ),
      ],
    );
  }

  List<ViewTableColumn> _getColumns() {
    return [
      ViewTableColumn(
        id: 'select',
        label: '',
        width: 40.w,
        sortable: false,
        customHeaderWidget: GestureDetector(
          onTap: _toggleSelectAll,
          child: _buildCheckbox(_selectAll),
        ),
      ),
      ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80.w),
      ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 100.w),
      ViewTableColumn(id: 'qty', label: 'QTY', width: 90.w, isNumeric: true),
      ViewTableColumn(id: 'cmp', label: 'CMP', width: 150.w, isNumeric: true),
      ViewTableColumn(
        id: 'rollOverPrice',
        label: 'ROLL OVER PRICE',
        width: 150.w,
        isNumeric: true,
      ),
    ];
  }

  Widget _buildCell(int index, ViewTableColumn column) {
    bool isEven = index % 2 == 0;
    bool isPositive = isEven;
    String qty = index == 0 ? '1000' : (isPositive ? '1.00' : '-1.00');
    Color qtyColor = index == 0
        ? AppColors.blue
        : (isPositive ? AppColors.blue : AppColors.red);
    String cmp = isPositive ? '124536.00' : '-124191.00';
    Color cmpColor = isPositive ? AppColors.blue : AppColors.red;
    switch (column.id) {
      case 'select':
        return Center(
          child: GestureDetector(
            onTap: () => _toggleSelection(index),
            child: _buildCheckbox(_selectedIndices.contains(index)),
          ),
        );
      case 'exchange':
        return ViewTextCell(text: 'MCX');
      case 'symbol':
        return ViewTextCell(text: 'GOLD05DEC');
      case 'qty':
        return ViewNumberCell(
          value: double.tryParse(qty) ?? 0.0,
          displayText: qty,
          fixedColor: qtyColor,
        );
      case 'cmp':
        return ViewNumberCell(
          value: double.tryParse(cmp) ?? 0.0,
          displayText: cmp,
          fixedColor: cmpColor,
        );
      case 'rollOverPrice':
        return ViewNumberCell(
          value: double.tryParse(cmp) ?? 0.0,
          displayText: cmp,
          fixedColor: cmpColor,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckbox(bool value) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: value ? headerColor : Colors.transparent,
        border: Border.all(
          color: value ? headerColor : AppColors.greyBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: value ? Icon(Icons.check, size: 14.sp, color: Colors.white) : null,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Center(
        child: SizedBox(
          width: 400.w,
          height: 40.h,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    width: 650.w,
                    height: 550.h,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: _buildConfirmationContent(context),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: headerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Roll Over',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationContent(BuildContext dialogContext) {
    final selectedList = _selectedIndices.toList();
    return Column(
      children: [
        Text(
          'Roll over All Positions',
          style: GoogleFonts.openSans(fontSize: 22.sp, color: headerColor),
        ),
        SizedBox(height: 8.h),
        Text(
          'Are You Sure you want to Roll over all Positions ?',
          style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 10.h),
        ViewRecordCount(count: selectedList.length),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ViewDataTable<int>(
              columns: const [
                ViewTableColumn(id: 'exchange', label: 'EXCH', width: 80),
                ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 100),
                ViewTableColumn(
                  id: 'qty',
                  label: 'QTY',
                  width: 90,
                  isNumeric: true,
                ),
                ViewTableColumn(
                  id: 'cmp',
                  label: 'CMP',
                  width: 140,
                  isNumeric: true,
                ),
                ViewTableColumn(
                  id: 'rollOverPrice',
                  label: 'ROLL OVER PRICE',
                  width: 140,
                  isNumeric: true,
                ),
              ],
              data: selectedList,
              idExtractor: (item) => item.toString(),
              cellBuilder: (item, column) =>
                  _buildConfirmationCell(item, column),
              isDarkMode: false,
              autoFit: true,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: CustomOutlinedActionButton(
                  text: 'No',
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  borderColor: headerColor,
                  textColor: headerColor,
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomActionButton(
                  text: 'Yes',
                  height: 40.h,
                  borderRadius: 8.r,
                  fontSize: 14.sp,
                  backgroundColor: headerColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Future.delayed(Duration.zero, () {
                      SuccessDialog.show(
                        context: widget.pageContext,
                        title: 'Successful !',
                        subtitle:
                            'Selected Position are Successfully Rolled over',
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationCell(int sourceIndex, ViewTableColumn column) {
    bool isPositive = sourceIndex % 2 == 0;
    String qty = sourceIndex == 0 ? '1000' : (isPositive ? '1.00' : '-1.00');
    Color qtyColor = sourceIndex == 0
        ? AppColors.blue
        : (isPositive ? AppColors.blue : AppColors.red);
    String cmp = isPositive ? '124536.00' : '-124191.00';
    Color cmpColor = isPositive ? AppColors.blue : AppColors.red;
    switch (column.id) {
      case 'exchange':
        return ViewTextCell(text: 'MCX', color: Colors.black87);
      case 'symbol':
        return ViewTextCell(text: 'GOLD05DEC', color: Colors.black87);
      case 'qty':
        return ViewNumberCell(
          value: double.tryParse(qty) ?? 0.0,
          displayText: qty,
          fixedColor: qtyColor,
        );
      case 'cmp':
        return ViewNumberCell(
          value: double.tryParse(cmp) ?? 0.0,
          displayText: cmp,
          fixedColor: cmpColor,
        );
      case 'rollOverPrice':
        return ViewNumberCell(
          value: double.tryParse(cmp) ?? 0.0,
          displayText: cmp,
          fixedColor: cmpColor,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}