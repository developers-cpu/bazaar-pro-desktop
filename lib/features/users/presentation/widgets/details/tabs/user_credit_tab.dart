import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/custom_input_field.dart';
import '../../../../../users/domain/entities/user.dart';
import '../../common/user_record_count.dart';

class UserCreditTab extends StatefulWidget {
  final User user;

  const UserCreditTab({super.key, required this.user});

  @override
  State<UserCreditTab> createState() => _UserCreditTabState();
}

class _UserCreditTabState extends State<UserCreditTab> {
  String _transactionType = 'Credit'; // Credit or Debit
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Mock Data
  final List<Map<String, dynamic>> _transactions = [
    {
      'date': '04/11/25 03:06:34 PM',
      'type': 'Debit',
      'amount': -500000.00,
      'balance': 5000000.00,
      'comment': 'Initial Debit',
    },
    {
      'date': '04/11/25 03:06:34 PM',
      'type': 'Credit',
      'amount': 5500000.00,
      'balance': 5500000.00,
      'comment': 'Initial Debit',
    },
    {
      'date': '04/11/25 03:06:34 PM',
      'type': 'Debit',
      'amount': -500000.00,
      'balance': 0.00,
      'comment': 'Initial Debit',
    },
    {
      'date': '04/11/25 03:06:34 PM',
      'type': 'Credit',
      'amount': 500000.00,
      'balance': 500000.00,
      'comment': 'Initial Credit',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioButtons(),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInputField(
                      controller: _amountController,
                      hintText: 'Enter Amount',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 4,
                    child: CustomInputField(
                      controller: _commentController,
                      hintText: 'Enter Comment',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    height: 48.h, // Match input field height roughly
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          alignment: Alignment.centerRight,
          child: UserRecordCount(count: 12550),
        ),
        Expanded(child: _buildTable()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Row(
      children: [
        _buildRadio('Credit'),
        SizedBox(width: 16.w),
        _buildRadio('Debit'),
      ],
    );
  }

  Widget _buildRadio(String value) {
    return GestureDetector(
      onTap: () => setState(() => _transactionType = value),
      child: Row(
        children: [
          Icon(
            _transactionType == value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: AppColors.primaryBlue,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return _buildTableRow(transaction, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('DATE TIME', flex: 2),
          _buildHeaderCell('TYPE', flex: 1),
          _buildHeaderCell('AMOUNT', flex: 1),
          _buildHeaderCell('BALANCE', flex: 1),
          _buildHeaderCell('COMMENT', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> transaction, int index) {
    final isDebit = transaction['type'] == 'Debit';
    final typeColor = isDebit ? AppColors.errorColor : AppColors.primaryBlue;
    final amountColor = isDebit ? AppColors.errorColor : AppColors.primaryBlue;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          _buildCell(transaction['date'], flex: 2),
          _buildCell(
            transaction['type'],
            flex: 1,
            color: typeColor,
            fontWeight: FontWeight.bold,
          ),
          _buildCell(
            transaction['amount'].toStringAsFixed(2),
            flex: 1,
            color: amountColor,
          ),
          _buildCell(transaction['balance'].toStringAsFixed(2), flex: 1),
          _buildCell(transaction['comment'], flex: 2),
        ],
      ),
    );
  }

  Widget _buildCell(
    String text, {
    int flex = 1,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.openSans(
            fontSize: 11.sp,
            fontWeight: fontWeight ?? FontWeight.w500,
            color: color ?? AppColors.textColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          _buildCell('Total', flex: 2, fontWeight: FontWeight.bold),
          Expanded(flex: 1, child: SizedBox()), // Type
          _buildCell(
            '6000000.00',
            flex: 1,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
          Expanded(flex: 1, child: SizedBox()), // Balance
          Expanded(flex: 2, child: SizedBox()), // Comment
        ],
      ),
    );
  }
}
