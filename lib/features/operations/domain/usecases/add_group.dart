import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/operation_repository.dart';

class AddGroup implements UseCase<bool, AddGroupParams> {
  final OperationRepository repository;

  AddGroup(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddGroupParams params) async {
    return await repository.addGroup(
      exchange: params.exchange,
      groupName: params.groupName,
      isDefault: params.isDefault,
    );
  }
}

class AddGroupParams extends Equatable {
  final String exchange;
  final String groupName;
  final bool isDefault;

  const AddGroupParams({
    required this.exchange,
    required this.groupName,
    required this.isDefault,
  });

  @override
  List<Object?> get props => [exchange, groupName, isDefault];
}
