import 'package:equatable/equatable.dart';
import '../../../domain/entities/settlement_progress/bhav_copy_entity.dart';
abstract class SettlementProgressEvent extends Equatable {
  const SettlementProgressEvent();
  @override
  List<Object?> get props => [];
}
class ChangeExchangeEvent extends SettlementProgressEvent {
  final String exchange;
  const ChangeExchangeEvent(this.exchange);
  @override
  List<Object?> get props => [exchange];
}
class SelectFileEvent extends SettlementProgressEvent {}
class ImportFileEvent extends SettlementProgressEvent {
  final String filePath;
  const ImportFileEvent(this.filePath);
  @override
  List<Object?> get props => [filePath];
}
class SubmitBhavCopyEvent extends SettlementProgressEvent {
  final List<BhavCopyEntity> data;
  const SubmitBhavCopyEvent(this.data);
  @override
  List<Object?> get props => [data];
}
class LoadSettlementDataEvent extends SettlementProgressEvent {}
