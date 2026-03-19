import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/login_history/login_history_bloc.dart';
import '../../bloc/login_history/login_history_event.dart';
import '../../bloc/login_history/login_history_state.dart';
import '../../widget/login_history/login_history_filter_bar.dart';
import '../../widget/login_history/login_history_table.dart';

class LoginHistoryPage extends StatefulWidget {
  const LoginHistoryPage({Key? key}) : super(key: key);
  @override
  State<LoginHistoryPage> createState() => _LoginHistoryPageState();
}

class _LoginHistoryPageState extends State<LoginHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginHistoryBloc>().add(const LoadClientsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginHistoryBloc, LoginHistoryState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            const LoginHistoryFilterBar(),
            BlocBuilder<LoginHistoryBloc, LoginHistoryState>(
              builder: (context, state) {
                if (state is LoginHistoryLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  );
                }
                if (state is LoginHistoryLoaded && state.showTable) {
                  return const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: LoginHistoryTable(),
                    ),
                  );
                }
                return const Spacer();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, LoginHistoryState state) {
    if (state is LoginHistoryExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (state is LoginHistoryError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}