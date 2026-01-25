import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widget/app_bar_section.dart';
import '../widgets/dialogs/user_type_selection_dialog.dart';
import 'user_list_page.dart';

/// User Page Wrapper - Common wrapper for all User section pages
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

/// Create User Page with AppBar
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

/// In-Active User Page with AppBar
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

/// Search User Page with AppBar
class SearchUserPageWithAppBar extends StatelessWidget {
  const SearchUserPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserPageWrapper(
      pageTitle: 'Search User',
      child: SearchUserPage(),
    );
  }
}

/// User List Page with AppBar
class UserListPageWithAppBar extends StatelessWidget {
  const UserListPageWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserPageWrapper(pageTitle: 'User List', child: UserListPage());
  }
}

/// Create User Page - Shows dialog to create a new user
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
          // Navigate to user list after creation
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

/// In-Active User Page - Placeholder
class InactiveUserPage extends StatelessWidget {
  const InactiveUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'In-Active User - Coming Soon',
        style: TextStyle(
          fontSize: 18.sp,
          color: AppColors.supportiveTextColor(context),
        ),
      ),
    );
  }
}

/// Search User Page - Placeholder
class SearchUserPage extends StatelessWidget {
  const SearchUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search User - Coming Soon',
        style: TextStyle(
          fontSize: 18.sp,
          color: AppColors.supportiveTextColor(context),
        ),
      ),
    );
  }
}
