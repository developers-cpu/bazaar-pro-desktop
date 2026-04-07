import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'market_open_section.dart';
import '../bloc/watchlist/watch_list_bloc.dart';
import '../bloc/watchlist/watch_list_event.dart';
import '../bloc/watchlist/watchlist_state.dart';

class WatchlistWidget extends StatelessWidget {
  final Function(int)? onWatchlistSelected;
  const WatchlistWidget({Key? key, this.onWatchlistSelected}) : super(key: key);
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
          content: Text(state.message, style: TextStyle(fontSize: 14.sp)),
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
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      color: AppColors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildLoadedState(BuildContext context, WatchlistLoaded state) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAddButton(context),
                SizedBox(width: 4.w),
                _buildWatchlistButton(
                  context: context,
                  label: AppStrings.all,
                  index: -1,
                  isSelected: state.selectedIndex == -1,
                  showCloseIcon: false,
                ),
                SizedBox(width: 4.w),
                ...List.generate(state.watchlists.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 4.w),
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
          ),
          SizedBox(width: 12.w),
          const MarketOpenSection(),
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
        width: 95.w,
        height: 26.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 13.w,
              height: 13.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.w),
              ),
              child: Center(
                child: Icon(Icons.add, size: 9.sp, color: AppColors.white),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              AppStrings.add,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
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
    return _WatchlistTab(
      blocContext: context,
      label: label,
      index: index,
      isSelected: isSelected,
      showCloseIcon: showCloseIcon,
    );
  }
}

class _WatchlistTab extends StatefulWidget {
  final BuildContext blocContext;
  final String label;
  final int index;
  final bool isSelected;
  final bool showCloseIcon;
  const _WatchlistTab({
    Key? key,
    required this.blocContext,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.showCloseIcon,
  }) : super(key: key);
  @override
  State<_WatchlistTab> createState() => _WatchlistTabState();
}

class _WatchlistTabState extends State<_WatchlistTab> {
  bool _isEditing = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.label);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _saveAndExitEditMode();
      }
    });
  }

  @override
  void didUpdateWidget(_WatchlistTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.label != widget.label) {
      _controller.text = widget.label;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveAndExitEditMode() {
    if (_isEditing) {
      final newName = _controller.text.trim();
      if (newName.isNotEmpty && newName != widget.label) {
        widget.blocContext.read<WatchlistBloc>().add(
          RenameWatchlistEvent(index: widget.index, newName: newName),
        );
      } else {
        _controller.text = widget.label;
      }
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _showEditMenu(Offset globalPosition) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<String>(
      context: context,
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      position: RelativeRect.fromRect(
        globalPosition & const Size(0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          height: 25.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, size: 14.sp, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text(
                'Edit',
                style: TextStyle(fontSize: 12.sp, color: AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
    if (result == 'edit') {
      setState(() {
        _isEditing = true;
      });
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        if (widget.showCloseIcon && widget.index >= 0) {
          _showEditMenu(details.globalPosition);
        }
      },
      onSecondaryTapDown: (details) {
        if (widget.showCloseIcon && widget.index >= 0) {
          _showEditMenu(details.globalPosition);
        }
      },
      child: InkWell(
        onTap: () {
          if (!_isEditing) {
            widget.blocContext.read<WatchlistBloc>().add(
              SelectWatchlistEvent(index: widget.index),
            );
          }
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 95.w,
          height: 26.h,
          padding: EdgeInsets.only(
            top: 4.h,
            bottom: 4.h,
            left: 6.w,
            right: widget.showCloseIcon ? 3.w : 6.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primaryBlue,
              width: widget.isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: AppColors.primaryBlue,
                          letterSpacing: 0.15,
                          height: 1.0,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        onSubmitted: (_) => _saveAndExitEditMode(),
                        cursorColor: AppColors.primaryBlue,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: AppColors.primaryBlue,
                          letterSpacing: 0.15,
                          height: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              if (widget.showCloseIcon) ...[
                SizedBox(width: 3.w),
                InkWell(
                  onTap: () {
                    if (!_isEditing) {
                      widget.blocContext.read<WatchlistBloc>().add(
                        RemoveWatchlistEvent(index: widget.index),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(7.r),
                  child: Container(
                    width: 13.w,
                    height: 13.h,
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
                        size: 9.sp,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
