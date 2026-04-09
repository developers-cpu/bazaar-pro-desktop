import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_action_button.dart';
import '../../../domain/entities/support_message_entity.dart';

class SupportComposeDialogs {
  static Future<SupportMessageEntity?> showStickerDialog(
    BuildContext context,
  ) async {
    final stickers = [
      '😀',
      '😁',
      '😂',
      '😍',
      '😎',
      '🤩',
      '🥳',
      '😴',
      '🔥',
      '🎯',
      '🚀',
      '🎉',
      '👍',
      '👏',
      '💬',
      '💯',
      '❤️',
      '💙',
      '💚',
      '💜',
      '⭐',
      '🌈',
      '⚡',
      '🎵',
      '🐼',
      '🐶',
      '🦊',
      '🍕',
      '☕',
      '🎮',
      '🏆',
      '✨',
    ];
    String selectedSticker = stickers.first;

    return showDialog<SupportMessageEntity>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Container(
                width: 330.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFF),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFD8E7F3)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pick Sticker',
                        style: GoogleFonts.openSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Choose a sticker to send in chat',
                        style: GoogleFonts.openSans(
                          fontSize: 11.sp,
                          color: AppColors.supportiveTextColor(context),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 220.h,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: stickers.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.h,
                              ),
                          itemBuilder: (context, index) {
                            final sticker = stickers[index];
                            final isSelected = sticker == selectedSticker;
                            return InkWell(
                              onTap: () =>
                                  setState(() => selectedSticker = sticker),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFE7F1F8)
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : const Color(0xFFD8E7F3),
                                    width: isSelected ? 1.6 : 1,
                                  ),
                                ),
                                child: Text(
                                  sticker,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomActionButton(
                          text: 'Send Sticker',
                          onPressed: () {
                            Navigator.of(dialogContext).pop(
                              SupportMessageEntity(
                                id: DateTime.now().microsecondsSinceEpoch
                                    .toString(),
                                text: selectedSticker,
                                timestamp: DateTime.now(),
                                isSentByCurrentUser: true,
                                type: SupportMessageType.sticker,
                              ),
                            );
                          },
                          width: 116.w,
                          height: 38.h,
                          borderRadius: 10.r,
                          backgroundColor: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
