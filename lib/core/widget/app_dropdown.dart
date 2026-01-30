import 'package:bazarpro/core/widget/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';


enum AppDropdownType {
  
  simple,

  
  search,

  
  multiSelect,
}

class AppDropdown extends StatefulWidget {
  final AppDropdownType type;
  final String hintText;
  final String? value;
  final List<String>? selectedValues;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<List<String>>? onMultiChanged;

  final double? width;
  final double? height;
  final double? dropdownHeight;
  final String searchHint;
  final bool showAllOption;
  final String allOptionText;
  final Color? borderColor;
  final Color? textColor;
  final bool isDarkMode;
  final String? label;
  final Color? labelColor;

  const AppDropdown({
    Key? key,
    this.type = AppDropdownType.simple,
    required this.hintText,
    this.value,
    this.selectedValues,
    required this.items,
    this.onChanged,
    this.onMultiChanged,
    this.width,
    this.height,
    this.dropdownHeight,
    this.searchHint = 'Search & Add',
    this.showAllOption = false,
    this.allOptionText = 'All',
    this.borderColor,
    this.textColor,
    this.isDarkMode = false,
    this.label,
    this.labelColor,
  }) : super(key: key);

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _filteredItems = [];
  Set<String> _selectedSet = {};

  late AnimationController _controller;
  late Animation<double> _animation;

  
  static const int _maxVisibleItems = 6;
  static double get _itemHeight => 40.h;
  static double get _searchFieldHeight => 50.h;
  static double get _selectAllHeight => 40.h;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _filteredItems = List.from(widget.items);
    if (widget.selectedValues != null) {
      _selectedSet = Set.from(widget.selectedValues!);
    }
  }

  @override
  void didUpdateWidget(AppDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
    }
    if (widget.selectedValues != null) {
      _selectedSet = Set.from(widget.selectedValues!);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    _searchController.clear();
    _filteredItems = List.from(widget.items);
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

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _onItemSelected(String item) {
    if (widget.type == AppDropdownType.multiSelect) {
      setState(() {
        if (_selectedSet.contains(item)) {
          _selectedSet.remove(item);
        } else {
          _selectedSet.add(item);
        }
      });
      widget.onMultiChanged?.call(_selectedSet.toList());
      _overlayEntry?.markNeedsBuild();
    } else {
      widget.onChanged?.call(item);
      _close();
    }
  }

  void _onSelectAll(bool selectAll) {
    setState(() {
      if (selectAll) {
        _selectedSet = Set.from(widget.items);
      } else {
        _selectedSet.clear();
      }
    });
    widget.onMultiChanged?.call(_selectedSet.toList());
    _overlayEntry?.markNeedsBuild();
  }

  
  Color get _borderColor => widget.borderColor ?? AppColors.primaryBlue;
  Color get _textColor =>
      widget.textColor ??
      (widget.isDarkMode
          ? DarkThemeColors.textColor
          : LightThemeColors.textColor);
  Color get _hintColor => AppColors.primaryBlue;
  Color get _bgColor => widget.isDarkMode
      ? DarkThemeColors.cardBackground
      : LightThemeColors.cardBackground;
  Color get _dropdownBgColor =>
      widget.isDarkMode ? DarkThemeColors.cardBackground : AppColors.white;

  
  TextStyle get _textStyle => GoogleFonts.openSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.15,
    color: AppColors.primaryBlue,
  );

  String get _displayText {
    if (widget.type == AppDropdownType.multiSelect) {
      if (_selectedSet.isEmpty) return widget.hintText;
      if (_selectedSet.length == widget.items.length) return 'All Selected';
      if (_selectedSet.length == 1) return _selectedSet.first;
      return '${_selectedSet.length} Selected';
    }
    return widget.value ?? widget.hintText;
  }

  double _calculateDropdownHeight(int filteredCount) {
    int totalItems = filteredCount;
    if (widget.showAllOption && widget.type == AppDropdownType.simple) {
      totalItems += 1;
    }

    final visibleItems = totalItems > _maxVisibleItems
        ? _maxVisibleItems
        : totalItems;
    double listHeight = visibleItems * _itemHeight;

    double searchHeight = 0;
    if (widget.type != AppDropdownType.simple) {
      searchHeight = _searchFieldHeight;
    }

    double selectAllHeight = 0;
    if (widget.type == AppDropdownType.multiSelect) {
      selectAllHeight = _selectAllHeight;
    }

    return listHeight + searchHeight + selectAllHeight;
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        final dropdownHeight =
            widget.dropdownHeight ??
            _calculateDropdownHeight(_filteredItems.length);

        return Stack(
          children: [
            
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: AppColors.transparent),
              ),
            ),
            
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.h,
              width: widget.width ?? size.width,
              child: FadeTransition(
                opacity: _animation,
                child: Material(
                  color: AppColors.transparent,
                  child: Container(
                    height: dropdownHeight,
                    decoration: BoxDecoration(
                      color: _dropdownBgColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: _borderColor, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        if (widget.type != AppDropdownType.simple)
                          _buildSearchField(),

                        
                        if (widget.type == AppDropdownType.multiSelect)
                          _buildSelectAllOption(),

                        
                        Expanded(
                          child: RawScrollbar(
                            controller: _scrollController,
                            thumbVisibility: _getItemCount() > _maxVisibleItems,
                            thickness: 6.w,
                            radius: Radius.circular(3.r),
                            thumbColor: _borderColor.withOpacity(0.5),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              itemCount: _getItemCount(),
                              itemBuilder: (context, index) {
                                return _buildListItem(index);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _getItemCount() {
    if (widget.showAllOption && widget.type == AppDropdownType.simple) {
      return _filteredItems.length + 1;
    }
    return _filteredItems.length;
  }

  Widget _buildListItem(int index) {
    if (widget.showAllOption &&
        widget.type == AppDropdownType.simple &&
        index == 0) {
      return _buildSimpleItem(widget.allOptionText, isAllOption: true);
    }

    final itemIndex =
        (widget.showAllOption && widget.type == AppDropdownType.simple)
        ? index - 1
        : index;

    if (itemIndex < 0 || itemIndex >= _filteredItems.length) {
      return const SizedBox.shrink();
    }

    final item = _filteredItems[itemIndex];

    if (widget.type == AppDropdownType.multiSelect) {
      return _buildCheckboxItem(item);
    }
    return _buildSimpleItem(item);
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.all(10.w),
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.primaryBlue, width: 0.5),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          SvgIcon(
            assetPath: AppImages.searchIcon,
            isActive: _searchController.text.isNotEmpty,
            size: 20.w,
            activeColor: _borderColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: GoogleFonts.openSans(fontSize: 12.sp, color: _textColor),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  color: AppColors.supportiveTextColor(context),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllOption() {
    final isAllSelected =
        _selectedSet.length == widget.items.length && widget.items.isNotEmpty;

    return InkWell(
      onTap: () => _onSelectAll(!isAllSelected),
      child: Container(
        height: _selectAllHeight,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            _buildCheckbox(isAllSelected),
            SizedBox(width: 12.w),
            Text(
              'Select All',
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String item) {
    final isSelected = _selectedSet.contains(item);

    return InkWell(
      onTap: () => _onItemSelected(item),
      child: Container(
        height: _itemHeight,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            _buildCheckbox(isSelected),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item,
                style: GoogleFonts.openSans(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: _textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isChecked) {
    return Container(
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: isChecked ? _borderColor : AppColors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isChecked ? _borderColor : _hintColor,
          width: 2,
        ),
      ),
      child: isChecked
          ? Icon(Icons.check, size: 16.sp, color: AppColors.white)
          : null,
    );
  }

  Widget _buildSimpleItem(String item, {bool isAllOption = false}) {
    final isSelected =
        widget.value == item || (isAllOption && widget.value == null);

    return InkWell(
      onTap: () => _onItemSelected(isAllOption ? '' : item),
      child: Container(
        height: _itemHeight,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? _borderColor.withOpacity(0.1)
              : AppColors.transparent,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          item,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: _textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.value != null || _selectedSet.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: widget.labelColor ?? AppColors.white,
            ),
          ),
          SizedBox(height: 5.h),
        ],

        SizedBox(
          width: widget.width ?? 250.w,
          height: widget.height ?? 45.h,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: _borderColor, width: 2.w),
                ),
                child: Row(
                  children: [
                    
                    Expanded(
                      child: Text(
                        _displayText,
                        style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: 0.15,
                          color: hasValue ? _textColor : AppColors.primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    
                    Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.primaryBlue,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
