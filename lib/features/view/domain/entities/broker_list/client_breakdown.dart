import 'package:equatable/equatable.dart';

class ClientBreakdown extends Equatable {
  final String brokerId;
  final String clientName;
  final List<ClientBreakdownSection> sections;
  const ClientBreakdown({
    required this.brokerId,
    required this.clientName,
    required this.sections,
  });
  @override
  List<Object?> get props => [brokerId, clientName, sections];
}

class ClientBreakdownSection extends Equatable {
  final String title;
  final bool isSymbolBased;
  final bool hasFooter;
  final List<ClientBreakdownRow> rows;
  const ClientBreakdownSection({
    required this.title,
    required this.rows,
    this.isSymbolBased = false,
    this.hasFooter = false,
  });
  @override
  List<Object?> get props => [title, isSymbolBased, hasFooter, rows];
}

class ClientBreakdownRow extends Equatable {
  final String label;
  final String turnover;
  final double brokerage;
  const ClientBreakdownRow({
    required this.label,
    required this.turnover,
    required this.brokerage,
  });
  @override
  List<Object?> get props => [label, turnover, brokerage];
}
