import 'package:equatable/equatable.dart';
import '../../../domain/entities/bill_comparison/bill_comparison_entity.dart';
class BillComparisonState extends Equatable {
  final bool isLoading;
  final bool hasLoadedInitialData; 
  final List<BillComparisonEntity> allData;
  final List<BillComparisonEntity> filteredData;
  final String error;
  final String searchQuery;
  final String startDate;
  final String endDate;
  const BillComparisonState({
    this.isLoading = false,
    this.hasLoadedInitialData = false,
    this.allData = const [],
    this.filteredData = const [],
    this.error = '',
    this.searchQuery = '',
    this.startDate = '',
    this.endDate = '',
  });
  BillComparisonState copyWith({
    bool? isLoading,
    bool? hasLoadedInitialData,
    List<BillComparisonEntity>? allData,
    List<BillComparisonEntity>? filteredData,
    String? error,
    String? searchQuery,
    String? startDate,
    String? endDate,
  }) {
    return BillComparisonState(
      isLoading: isLoading ?? this.isLoading,
      hasLoadedInitialData: hasLoadedInitialData ?? this.hasLoadedInitialData,
      allData: allData ?? this.allData,
      filteredData: filteredData ?? this.filteredData,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
  @override
  List<Object?> get props => [
    isLoading,
    hasLoadedInitialData,
    allData,
    filteredData,
    error,
    searchQuery,
    startDate,
    endDate,
  ];
}
