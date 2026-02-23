import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/user_hierarchy_node/user_hierarchy_node.dart';
import '../../bloc/search_user/search_user_bloc.dart';
import '../../bloc/search_user/search_user_event.dart';
import '../user_details/user_details_dialog.dart';
import '../create_user/master_form_dialog.dart';
import '../create_user/client_form_dialog.dart';
import '../create_user/update_access_dialog.dart';
class UserTreeView extends StatelessWidget {
  final List<UserHierarchyNode> nodes;
  final int level;
  const UserTreeView({super.key, required this.nodes, this.level = 0});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: nodes.where((n) => n.isVisible).map((node) {
        return _buildNode(context, node);
      }).toList(),
    );
  }
  Widget _buildNode(BuildContext context, UserHierarchyNode node) {
    Color iconColor;
    Color textColor;
    if (node.user.type == 'Super Admin' || node.user.type == 'Master') {
      iconColor = AppColors.errorColor;
      textColor = AppColors.errorColor;
    } else {
      if (level % 3 == 0) {
        iconColor = AppColors.primaryBlue;
      } else if (level % 3 == 1) {
        iconColor = AppColors.primaryBlue;
      } else {
        iconColor = Colors.orange;
      }
      textColor = iconColor;
    }
    final isClient = node.user.type == 'Client';
    final shouldShowChildren =
        node.isExpanded && node.children.isNotEmpty && !isClient;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNodeRow(context, node, iconColor, textColor),
        if (shouldShowChildren)
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: _buildDottedLineWrapper(
              context,
              UserTreeView(nodes: node.children, level: level + 1),
            ),
          ),
      ],
    );
  }
  Widget _buildNodeRow(
    BuildContext context,
    UserHierarchyNode node,
    Color iconColor,
    Color textColor,
  ) {
    final hasChildren = node.children.isNotEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          if (hasChildren && node.user.type != 'Client')
            InkWell(
              onTap: () {
                context.read<SearchUserBloc>().add(
                  ToggleNodeExpansionEvent(node.user.id),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  node.isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 20.sp,
                  color: AppColors.errorColor,
                ),
              ),
            )
          else
            SizedBox(width: 28.w),
          Expanded(
            child: InkWell(
              onTap: () {
                UserDetailsDialog.show(
                  context,
                  node.user,
                  onEdit: (dialogContext) =>
                      _showEditUserDialog(dialogContext, node),
                  onAction: (dialogContext) =>
                      _showActionDialog(dialogContext, node),
                );
              },
              child: Row(
                children: [
                  Icon(
                    (node.user.type == 'Super Admin' ||
                            node.user.type == 'Master')
                        ? Icons.groups
                        : Icons.person,
                    size: 18.sp,
                    color: iconColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${node.user.type} (${node.user.userName})',
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDottedLineWrapper(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.greyBorder, width: 1)),
      ),
      child: child,
    );
  }
  void _showEditUserDialog(BuildContext context, UserHierarchyNode node) {
    final user = node.user;
    final userData = {
      'name': user.name,
      'username': user.userName,
      'mobile': '',
      'credit': user.credit.toStringAsFixed(0),
      'leverage': user.leverage,
      'plSharing': user.plPercent.toStringAsFixed(0),
      'brokerageSharing': user.brkPercent.toStringAsFixed(0),
    };
    if (user.type == 'Master') {
      MasterFormDialog.showEdit(
        context: context,
        userData: userData,
        onComplete: () {
          context.read<SearchUserBloc>().add(const LoadUserHierarchyEvent());
        },
      );
    } else {
      ClientFormDialog.showEdit(
        context: context,
        userData: userData,
        onComplete: () {
          context.read<SearchUserBloc>().add(const LoadUserHierarchyEvent());
        },
      );
    }
  }
  void _showActionDialog(BuildContext context, UserHierarchyNode node) {
    final user = node.user;
    final currentSettings = {
      'bet': true,
      'closeOnly': false,
      'viewOnly': false,
      'status': user.isActive,
      'allowChat': true,
      'positionCut15Days': false,
      'freshLimitSL': true,
      'lockUser': false,
    };
    UpdateAccessDialog.show(
      context: context,
      userId: user.id,
      userName: user.userName,
      currentSettings: currentSettings,
      onUpdate: (updatedSettings) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access settings updated successfully')),
        );
        context.read<SearchUserBloc>().add(const LoadUserHierarchyEvent());
      },
    );
  }
}
