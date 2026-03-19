import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/broker_list/broker_list_bloc.dart';
import '../../bloc/broker_list/broker_list_event.dart';
import '../../widget/broker_list/broker_list_filter_bar.dart';
import '../../widget/broker_list/broker_list_table.dart';

class BrokerListPage extends StatefulWidget {
  final bool isDarkMode;
  const BrokerListPage({Key? key, this.isDarkMode = false}) : super(key: key);
  @override
  State<BrokerListPage> createState() => _BrokerListPageState();
}

class _BrokerListPageState extends State<BrokerListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrokerListBloc>().add(const LoadBrokersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          const BrokerListFilterBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BrokerListTable(isDarkMode: widget.isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
}