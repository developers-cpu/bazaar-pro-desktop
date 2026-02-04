import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widget/common_dilog_box.dart';
import '../../../../core/widget/svg_icon.dart';
import '../bloc/arrangesymbol/arrange_symbol_bloc.dart';
import '../bloc/arrangesymbol/arrange_symbol_event.dart';
import '../bloc/arrangesymbol/arrange_symbol_state.dart';
class ArrangeSymbolDialog extends StatelessWidget {
  const ArrangeSymbolDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    context.read<ArrangeSymbolBloc>().add(const LoadColumnsEvent());
    CommonDialog.show(
      context: context,
      title: 'Market',
      width: 420.w,
      content: BlocProvider.value(
        value: context.read<ArrangeSymbolBloc>(),
        child: const _ArrangeSymbolContent(),
      ),
      onSave: () {
        context.read<ArrangeSymbolBloc>().add(const SaveColumnsEvent());
      },
      backgroundColor: LightThemeColors.cardBackground,
      headerColor: const Color(0xFF2C5766),
      buttonWidth: 180.w,
      buttonHeight: 45.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Market',
      content: const _ArrangeSymbolContent(),
      width: 420.w,
      onSave: () {
        context.read<ArrangeSymbolBloc>().add(const SaveColumnsEvent());
      },
      backgroundColor: LightThemeColors.cardBackground,
      headerColor: const Color(0xFF2C5766),
      buttonWidth: 180.w,
      buttonHeight: 45.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
    );
  }
}
class _ArrangeSymbolContent extends StatelessWidget {
  const _ArrangeSymbolContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColumnList(),
      ],
    );
  }
  Widget _buildColumnList() {
    return BlocBuilder<ArrangeSymbolBloc, ArrangeSymbolState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(maxHeight: 450.h),
          child: ReorderableListView.builder(
            shrinkWrap: true,
            buildDefaultDragHandles: false, 
            itemCount: state.columns.length,
            onReorder: (oldIndex, newIndex) {
              context.read<ArrangeSymbolBloc>().add(
                ReorderColumnEvent(oldIndex: oldIndex, newIndex: newIndex),
              );
            },
            itemBuilder: (context, index) {
              final column = state.columns[index];
              return _buildColumnItem(
                key: ValueKey(column.id),
                context: context,
                column: column,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
  Widget _buildColumnItem({
    required Key key,
    required BuildContext context,
    required ColumnItem column,
    required int index,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: _buildDragHandle(),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              column.name,
              style: GoogleFonts.openSans(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C5766),
                letterSpacing: 0.2,
              ),
            ),
          ),
          _buildToggleCheckbox(context, column),
        ],
      ),
    );
  }
  Widget _buildDragHandle() {
    return Container(
      width: 32.w,
      height: 32.h,
      alignment: Alignment.center,
      child: SvgIcon(
        assetPath: AppImages.arrangeIcon,
        isActive: true,
        size: 20.w,
      ),
    );
  }
  Widget _buildToggleCheckbox(BuildContext context, ColumnItem column) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, 
      onTap: () {
        print('Checkbox tapped: ${column.id} -> ${!column.isVisible}');
        context.read<ArrangeSymbolBloc>().add(
          ToggleColumnEvent(columnId: column.id),
        );
      },
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: column.isVisible
              ? const Color(0xFF2C5766)
              : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: const Color(0xFF2C5766),
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: column.isVisible
            ? Icon(
          Icons.check,
          size: 24.sp,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}
