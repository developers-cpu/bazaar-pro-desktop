import '../../entities/broker_list/client_breakdown.dart';

abstract class ClientBreakdownRepository {
  Future<ClientBreakdown> getClientBreakdown(
    String brokerId,
    String clientName,
  );
}