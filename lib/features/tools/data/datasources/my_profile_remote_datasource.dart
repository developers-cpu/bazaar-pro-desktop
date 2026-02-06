import '../models/my_profile_model.dart';

abstract class MyProfileRemoteDataSource {
  Future<MyProfileModel> getMyProfile();
}

class MyProfileRemoteDataSourceImpl implements MyProfileRemoteDataSource {
  @override
  Future<MyProfileModel> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const MyProfileModel(
      userName: 'Democlient',
      name: 'Rajesh Patil',
      credit: 5000000.0,
      remark: '5',
      leverage: '1:1',
      creditLimit: 100000.0,
      mobile: '78956428923',
      plSharing: {'downline': 20, 'upline': 20, 'our': 50},
      brkSharing: {'downline': 20, 'upline': 20, 'our': 55},
      exchanges: ['NSE', 'MCX'],
    );
  }
}
