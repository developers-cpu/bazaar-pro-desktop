import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widget/app_dropdown.dart';
import '../../bloc/broker_list/broker_list_bloc.dart';
import '../../bloc/broker_list/broker_list_event.dart';
import '../../bloc/broker_list/broker_list_state.dart';
import '../../../../../core/widget/table/view_reset_buttons.dart';
import '../../../../../core/widget/table/view_record_count.dart';

class BrokerListFilterBar extends StatelessWidget {
  const BrokerListFilterBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrokerListBloc, BrokerListState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: AppDropdown(
                      type: AppDropdownType.search,
                      hintText: 'Search Broker',
                      items: const [
                        'User 1',
                        'User 2',
                        'User 3',
                        'User 4',
                        'User 5',
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                  const Spacer(),
                  ViewResetButtons(
                    onReset: () {
                      context.read<BrokerListBloc>().add(
                        const LoadBrokersEvent(),
                      );
                    },
                    onView: () {},
                  ),
                ],
              ),
              ViewRecordCount(
                count: state is BrokerListLoaded
                    ? state.brokers.length
                    : state is BrokerClientsLoaded
                    ? state.brokers.length
                    : 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
