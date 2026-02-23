import 'package:equatable/equatable.dart';
class DateSetting extends Equatable {
  final String id;
  final String exchange;
  final String symbol;
  final String expiryDate;
  final String launchDate;
  final String closeDate;
  final String cutDate;
  final String updatedOn;
  final String updatedBy;
  const DateSetting({
    required this.id,
    required this.exchange,
    required this.symbol,
    required this.expiryDate,
    required this.launchDate,
    required this.closeDate,
    required this.cutDate,
    required this.updatedOn,
    required this.updatedBy,
  });
  @override
  List<Object?> get props => [
    id,
    exchange,
    symbol,
    expiryDate,
    launchDate,
    closeDate,
    cutDate,
    updatedOn,
    updatedBy,
  ];
}
