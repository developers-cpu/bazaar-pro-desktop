import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../domain/entities/support_conversation_entity.dart';

class SupportConversationList extends StatelessWidget {
  final TextEditingController searchController;
  final List<SupportConversationEntity> conversations;
  final String? selectedConversationId;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onConversationTap;

  const SupportConversationList({
    super.key,
    required this.searchController,
    required this.conversations,
    required this.selectedConversationId,
    required this.onSearchChanged,
    required this.onConversationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: CustomInputField(
              hintText: 'Search',
              controller: searchController,
              prefixSvgPath: AppImages.searchIcon,
              width: double.infinity,
              height: 36.h,
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Text(
                      'No support chats found',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color: AppColors.supportiveTextColor(context),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: conversations.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.borderColor,
                    ),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final isSelected =
                          conversation.id == selectedConversationId;
                      return _SupportConversationTile(
                        conversation: conversation,
                        isSelected: isSelected,
                        onTap: () => onConversationTap(conversation.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SupportConversationTile extends StatelessWidget {
  final SupportConversationEntity conversation;
  final bool isSelected;
  final VoidCallback onTap;

  const _SupportConversationTile({
    required this.conversation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryBlue : AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.red, width: 2),
                ),
                child: Text(
                  conversation.initials,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      conversation.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        color: isSelected
                            ? AppColors.white.withOpacity(0.85)
                            : AppColors.supportiveTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (conversation.unreadCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white : AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    conversation.unreadCount.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
