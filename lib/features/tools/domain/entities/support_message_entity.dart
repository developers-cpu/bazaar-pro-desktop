import 'package:equatable/equatable.dart';

enum SupportMessageType {
  text,
  document,
  image,
  video,
  audioFile,
  voiceNote,
  contact,
  poll,
  event,
  sticker,
  cameraImage,
}

class SupportMessageEntity extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSentByCurrentUser;
  final SupportMessageType type;
  final String? attachmentName;
  final String? attachmentPath;
  final String? metadata;
  final List<String> options;

  const SupportMessageEntity({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSentByCurrentUser,
    this.type = SupportMessageType.text,
    this.attachmentName,
    this.attachmentPath,
    this.metadata,
    this.options = const [],
  });

  @override
  List<Object?> get props => [
    id,
    text,
    timestamp,
    isSentByCurrentUser,
    type,
    attachmentName,
    attachmentPath,
    metadata,
    options,
  ];
}
