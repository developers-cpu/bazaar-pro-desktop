import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';

class GetUserTypes {
  final UserRepository repository;

  GetUserTypes(this.repository);

  List<String> call() {
    return repository.getUserTypes();
  }
}
