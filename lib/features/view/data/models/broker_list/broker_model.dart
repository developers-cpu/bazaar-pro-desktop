import '../../../domain/entities/broker_list/broker.dart';

class BrokerModel extends Broker {
  const BrokerModel({
    required int index,
    required DateTime createdAt,
    required String name,
    required int clientsCount,
    required double totalBrokerage,
    required DateTime updatedOn,
  }) : super(
         index: index,
         createdAt: createdAt,
         name: name,
         clientsCount: clientsCount,
         totalBrokerage: totalBrokerage,
         updatedOn: updatedOn,
       );
  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel(
      index: json['index'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String,
      clientsCount: json['clientsCount'] as int,
      totalBrokerage: (json['totalBrokerage'] as num).toDouble(),
      updatedOn: DateTime.parse(json['updatedOn'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'clientsCount': clientsCount,
      'totalBrokerage': totalBrokerage,
      'updatedOn': updatedOn.toIso8601String(),
    };
  }
}
