import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/support_conversation_entity.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<SupportConversationEntity>>>
  getSupportConversations();
}
