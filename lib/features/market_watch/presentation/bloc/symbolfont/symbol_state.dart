import 'package:equatable/equatable.dart';

class SymbolFontState extends Equatable {
  final List<String> fontFamilies;
  final List<String> fontStyles;
  final List<int> fontSizes;
  final String selectedFontFamily;
  final String selectedFontStyle;
  final int selectedFontSize;
  final bool isSaved;
  const SymbolFontState({
    this.fontFamilies = const [],
    this.fontStyles = const [],
    this.fontSizes = const [],
    this.selectedFontFamily = 'Inter',
    this.selectedFontStyle = 'Regular',
    this.selectedFontSize = 11,
    this.isSaved = false,
  });
  SymbolFontState copyWith({
    List<String>? fontFamilies,
    List<String>? fontStyles,
    List<int>? fontSizes,
    String? selectedFontFamily,
    String? selectedFontStyle,
    int? selectedFontSize,
    bool? isSaved,
  }) {
    return SymbolFontState(
      fontFamilies: fontFamilies ?? this.fontFamilies,
      fontStyles: fontStyles ?? this.fontStyles,
      fontSizes: fontSizes ?? this.fontSizes,
      selectedFontFamily: selectedFontFamily ?? this.selectedFontFamily,
      selectedFontStyle: selectedFontStyle ?? this.selectedFontStyle,
      selectedFontSize: selectedFontSize ?? this.selectedFontSize,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
    fontFamilies,
    fontStyles,
    fontSizes,
    selectedFontFamily,
    selectedFontStyle,
    selectedFontSize,
    isSaved,
  ];
}