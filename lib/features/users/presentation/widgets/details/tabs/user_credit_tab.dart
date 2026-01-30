import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/user_credit_transaction.dart';
import '../../../bloc/user_credit/user_credit_bloc.dart';
import '../../../bloc/user_credit/user_credit_event.dart';
import '../../../bloc/user_credit/user_credit_state.dart';
import '../../common/user_data_table.dart';
import '../../common/user_record_count.dart';
import '../../common/user_update_button.dart';

class UserCreditTab extends StatelessWidget {
  final User user;

  const UserCreditTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCreditBloc()..add(LoadUserCredit(user.id)),
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
  final DateFormat _dateFormat = DateFormat('dd/MM/yy hh:mm:ss a');

  @override
  void dispose() {
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
              _buildControls(context, state),
              Expanded(child: _buildTable(context, state)),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildControls(BuildContext context, UserCreditLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildRadio('Credit'),
              SizedBox(width: 16.w),
              _buildRadio('Debit'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(
                width: 200.w, // Fixed width
                child: CustomInputField(
                  controller: _amountController,
                  hintText: 'Amount',
                  height: 35.h, // Fixed height
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 250.w, // Fixed width
                child: CustomInputField(
                  controller: _commentController,
                  hintText: 'Comment',
                  height: 35.h, // Fixed height
                ),
              ),

              const Spacer(),

              UserUpdateButton(onPressed: _onSubmit, label: 'Submit'),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: UserRecordCount(count: state.transactions.length),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _transactionType,
          onChanged: (val) {
            setState(() {
              _transactionType = val!;
            });
          },
          visualDensity: VisualDensity.compact,
          activeColor: const Color(0xFF1F4A66),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, UserCreditLoaded state) {
    return UserDataTable<UserCreditTransaction>(
      headerColor: AppColors.primaryBlue.withOpacity(0.2),
      columns: [
        UserTableColumn(id: 'date', label: 'DATE TIME', width: 200.w),
        UserTableColumn(id: 'type', label: 'TYPE', width: 100.w),
        UserTableColumn(
          id: 'amount',
          label: 'AMOUNT',
          width: 200.w,
          isNumeric: true,
        ),
        UserTableColumn(
          id: 'balance',
          label: 'BALANCE',
          width: 200.w,
          isNumeric: true,
        ),
        UserTableColumn(id: 'comment', label: 'COMMENT', width: 250.w),
      ],
      data: state.transactions,
      idExtractor: (item) => item.id,
      cellBuilder: (item, column) {
        final isDebit = item.type == 'Debit';
        final color = isDebit ? AppColors.errorColor : AppColors.primaryBlue;
        final commonStyle = GoogleFonts.openSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        );

        switch (column.id) {
          case 'date':
            return Text(_dateFormat.format(item.dateTime), style: commonStyle);
          case 'type':
            return Text(
              item.type,
              style: commonStyle.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
          case 'amount':
            return Text(
              item.amount.toStringAsFixed(2),
              style: commonStyle.copyWith(color: color),
            );
          case 'balance':
            return Text(
              item.balance.toStringAsFixed(2),
              style: commonStyle.copyWith(color: AppColors.textColor(context)),
            );
          case 'comment':
            return Text(
              item.comment,
              style: commonStyle.copyWith(color: AppColors.textColor(context)),
            );
          default:
            return const SizedBox();
        }
      },
      footerBuilder: (columns) => _buildFooter(columns, state.totalBalance),
    );
  }

  Widget _buildFooter(List<UserTableColumn> columns, double totalBalance) {
    return Row(
      children: columns.map((column) {
        if (column.id == 'date') {
          return Container(
            width: column.width,
            alignment: Alignment.center,
            child: Text(
              'Total',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          );
        }

        if (column.id == 'amount') {
          return Container(
            width: column.width,
            alignment: Alignment.center,
            child: Text(
              totalBalance.toStringAsFixed(2),
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          );
        }

        return SizedBox(width: column.width);
      }).toList(),
    );
  }
}
