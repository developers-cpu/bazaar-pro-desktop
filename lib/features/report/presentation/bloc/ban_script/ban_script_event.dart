import 'package:equatable/equatable.dart';

abstract class BanScriptEvent extends Equatable {
  const BanScriptEvent();

  @override
  List<Object?> get props => [];
}

class FetchBanScriptEvent extends BanScriptEvent {
  final String? exchange;
  final String? banType;

  const FetchBanScriptEvent({this.exchange, this.banType});

  @override
  List<Object?> get props => [exchange, banType];
}
