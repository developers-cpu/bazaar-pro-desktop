import 'package:equatable/equatable.dart';
class UsersBillSummaryEntity extends Equatable {
  final String puName;
  final String uName;
  final double netPL;
  const UsersBillSummaryEntity({
    required this.puName,
    required this.uName,
    required this.netPL,
  });
  @override
  List<Object?> get props => [puName, uName, netPL];
}
