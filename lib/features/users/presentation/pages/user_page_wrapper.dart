import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../widgets/create_user/user_type_selection_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/inactive_user_list/inactive_user_list_bloc.dart';
import 'inactive_user_list_page.dart';
import 'user_list_page.dart';


class UserPageWrapper extends StatelessWidget {
  final String pageTitle;
  final Widget child;

  const UserPageWrapper({
    super.key,
    required this.pageTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarSection(
        selectedTabIndex: 3,
        currentPageTitle: pageTitle,
        onTabSelected: (_) {},
      ),
      body: child,
    );
  }
}


class CreateUserPageWithAppBar extends StatelessWidget {
  const CreateUserPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserPageWrapper(
      pageTitle: 'Create User',
      child: CreateUserPage(),
    );
  }
}


class InactiveUserPageWithAppBar extends StatelessWidget {
  const InactiveUserPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserPageWrapper(
      pageTitle: 'In-Active User',
      child: InactiveUserPage(),
    );
  }
}


class UserListPageWithAppBar extends StatelessWidget {
  const UserListPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserPageWrapper(pageTitle: 'User List', child: UserListPage());
  }
}


class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUserTypeDialog();
    });
  }

  void _showUserTypeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.54),
      builder: (dialogContext) => UserTypeSelectionDialog(
        onUserCreated: () {
          
          Navigator.of(context).pushReplacementNamed(AppRoutes.userList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64.sp,
              color: AppColors.primaryBlue.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'Create a new user',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.supportiveTextColor(context),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _showUserTypeDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Create User',
                style: TextStyle(fontSize: 16.sp, color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class InactiveUserPage extends StatelessWidget {
  const InactiveUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InactiveUserListBloc>(),
      child: const InactiveUserListPage(),
    );
  }
}
