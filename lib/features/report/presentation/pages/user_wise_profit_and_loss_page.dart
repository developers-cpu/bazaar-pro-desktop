import 'package:flutter/material.dart';
import '../widgets/user_wise_profit_and_loss/user_wise_profit_and_loss_filter_bar.dart';
import '../widgets/user_wise_profit_and_loss/user_wise_profit_and_loss_table.dart';

class UserWiseProfitAndLossPage extends StatelessWidget {
  const UserWiseProfitAndLossPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserWiseProfitAndLossFilterBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const UserWiseProfitAndLossReportTable(),
          ),
        ),
      ],
    );
  }
}
