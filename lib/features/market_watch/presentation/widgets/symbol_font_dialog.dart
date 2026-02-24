import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/common_dilog_box.dart';
import '../bloc/symbolfont/symbol_font_bloc.dart';
import '../bloc/symbolfont/symbol_font_event.dart';
import '../bloc/symbolfont/symbol_state.dart';

class SymbolFontDialog extends StatelessWidget {
  const SymbolFontDialog({Key? key}) : super(key: key);
  static void show(BuildContext context) {
    context.read<SymbolFontBloc>().add(const LoadFontSettingsEvent());
    CommonDialog.show(
      context: context,
      title: 'Symbol Font',
      width: 500.w,
      content: BlocProvider.value(
        value: context.read<SymbolFontBloc>(),
        child: const _SymbolFontContent(),
      ),
      onSave: () {
        context.read<SymbolFontBloc>().add(const SaveFontSettingsEvent());
      },
      isDarkMode: true,
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.all(8.w),
      buttonHeight: 30.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Symbol Font',
      content: const _SymbolFontContent(),
      width: 380.w,
      onSave: () {
        context.read<SymbolFontBloc>().add(const SaveFontSettingsEvent());
      },
      isDarkMode: true,
      contentPadding: EdgeInsets.all(8.w),
      buttonHeight: 30.h,
    );
  }
}

class _SymbolFontContent extends StatelessWidget {
  const _SymbolFontContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolFontBloc, SymbolFontState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSelectorColumn(
                context: context,
                title: 'Font Family',
                items: state.fontFamilies,
                selectedItem: state.selectedFontFamily,
                onSelect: (item) {
                  context.read<SymbolFontBloc>().add(
                    SelectFontFamilyEvent(fontFamily: item),
                  );
                },
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildSelectorColumn(
                context: context,
                title: 'Font Style',
                items: state.fontStyles,
                selectedItem: state.selectedFontStyle,
                onSelect: (item) {
                  context.read<SymbolFontBloc>().add(
                    SelectFontStyleEvent(fontStyle: item),
                  );
                },
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildSelectorColumn(
                context: context,
                title: 'Font Size',
                items: state.fontSizes.map((s) => s.toString()).toList(),
                selectedItem: state.selectedFontSize.toString(),
                onSelect: (item) {
                  context.read<SymbolFontBloc>().add(
                    SelectFontSizeEvent(fontSize: int.parse(item)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectorColumn({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String selectedItem,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: AppColors.primaryBlue, width: 1.5),
          ),
          child: Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: const Color(0xFF2C5F7B), width: 1.5),
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;
              return GestureDetector(
                onTap: () => onSelect(item),
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : AppColors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    item,
                    style: GoogleFonts.openSans(
                      fontSize: 11.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
