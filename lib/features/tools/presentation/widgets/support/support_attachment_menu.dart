import 'package:bazarpro/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum SupportAttachmentOption { document, media, camera, audio, sticker }

class SupportAttachmentMenu {
  static Future<SupportAttachmentOption?> show(
    BuildContext context,
    GlobalKey targetKey,
  ) async {
    final targetContext = targetKey.currentContext;
    if (targetContext == null) {
      return null;
    }

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final target = targetContext.findRenderObject() as RenderBox;
    final topLeft = target.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = target.localToGlobal(
      target.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    return showMenu<SupportAttachmentOption>(
      context: context,
      color: AppColors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      position: RelativeRect.fromRect(
        Rect.fromPoints(topLeft, bottomRight),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(
          value: SupportAttachmentOption.document,
          child: _AttachmentMenuItem(
            icon: Icons.description_rounded,
            color: Color(0xFF7C5CFF),
            label: 'Document',
          ),
        ),
        PopupMenuItem(
          value: SupportAttachmentOption.media,
          child: _AttachmentMenuItem(
            icon: Icons.photo_library_rounded,
            color: Color(0xFF0A84FF),
            label: 'Photos & videos',
          ),
        ),
        PopupMenuItem(
          value: SupportAttachmentOption.camera,
          child: _AttachmentMenuItem(
            icon: Icons.camera_alt_rounded,
            color: Color(0xFFFF2D7A),
            label: 'Camera',
          ),
        ),
        PopupMenuItem(
          value: SupportAttachmentOption.audio,
          child: _AttachmentMenuItem(
            icon: Icons.headphones_rounded,
            color: Color(0xFFFF6A2D),
            label: 'Audio',
          ),
        ),
        PopupMenuItem(
          value: SupportAttachmentOption.sticker,
          child: _AttachmentMenuItem(
            icon: Icons.add_reaction_rounded,
            color: Color(0xFF16D6A6),
            label: 'New sticker',
          ),
        ),
      ],
    );
  }
}

class _AttachmentMenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _AttachmentMenuItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210.w,
      child: Row(
        children: [
          Icon(icon, color: color, size: 26.sp),
          SizedBox(width: 16.w),
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
