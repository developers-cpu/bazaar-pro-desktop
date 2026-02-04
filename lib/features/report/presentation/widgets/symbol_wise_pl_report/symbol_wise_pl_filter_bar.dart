import 'package:bazarpro/core/widget/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/symbol_wise_pl/symbol_wise_pl_bloc.dart';
import '../../bloc/symbol_wise_pl/symbol_wise_pl_event.dart';
import '../../bloc/symbol_wise_pl/symbol_wise_pl_state.dart';
class SymbolWisePLFilterBar extends StatelessWidget {
  const SymbolWisePLFilterBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: BlocBuilder<SymbolWisePLBloc, SymbolWisePLState>(
        builder: (context, state) {
          List<String> exchangeItems = [];
          List<String> symbolItems = [];
          if (state is SymbolWisePLLoaded) {
            exchangeItems = state.exchanges;
            symbolItems = state.symbols;
          }
          return Row(
            children: [
              AppDropdown(
                hintText: 'Exchange',
                items: exchangeItems,
                onChanged: (value) {
                  context.read<SymbolWisePLBloc>().add(
                    FilterSymbolWisePL(exchange: value),
                  );
                },
                width: 200.w,
                height: 40.h,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppDropdown(
                  hintText: 'Symbol',
                  items: symbolItems,
                  type: AppDropdownType.search,
                  searchHint: 'Search & Add',
                  onChanged: (value) {
                    context.read<SymbolWisePLBloc>().add(
                      FilterSymbolWisePL(symbol: value),
                    );
                  },
                  width: 200.w,
                  height: 40.h, 
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 40.h,
                width: 100.w,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<SymbolWisePLBloc>().add(
                      const LoadSymbolWisePL(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                height: 40.h,
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SymbolWisePLBloc>().add(
                      const LoadSymbolWisePL(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F4A66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'View',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
