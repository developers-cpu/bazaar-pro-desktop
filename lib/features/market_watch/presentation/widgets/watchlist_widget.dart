import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/watchlist/watch_list_bloc.dart';
import '../bloc/watchlist/watch_list_event.dart';
import '../bloc/watchlist/watchlist_state.dart';

class WatchlistWidget extends StatelessWidget {
  final Function(int)? onWatchlistSelected;

  const WatchlistWidget({
    Key? key,
    this.onWatchlistSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistBloc, WatchlistState>(
      listener: _handleStateChange,
      builder: (context, state) {
        if (state is WatchlistInitial) {
          context.read<WatchlistBloc>().add(const LoadWatchlistsEvent());
          return _buildLoadingState();
        }

        if (state is WatchlistLoaded) {
          return _buildLoadedState(context, state);
        }

        if (state is WatchlistSuccess) {
          return _buildLoadedState(context, state.previousState);
        }

        return _buildLoadingState();
      },
    );
  }

  void _handleStateChange(BuildContext context, WatchlistState state) {
    if (state is WatchlistError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.message,
            style: TextStyle(fontSize: 14.sp),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }

    if (state is WatchlistLoaded) {
      onWatchlistSelected?.call(state.selectedIndex);
    }
  }

  Widget _buildLoadingState() {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, WatchlistLoaded state) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAddButton(context),
          SizedBox(width: 10.w),

          _buildWatchlistButton(
            context: context,
            label: AppStrings.all,
            index: -1,
            isSelected: state.selectedIndex == -1,
            showCloseIcon: false,
          ),
          SizedBox(width: 10.w),

          ...List.generate(state.watchlists.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: _buildWatchlistButton(
                context: context,
                label: state.watchlists[index],
                index: index,
                isSelected: state.selectedIndex == index,
                showCloseIcon: true,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<WatchlistBloc>().add(const AddWatchlistEvent());
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 135.w,
        height: 42.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 1.2.w,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 14.sp,
                  color: AppColors.white,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            Text(
              AppStrings.add,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.white,
                letterSpacing: 0.15,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistButton({
    required BuildContext context,
    required String label,
    required int index,
    required bool isSelected,
    required bool showCloseIcon,
  }) {
    return InkWell(
      onTap: () {
        context.read<WatchlistBloc>().add(SelectWatchlistEvent(index: index));
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 135.w,
        height: 42.h,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
          left: 10.w,
          right: showCloseIcon ? 5.w : 10.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: AppColors.primaryBlue,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.15,
                  height: 1.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showCloseIcon) ...[
              SizedBox(width: 4.w),
              InkWell(
                onTap: () {
                  context
                      .read<WatchlistBloc>()
                      .add(RemoveWatchlistEvent(index: index));
                },
                borderRadius: BorderRadius.circular(9.r),
                child: Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue,
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 12.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}