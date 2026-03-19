import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class GetMessagesUseCase implements UseCase<List<MessageEntity>, NoParams> {
  final MessageRepository repository;
  GetMessagesUseCase({required this.repository});
  @override
  Future<Either<Failure, List<MessageEntity>>> call(NoParams params) async {
    return await repository.getMessages();
  }
}