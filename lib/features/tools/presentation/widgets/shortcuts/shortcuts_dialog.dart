import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/svg_icon.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/shortcut_entity.dart';
import '../../bloc/shortcuts/shortcuts_bloc.dart';
import '../../bloc/shortcuts/shortcuts_event.dart';
import '../../bloc/shortcuts/shortcuts_state.dart';
class ShortcutsDialog extends StatelessWidget {
  const ShortcutsDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    CommonDialog.show(
      context: context,
      title: 'Short Cuts',
      width: 800.w,
      showButtons: false,
      contentPadding: EdgeInsets.all(20.w),
      content: BlocProvider<ShortcutsBloc>(
        create: (context) => sl<ShortcutsBloc>()..add(GetShortcutsEvent()),
        child: const ShortcutsDialog(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450.h,
      child: BlocBuilder<ShortcutsBloc, ShortcutsState>(
        builder: (context, state) {
          if (state is ShortcutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShortcutsLoaded) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: state.shortcuts.length,
              itemBuilder: (context, index) {
                final item = state.shortcuts[index];
                return _buildShortcutItem(item);
              },
            );
          } else if (state is ShortcutsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
  Widget _buildShortcutItem(ShortcutEntity item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Row(
        children: [
          SvgIcon(
            assetPath: item.iconPath,
            size: 24.sp,
            isActive: true,
            activeColor: _getIconColor(item.title),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item.title,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          Text(
            item.keyComb,
            style: GoogleFonts.openSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
  Color? _getIconColor(String title) {
    if (title.toLowerCase().contains('buy')) return AppColors.successColor;
    if (title.toLowerCase().contains('sell')) return AppColors.red;
    return null;
  }
}
