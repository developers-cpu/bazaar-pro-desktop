import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';

class GetUserStatuses {
  final UserRepository repository;
  GetUserStatuses(this.repository);
  List<String> call() {
    return repository.getUserStatuses();
  }
}