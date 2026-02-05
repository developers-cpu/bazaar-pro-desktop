import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  MessageRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages() async {
    try {
      final messages = await remoteDataSource.getMessages();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
