import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/market_watch_bloc.dart';
import '../bloc/market_watch_event.dart';
import '../bloc/market_watch_state.dart';
import 'market_table_row.dart';

/// Table body widget with scrollable list of market data rows
/// Displays filtered market items or empty state message
class MarketTableBody extends StatelessWidget {
  final MarketWatchLoaded state;
  final Function(Offset) onRightClick;

  const MarketTableBody({
    Key? key,
    required this.state,
    required this.onRightClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.filteredItems.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noDataAvailable,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeL,
            color: AppColors.supportiveTextColor(context),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.filteredItems.length,
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        final isSelected = state.selectedItemId == item.id;

        return MarketTableRow(
          item: item,
          isSelected: isSelected,
          index: index,
          onTap: () {
            context.read<MarketWatchBloc>().add(
              SelectMarketItemEvent(itemId: item.id),
            );
          },
          onRightClick: (position) {
            onRightClick(position);
            context.read<MarketWatchBloc>().add(
              SelectMarketItemEvent(itemId: item.id),
            );
          },
        );
      },
    );
  }
}
