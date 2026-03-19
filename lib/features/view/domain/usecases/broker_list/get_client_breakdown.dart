import '../../entities/broker_list/client_breakdown.dart';
import '../../repositories/broker_list/client_breakdown_repository.dart';

class GetClientBreakdown {
  final ClientBreakdownRepository repository;
  GetClientBreakdown(this.repository);
  Future<ClientBreakdown> call(String brokerId, String clientName) async {
    return await repository.getClientBreakdown(brokerId, clientName);
  }
}