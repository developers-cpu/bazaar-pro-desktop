import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/net_position/net_position_bloc.dart';
import '../../bloc/net_position/net_position_event.dart';
import '../../bloc/net_position/net_position_state.dart';
import '../../widget/net_position/net_position_filter_bar.dart';
import '../../widget/net_position/net_position_table.dart';


class NetPositionPage extends StatefulWidget {
  const NetPositionPage({Key? key}) : super(key: key);

  @override
  State<NetPositionPage> createState() => _NetPositionPageState();
}

class _NetPositionPageState extends State<NetPositionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NetPositionBloc>().add(const LoadNetPositionsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetPositionBloc, NetPositionState>(
      listener: _handleStateChange,
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            
            const NetPositionFilterBar(),

            
            Container(
              height: 1.h,
              color: AppColors.greyBorder,
            ),

            
            const Expanded(
              child: NetPositionTable(
                showDeviceInfo: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(BuildContext context, NetPositionState state) {
    if (state is NetPositionExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (state is NetPositionError) {
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