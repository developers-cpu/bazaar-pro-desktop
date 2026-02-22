import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/widget/common_dilog_box.dart';
import '../../../../../../injection_container.dart';
import '../../bloc/search_user/search_user_bloc.dart';
import '../../bloc/search_user/search_user_event.dart';
import '../../bloc/search_user/search_user_state.dart';
import '../../../../../../core/constants/app_images.dart';
import '../search/user_tree_view.dart';
import '../../../../../../core/widget/custom_input_field.dart';

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
      width: 450.w,
      height: 650.h,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputField(
          hintText: 'Search User',
          height: 35.h,
          width: 250.w,
          prefixSvgPath: AppImages.searchIcon,
          onChanged: (value) {
            context.read<SearchUserBloc>().add(SearchUserQueryEvent(value));
          },
        ),
        SizedBox(height: 12.h),
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
