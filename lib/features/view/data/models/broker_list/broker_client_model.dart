import '../../../domain/entities/broker_list/broker_client.dart';

class BrokerClientModel extends BrokerClient {
  const BrokerClientModel({required String name, required double brokerage})
    : super(name: name, brokerage: brokerage);

  factory BrokerClientModel.fromJson(Map<String, dynamic> json) {
    return BrokerClientModel(
      name: json['name'] as String,
      brokerage: (json['brokerage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'brokerage': brokerage};
  }
}
