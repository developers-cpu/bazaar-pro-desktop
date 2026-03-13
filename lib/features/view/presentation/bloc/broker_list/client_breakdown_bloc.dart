import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/broker_list/client_breakdown.dart';
import '../../../domain/usecases/broker_list/get_client_breakdown.dart';
import '../../utils/client_breakdown_service.dart';

// Events
abstract class ClientBreakdownEvent extends Equatable {
  const ClientBreakdownEvent();
  @override
  List<Object?> get props => [];
}

class LoadClientBreakdownEvent extends ClientBreakdownEvent {
  final String brokerId;
  final String clientName;
  const LoadClientBreakdownEvent({required this.brokerId, required this.clientName});
  @override
  List<Object?> get props => [brokerId, clientName];
}

class ExportClientBreakdownPdfEvent extends ClientBreakdownEvent {
  final ClientBreakdown breakdown;
  const ExportClientBreakdownPdfEvent(this.breakdown);
  @override
  List<Object?> get props => [breakdown];
}

// States
abstract class ClientBreakdownState extends Equatable {
  const ClientBreakdownState();
  @override
  List<Object?> get props => [];
}

class ClientBreakdownInitial extends ClientBreakdownState {}

class ClientBreakdownLoading extends ClientBreakdownState {}

class ClientBreakdownLoaded extends ClientBreakdownState {
  final ClientBreakdown breakdown;
  const ClientBreakdownLoaded(this.breakdown);
  @override
  List<Object?> get props => [breakdown];
}

class ClientBreakdownError extends ClientBreakdownState {
  final String message;
  const ClientBreakdownError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ClientBreakdownBloc extends Bloc<ClientBreakdownEvent, ClientBreakdownState> {
  final GetClientBreakdown getClientBreakdown;

  ClientBreakdownBloc({required this.getClientBreakdown}) : super(ClientBreakdownInitial()) {
    on<LoadClientBreakdownEvent>(_onLoadClientBreakdown);
    on<ExportClientBreakdownPdfEvent>(_onExportPdf);
  }

  Future<void> _onLoadClientBreakdown(
    LoadClientBreakdownEvent event,
    Emitter<ClientBreakdownState> emit,
  ) async {
    emit(ClientBreakdownLoading());
    try {
      final breakdown = await getClientBreakdown(event.brokerId, event.clientName);
      emit(ClientBreakdownLoaded(breakdown));
    } catch (e) {
      emit(ClientBreakdownError(e.toString()));
    }
  }

  Future<void> _onExportPdf(
    ExportClientBreakdownPdfEvent event,
    Emitter<ClientBreakdownState> emit,
  ) async {
    try {
      await ClientBreakdownService.exportAsPdf(event.breakdown);
    } catch (e) {
      // In a real app we might want a separate state for export error
      // or show a snackbar
    }
  }
}
