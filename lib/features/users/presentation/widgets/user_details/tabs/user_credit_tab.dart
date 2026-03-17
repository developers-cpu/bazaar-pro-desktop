import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/table/view_data_table.dart';
import '../../../../../../core/widget/table/view_record_count.dart';
import '../../../../../../core/widget/table/view_table_cell_styles.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_credit_transaction/user_credit_transaction.dart';
import '../../../bloc/user_credit/user_credit_bloc.dart';
import '../../../bloc/user_credit/user_credit_event.dart';
import '../../../bloc/user_credit/user_credit_state.dart';
import '../../../../../../injection_container.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../../core/widget/custom_action_button.dart';
import '../../../../../../core/widget/app_radio_button.dart';

class UserCreditTab extends StatelessWidget {
  final User user;
  const UserCreditTab({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserCreditBloc>()..add(LoadUserCredit(user.id)),
      child: const UserCreditTabView(),
    );
  }
}

class UserCreditTabView extends StatefulWidget {
  const UserCreditTabView({super.key});
  @override
  State<UserCreditTabView> createState() => _UserCreditTabViewState();
}

class _UserCreditTabViewState extends State<UserCreditTabView> {
  String _transactionType = 'Credit';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmountWords);
  }

  void _updateAmountWords() {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      _removeOverlay();
      return;
    }
    final value = double.tryParse(text);
    final words = value != null ? _toIndianWords(value) : null;
    if (words != null) {
      _showOverlay(words);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay(String words) {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 200.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 35.h + 4.h),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              width: 200.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFCCCCCC)),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                words,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _toIndianWords(double amount) {
    if (amount == 0) return 'zero';
    final intPart = amount.toInt();
    final decimalPart = ((amount - intPart) * 100).round();
    String result = _intToWords(intPart);
    if (decimalPart > 0) result += ' point ${_intToWords(decimalPart)}';
    return result;
  }

  String _intToWords(int n) {
    if (n == 0) return '';
    const ones = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];
    if (n < 20) return ones[n];
    if (n < 100) return tens[n ~/ 10] + (n % 10 != 0 ? ' ${ones[n % 10]}' : '');
    if (n < 1000)
      return '${ones[n ~/ 100]} hundred${n % 100 != 0 ? ' ${_intToWords(n % 100)}' : ''}';
    if (n < 100000)
      return '${_intToWords(n ~/ 1000)} thousand${n % 1000 != 0 ? ' ${_intToWords(n % 1000)}' : ''}';
    if (n < 10000000)
      return '${_intToWords(n ~/ 100000)} lac${n % 100000 != 0 ? ' ${_intToWords(n % 100000)}' : ''}';
    return '${_intToWords(n ~/ 10000000)} crore${n % 10000000 != 0 ? ' ${_intToWords(n % 10000000)}' : ''}';
  }

  @override
  void dispose() {
    _removeOverlay();
    _amountController.removeListener(_updateAmountWords);
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    context.read<UserCreditBloc>().add(
      AddCreditTransaction(
        type: _transactionType,
        amount: amount,
        comment: _commentController.text,
      ),
    );
    _amountController.clear();
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCreditBloc, UserCreditState>(
      builder: (context, state) {
        if (state is UserCreditLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserCreditError) {
          return Center(child: Text(state.message));
        }
        if (state is UserCreditLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildFilterBar(context),
              _buildRecordCount(context, state),
              Expanded(child: _buildTable(context, state)),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: AppColors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadioButton<String>(
            value: 'Credit',
            groupValue: _transactionType,
            label: 'Credit',
            onChanged: (val) {
              setState(() {
                _transactionType = val!;
              });
            },
            activeColor: const Color(0xFF1F4A66),
            labelColor: AppColors.textGrey,
          ),
          SizedBox(width: 16.w),
          AppRadioButton<String>(
            value: 'Debit',
            groupValue: _transactionType,
            label: 'Debit',
            onChanged: (val) {
              setState(() {
                _transactionType = val!;
              });
            },
            activeColor: const Color(0xFF1F4A66),
            labelColor: AppColors.textGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.white,
      child: Row(
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: CustomInputField(
              controller: _amountController,
              hintText: 'Amount',
              height: 35.h,
              width: 200.w,
            ),
          ),
          SizedBox(width: 8.w),
          CustomInputField(
            controller: _commentController,
            hintText: 'Comment',
            height: 35.h,
            width: 200.w,
          ),
          const Spacer(),
          CustomActionButton(
            text: 'Submit',
            onPressed: _onSubmit,
            width: 212.w,
            height: 35.h,
            backgroundColor: AppColors.primaryBlue,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCount(BuildContext context, UserCreditLoaded state) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      child: ViewRecordCount(count: state.transactions.length),
    );
  }

  Widget _buildTable(BuildContext context, UserCreditLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ViewDataTable<UserCreditTransaction>(
      autoFit: true,
      columns: [
        ViewTableColumn(id: 'date', label: 'DATE TIME', width: 200.w),
        ViewTableColumn(id: 'type', label: 'TYPE', width: 100.w),
        ViewTableColumn(
          id: 'amount',
          label: 'AMOUNT',
          width: 200.w,
          isNumeric: true,
        ),
        ViewTableColumn(
          id: 'balance',
          label: 'BALANCE',
          width: 200.w,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'comment', label: 'COMMENT', width: 250.w),
      ],
      footerBuilder: (columns) {
        return Container(
          height: 35.h,
          child: Row(
            children: columns.asMap().entries.map((entry) {
              final index = entry.key;
              final column = entry.value;
              final isLast = index == columns.length - 1;

              Widget content;
              if (column.id == 'date') {
                content = Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 12.w),
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else if (column.id == 'amount') {
                content = Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 12.w),
                  child: Text(
                    state.totalBalance.toStringAsFixed(2),
                    style: TextStyle(fontSize: 13.sp, color: AppColors.blue),
                  ),
                );
              } else {
                content = const SizedBox();
              }

              return Container(
                width: column.width,
                height: 35.h,
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          right: BorderSide(color: Colors.white, width: 2),
                        ),
                ),
                child: content,
              );
            }).toList(),
          ),
        );
      },
      data: state.transactions,
      idExtractor: (item) => item.id,
      comparatorBuilder: (item, columnId) {
        switch (columnId) {
          case 'date':
            return item.dateTime;
          case 'type':
            return item.type;
          case 'amount':
            return item.amount;
          case 'balance':
            return item.balance;
          case 'comment':
            return item.comment;
          default:
            return '';
        }
      },
      cellBuilder: (item, column) {
        final isDebit = item.type == 'Debit';
        final color = isDebit ? AppColors.sellColor : AppColors.buyColor;
        switch (column.id) {
          case 'date':
            return ViewDateTimeCell(dateTime: item.dateTime, isDark: isDark);
          case 'type':
            return ViewTextCell(text: item.type, color: color, isDark: isDark);
          case 'amount':
            return ViewNumberCell(
              value: item.amount,
              fixedColor: color,
              isDark: isDark,
            );
          case 'balance':
            return ViewNumberCell(
              value: item.balance,
              colorByValue: false,
              isDark: isDark,
            );
          case 'comment':
            return ViewTextCell(text: item.comment, isDark: isDark);
          default:
            return const SizedBox();
        }
      },
    );
  }
}
