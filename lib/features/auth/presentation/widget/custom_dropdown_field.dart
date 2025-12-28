import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final String? value;
  final List<DropdownOption> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  /// FIGMA SPECS - EXACT MATCHING
  static const double _fieldHeight = 45;
  static const double _dropdownHeight = 125;
  static const double _dropdownWidth = 450;
  static const double _gap = 5;
  static const double _borderRadius = 10;
  static const double _borderWidth = 2;

  static const Color _primary = Color(0xFF1F4A66);
  static const Color _background = Color(0xFFFFFFFF);


  TextStyle get _textStyle => const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.15,
    color: _primary,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _controller.forward();
  }

  void _close() {
    _controller.reverse().then((_) {
      _removeOverlay();
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }


  bool _isSvg(String path) {
    return path.toLowerCase().endsWith('.svg');
  }

  /// Build left icon widget (supports both PNG and SVG)
  Widget _buildLeftIcon(String? iconPath) {
    if (iconPath == null || iconPath.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 20,
        height: 20,
        child: _isSvg(iconPath)
            ? SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        )
            : Image.asset(
          iconPath,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }


  Widget _buildTrailingIcon(String? iconPath) {
    if (iconPath == null || iconPath.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: 20,
      height: 20,
      child: _isSvg(iconPath)
          ? SvgPicture.asset(
        iconPath,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          _primary,
          BlendMode.srcIn,
        ),
      )
          : Image.asset(
        iconPath,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        color: _primary,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }

  /// Check if a value is selected
  bool get _hasSelection {
    return widget.value != null && widget.value!.isNotEmpty;
  }

  /// Get the selected item or null
  DropdownOption? get _selectedItem {
    if (!_hasSelection) return null;
    try {
      return widget.items.firstWhere((e) => e.value == widget.value);
    } catch (_) {
      return null;
    }
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss layer - full screen tap to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown positioned below the field
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + _gap,
            width: _dropdownWidth,
            child: FadeTransition(
              opacity: _animation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _dropdownWidth,
                  height: _dropdownHeight,
                  decoration: BoxDecoration(
                    color: _background,
                    borderRadius: BorderRadius.circular(_borderRadius),
                    border: Border.all(color: _primary, width: _borderWidth),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_borderRadius - 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildDropdownItems(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDropdownItems() {
    final List<Widget> children = [];
    final itemCount = widget.items.length;

    // Calculate available height for items
    final availableHeight = _dropdownHeight - 4; // Border adjustment
    final itemHeight = availableHeight / itemCount;

    for (int i = 0; i < itemCount; i++) {
      final item = widget.items[i];
      final selected = item.value == widget.value;

      children.add(
        SizedBox(
          height: itemHeight,
          child: InkWell(
            onTap: () {
              widget.onChanged(item.value);
              _close();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF5F5F5) : Colors.transparent,
                border: i < itemCount - 1
                    ? Border(
                  bottom: BorderSide(
                    color: _primary.withOpacity(0.2),
                    width: 1,
                  ),
                )
                    : null,
              ),
              child: Row(
                children: [
                  // Left icon (PNG or SVG)
                  _buildLeftIcon(item.iconPath),
                  // Label text
                  Expanded(
                    child: Text(
                      item.label,
                      style: _textStyle,
                    ),
                  ),
                  // Right trailing icon (primary color)
                  _buildTrailingIcon(item.trailingIconPath),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedItem;

    return SizedBox(
      width: _dropdownWidth,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggle,
          child: Container(
            height: _fieldHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: _primary, width: _borderWidth),
            ),
            child: Row(
              children: [
                // Left icon (only when value is selected)
                if (_hasSelection && selected != null)
                  _buildLeftIcon(selected.iconPath),
                // Label / hint text - SAME STYLE FOR BOTH
                Expanded(
                  child: Text(
                    _hasSelection && selected != null
                        ? selected.label
                        : widget.hintText, // "Select Server"
                    style: _textStyle, // Same style: #1F4A66, SemiBold, 16px
                  ),
                ),
                // Right trailing icon (server icon with primary color)
                if (widget.items.isNotEmpty &&
                    widget.items.first.trailingIconPath != null)
                  _buildTrailingIcon(widget.items.first.trailingIconPath),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownOption {
  final String value;
  final String label;
  final String? iconPath;
  final String? trailingIconPath;

  DropdownOption({
    required this.value,
    required this.label,
    this.iconPath,
    this.trailingIconPath,
  });
}