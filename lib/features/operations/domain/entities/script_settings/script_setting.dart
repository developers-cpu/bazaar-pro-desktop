import 'package:equatable/equatable.dart';

class ScriptSetting extends Equatable {
  final String id;
  final String symbol;
  final String updatedOn;
  final String updatedBy;
  final bool isBanned;
  final String? cutDate;
  const ScriptSetting({
    required this.id,
    required this.symbol,
    required this.updatedOn,
    required this.updatedBy,
    this.isBanned = false,
    this.cutDate,
  });
  @override
  List<Object?> get props => [
    id,
    symbol,
    updatedOn,
    updatedBy,
    isBanned,
    cutDate,
  ];
}
