import '../models/announcement_model.dart';
abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
}
class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AnnouncementModel(
        id: '1',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime(2025, 10, 26, 12, 31),
        isRead: false,
      ),
      AnnouncementModel(
        id: '2',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
      AnnouncementModel(
        id: '3',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
      AnnouncementModel(
        id: '4',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now().add(
          const Duration(hours: 12, minutes: 31),
        ),
        isRead: false,
      ),
      AnnouncementModel(
        id: '5',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now().add(
          const Duration(hours: 12, minutes: 31),
        ),
        isRead: false,
      ),
    ];
  }
}
