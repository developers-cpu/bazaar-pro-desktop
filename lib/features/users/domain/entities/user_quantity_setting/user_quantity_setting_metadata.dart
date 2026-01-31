import 'package:equatable/equatable.dart';

class UserQuantitySettingMetadata extends Equatable {
  final List<String> symbols;

  const UserQuantitySettingMetadata({required this.symbols});

  @override
  List<Object> get props => [symbols];
}
