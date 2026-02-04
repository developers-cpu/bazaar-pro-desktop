import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages();
}
