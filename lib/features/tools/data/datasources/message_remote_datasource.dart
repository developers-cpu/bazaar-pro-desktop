import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> getMessages();
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  @override
  Future<List<MessageModel>> getMessages() async {
    return [
      MessageModel(
        id: '1',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime(2025, 10, 26, 12, 31),
        isRead: false,
      ),
      MessageModel(
        id: '2',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
      MessageModel(
        id: '3',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
      MessageModel(
        id: '4',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now().add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
      MessageModel(
        id: '5',
        title: 'Exciting news, traders!',
        body:
            'We\'ve rolled out a new update to make your trading experience faster, smoother, and more secure. Update now and enjoy enhanced performance with bug fixes and new features!',
        timestamp: DateTime.now().add(const Duration(hours: 12, minutes: 31)),
        isRead: false,
      ),
    ];
  }
}
