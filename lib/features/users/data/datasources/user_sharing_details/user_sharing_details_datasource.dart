import 'package:bazarpro/features/users/data/models/user_sharing_details/user_sharing_details_model.dart';

abstract class UserSharingDetailsDataSource {
  Future<UserSharingDetailsModel> getUserSharingDetails(String userId);
}

class UserSharingDetailsDataSourceImpl implements UserSharingDetailsDataSource {
  @override
  Future<UserSharingDetailsModel> getUserSharingDetails(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return const UserSharingDetailsModel(
      plSharing: [
        UserSharingInfoModel(person: 'Master', share: '50%'),
        UserSharingInfoModel(person: 'Self', share: '50%'),
      ],
      brokerageSharing: [
        UserSharingInfoModel(person: 'Master', share: '40%'),
        UserSharingInfoModel(person: 'Self', share: '60%'),
      ],
    );
  }
}