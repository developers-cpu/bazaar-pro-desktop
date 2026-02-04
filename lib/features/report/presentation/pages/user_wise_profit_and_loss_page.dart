import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../injection_container.dart';
import '../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_bloc.dart';
import '../bloc/user_wise_profit_and_loss/user_wise_profit_and_loss_event.dart';
import '../widgets/user_wise_profit_and_loss/user_wise_profit_and_loss_filter_bar.dart';
import '../widgets/user_wise_profit_and_loss/user_wise_profit_and_loss_table.dart';
class UserWiseProfitAndLossPage extends StatelessWidget {
  const UserWiseProfitAndLossPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<UserWiseProfitAndLossBloc>()..add(LoadUserWiseProfitAndLoss()),
      child: Column(
        children: [
          const UserWiseProfitAndLossFilterBar(),
          Expanded(child: const UserWiseProfitAndLossReportTable()),
        ],
      ),
    );
  }
}
