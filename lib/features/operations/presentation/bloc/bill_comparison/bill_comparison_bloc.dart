import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/bill_comparison/get_bill_comparison_data.dart';
import 'bill_comparison_event.dart';
import 'bill_comparison_state.dart';

class BillComparisonBloc
    extends Bloc<BillComparisonEvent, BillComparisonState> {
  final GetBillComparisonData getBillComparisonData;
  BillComparisonBloc({required this.getBillComparisonData})
    : super(const BillComparisonState()) {
    on<LoadBillComparisonEvent>(_onLoadBillComparison);
    on<SearchBillComparisonEvent>(_onSearchBillComparison);
  }
  Future<void> _onLoadBillComparison(
    LoadBillComparisonEvent event,
    Emitter<BillComparisonState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: '',
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    try {
      final data = await getBillComparisonData(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(
        state.copyWith(
          isLoading: false,
          hasLoadedInitialData: true,
          allData: data,
          filteredData: data,
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          hasLoadedInitialData: true,
          error: e.toString(),
        ),
      );
    }
  }

  void _onSearchBillComparison(
    SearchBillComparisonEvent event,
    Emitter<BillComparisonState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(
        state.copyWith(searchQuery: event.query, filteredData: state.allData),
      );
      return;
    }
    final query = event.query.toLowerCase();
    final filtered = state.allData.where((item) {
      return item.username.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query);
    }).toList();
    emit(state.copyWith(searchQuery: event.query, filteredData: filtered));
  }
}
