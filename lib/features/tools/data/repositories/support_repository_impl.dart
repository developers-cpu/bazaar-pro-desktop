import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/support_conversation_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SupportConversationEntity>>>
  getSupportConversations() async {
    try {
      final result = await remoteDataSource.getSupportConversations();
      return Right(result);
    } catch (_) {
      return const Left(UnknownFailure('Failed to load support conversations'));
    }
  }
}
