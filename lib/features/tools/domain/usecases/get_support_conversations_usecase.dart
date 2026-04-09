import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/support_conversation_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportConversationsUseCase
    implements UseCase<List<SupportConversationEntity>, NoParams> {
  final SupportRepository repository;

  GetSupportConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SupportConversationEntity>>> call(
    NoParams params,
  ) async {
    return repository.getSupportConversations();
  }
}
