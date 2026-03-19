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
import 'package:bazarpro/features/users/domain/entities/user.dart';

class UserHierarchyDialog {
  static void show(BuildContext context, User user) {
    CommonDialog.show(
      context: context,
      title: "${user.userName}'s User list",
      width: 380.w,
      height: 600.h,
      showButtons: false,
      scrollable: false,
      contentPadding: EdgeInsets.all(16.w),
      contentBuilder: (context, onClose) => BlocProvider(
        create: (context) =>
            sl<SearchUserBloc>()
              ..add(LoadUserHierarchyEvent(rootUserName: user.userName)),
        child: const _UserHierarchyContent(),
      ),
    );
  }
}

class _UserHierarchyContent extends StatelessWidget {
  const _UserHierarchyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            hintText: 'Search User',
            height: 30.h,
            width: 200.w,
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
      ),
    );
  }
}