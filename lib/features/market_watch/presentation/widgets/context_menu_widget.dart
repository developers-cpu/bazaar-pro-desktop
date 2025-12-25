import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// Reusable context menu widget
/// Shows menu options when user right-clicks on a table row
/// Provides cut, copy, paste, delete, undo, redo and other operations
class ContextMenuWidget extends StatelessWidget {
  final Offset position;
  final VoidCallback onViewChart;
  final VoidCallback onArrangeSymbol;
  final VoidCallback onSetSymbolFont;
  final VoidCallback onFitToSize;
  final VoidCallback onSymbolInfo;
  final VoidCallback onGrid;
  final VoidCallback onCut;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onDelete;
  final bool canPaste;
  final bool canUndo;
  final bool canRedo;

  const ContextMenuWidget({
    Key? key,
    required this.position,
    required this.onViewChart,
    required this.onArrangeSymbol,
    required this.onSetSymbolFont,
    required this.onFitToSize,
    required this.onSymbolInfo,
    required this.onGrid,
    required this.onCut,
    required this.onCopy,
    required this.onPaste,
    required this.onUndo,
    required this.onRedo,
    required this.onDelete,
    this.canPaste = true,
    this.canUndo = true,
    this.canRedo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      child: Container(
        width: AppDimensions.contextMenuWidth,
        decoration: BoxDecoration(
          color: AppColors.contextMenuBackground,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
          border: Border.all(
            color: AppColors.borderColor,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              text: AppStrings.viewChart,
              onTap: onViewChart,
            ),
            _buildMenuItem(
              text: AppStrings.arrangeSymbol,
              onTap: onArrangeSymbol,
            ),
            _buildMenuItem(
              text: AppStrings.setSymbolFont,
              onTap: onSetSymbolFont,
            ),
            _buildMenuItem(
              text: AppStrings.fitToSize,
              onTap: onFitToSize,
            ),
            _buildMenuItem(
              text: AppStrings.symbolInfo,
              onTap: onSymbolInfo,
            ),
            _buildMenuItem(
              text: AppStrings.grid,
              onTap: onGrid,
            ),
            _buildDivider(),
            _buildMenuItem(
              text: AppStrings.cut,
              onTap: onCut,
            ),
            _buildMenuItem(
              text: AppStrings.copy,
              onTap: onCopy,
            ),
            _buildMenuItem(
              text: AppStrings.paste,
              onTap: onPaste,
              enabled: canPaste,
            ),
            _buildMenuItem(
              text: AppStrings.undo,
              onTap: onUndo,
              enabled: canUndo,
            ),
            _buildMenuItem(
              text: AppStrings.redo,
              onTap: onRedo,
              enabled: canRedo,
            ),
            _buildDivider(),
            _buildMenuItem(
              text: AppStrings.delete,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual menu item with hover effect
  Widget _buildMenuItem({
    required String text,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? () => onTap() : null,
      hoverColor: AppColors.contextMenuHover,
      child: Container(
        height: AppDimensions.contextMenuItemHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingS,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeM,
              color: enabled
                  ? AppColors.primaryTextColor
                  : AppColors.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Build divider between menu sections
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: AppDimensions.borderWidthThin,
      color: AppColors.borderColor,
    );
  }
}