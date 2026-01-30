import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/search_user/search_user_bloc.dart';
import '../../bloc/search_user/search_user_event.dart';
import '../../bloc/search_user/search_user_state.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/widget/svg_icon.dart';
import '../search/user_tree_view.dart';

class UserSearchDialog extends StatelessWidget {
  const UserSearchDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const UserSearchDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SearchUserBloc>()..add(const LoadUserHierarchyEvent()),
      child: const UserSearchDialogContent(),
    );
  }
}

class UserSearchDialogContent extends StatelessWidget {
  const UserSearchDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: 'Search User',
      width: 600.w, 
      height: 700.h,
      showButtons: false,
      scrollable: false, 
      contentPadding: EdgeInsets.all(16.w),
      content: const UserSearchView(),
    );
  }
}

class UserSearchView extends StatelessWidget {
  const UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF1F4A66), width: 1.5),
          ),
          child: TextField(
            onChanged: (value) {
              context.read<SearchUserBloc>().add(SearchUserQueryEvent(value));
            },
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              color: AppColors.textColor(context),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Search User',
              hintStyle: GoogleFonts.openSans(
                color: const Color(0xFF1F4A66),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.w),
                child: SvgIcon(
                  assetPath: AppImages.searchIcon,
                  size: 20.sp,
                  isActive: true,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 11.h),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        
        Expanded(
          child: BlocBuilder<SearchUserBloc, SearchUserState>(
            builder: (context, state) {
              if (state is SearchUserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchUserError) {
                return Center(child: Text(state.message));
              } else if (state is SearchUserLoaded) {
                if (state.nodes.isEmpty) {
                  return Center(
                    child: Text(
                      'No users found',
                      style: GoogleFonts.openSans(color: Colors.grey),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: UserTreeView(nodes: state.nodes),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
