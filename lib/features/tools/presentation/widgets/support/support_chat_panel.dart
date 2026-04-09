import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/foundation.dart' as foundation;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../domain/entities/support_conversation_entity.dart';
import '../../../domain/entities/support_message_entity.dart';
import 'support_attachment_menu.dart';
import 'support_camera_dialog.dart';
import 'support_compose_dialogs.dart';

class SupportChatPanel extends StatefulWidget {
  final SupportConversationEntity? conversation;
  final ValueChanged<SupportMessageEntity> onSendMessage;

  const SupportChatPanel({
    super.key,
    required this.conversation,
    required this.onSendMessage,
  });

  @override
  State<SupportChatPanel> createState() => _SupportChatPanelState();
}

class _SupportChatPanelState extends State<SupportChatPanel> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey _attachmentKey = GlobalKey();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Stopwatch _recordingStopwatch = Stopwatch();
  final FocusNode _messageFocusNode = FocusNode();

  Timer? _recordingTimer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _playerPositionSubscription;
  StreamSubscription<Duration>? _playerDurationSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  bool _isRecording = false;
  bool _showEmojiPicker = false;
  String? _playingMessageId;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus && _showEmojiPicker) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (!mounted) {
        return;
      }
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() {
          _playingMessageId = null;
          _playbackPosition = Duration.zero;
        });
        return;
      }
      setState(() {});
    });
    _playerPositionSubscription = _audioPlayer.onPositionChanged.listen((
      position,
    ) {
      if (!mounted) {
        return;
      }
      setState(() {
        _playbackPosition = position;
      });
    });
    _playerDurationSubscription = _audioPlayer.onDurationChanged.listen((
      duration,
    ) {
      if (!mounted) {
        return;
      }
      setState(() {
        _playbackDuration = duration;
      });
    });
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _playingMessageId = null;
        _playbackPosition = Duration.zero;
      });
    });
  }

  @override
  void didUpdateWidget(covariant SupportChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.conversation?.id != oldWidget.conversation?.id) {
      unawaited(_resetPlayback());
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _playerStateSubscription?.cancel();
    _playerPositionSubscription?.cancel();
    _playerDurationSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _submitMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    widget.onSendMessage(
      SupportMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: text,
        timestamp: DateTime.now(),
        isSentByCurrentUser: true,
        type: SupportMessageType.text,
      ),
    );
    _messageController.clear();
    setState(() {});
  }

  Future<void> _toggleEmojiPicker() async {
    if (_showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
      _messageFocusNode.requestFocus();
    } else {
      _messageFocusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _showEmojiPicker = true;
        });
      }
    }
  }

  Future<void> _toggleVoiceRecording() async {
    if (_isRecording) {
      await _stopVoiceRecording();
      return;
    }
    await _startVoiceRecording();
  }

  Future<void> _startVoiceRecording() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }

    final directory = await getTemporaryDirectory();
    final filePath =
        '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );

    _recordingStopwatch
      ..reset()
      ..start();
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    if (mounted) {
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopVoiceRecording() async {
    final path = await _audioRecorder.stop();
    _recordingTimer?.cancel();
    _recordingStopwatch.stop();

    final duration = _formatRecordedDuration(_recordingStopwatch.elapsed);
    _recordingStopwatch.reset();

    if (mounted) {
      setState(() {
        _isRecording = false;
      });
    }

    if (path == null || path.isEmpty) {
      return;
    }

    final file = File(path);
    final exists = await file.exists();
    if (!exists) {
      return;
    }

    widget.onSendMessage(
      SupportMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: 'Voice note',
        timestamp: DateTime.now(),
        isSentByCurrentUser: true,
        type: SupportMessageType.voiceNote,
        attachmentName: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'voice_note.m4a',
        attachmentPath: path,
        metadata: duration,
      ),
    );
  }

  Future<void> _toggleAudioPlayback(SupportMessageEntity message) async {
    final path = message.attachmentPath;
    if (path == null || path.isEmpty) {
      return;
    }

    if (_playingMessageId == message.id) {
      if (_audioPlayer.state == PlayerState.playing) {
        await _stopCurrentPlayback();
      } else {
        await _audioPlayer.resume();
      }
      if (mounted) {
        setState(() {});
      }
      return;
    }

    _playbackDuration = Duration.zero;
    _playbackPosition = Duration.zero;

    if (mounted) {
      setState(() {
        _playingMessageId = message.id;
      });
    }

    await _stopCurrentPlayback(clearUi: false);
    await _audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> _stopCurrentPlayback({bool clearUi = true}) async {
    await _audioPlayer.stop();
    if (!mounted || !clearUi) {
      return;
    }
    setState(() {
      _playingMessageId = null;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
    });
  }

  Future<void> _resetPlayback() async {
    await _stopCurrentPlayback(clearUi: false);
    if (!mounted) {
      return;
    }
    setState(() {
      _playingMessageId = null;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
    });
  }

  Future<void> _showAttachmentPicker() async {
    final selectedOption = await SupportAttachmentMenu.show(
      context,
      _attachmentKey,
    );
    if (selectedOption == null) {
      return;
    }

    switch (selectedOption) {
      case SupportAttachmentOption.document:
        await _pickFile(
          fileType: FileType.any,
          messageType: SupportMessageType.document,
        );
        break;
      case SupportAttachmentOption.media:
        await _pickFile(
          fileType: FileType.custom,
          allowedExtensions: const [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
            'mp4',
            'mov',
            'm4v',
            'avi',
            'mkv',
          ],
          messageType: SupportMessageType.image,
        );
        break;
      case SupportAttachmentOption.camera:
        await _pickFromCamera();
        break;
      case SupportAttachmentOption.audio:
        await _pickFile(
          fileType: FileType.audio,
          messageType: SupportMessageType.audioFile,
        );
        break;
      case SupportAttachmentOption.sticker:
        final message = await SupportComposeDialogs.showStickerDialog(context);
        if (message != null) {
          widget.onSendMessage(message);
        }
        break;
    }
  }

  Future<void> _pickFile({
    required FileType fileType,
    List<String>? allowedExtensions,
    required SupportMessageType messageType,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final path = file.path;
    if (path == null || path.isEmpty) {
      return;
    }

    final resolvedType = _resolveMessageType(path, fallback: messageType);
    final name = file.name;
    final metadata = _formatFileSize(file.size);

    widget.onSendMessage(
      SupportMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: name,
        timestamp: DateTime.now(),
        isSentByCurrentUser: true,
        type: resolvedType,
        attachmentName: name,
        attachmentPath: path,
        metadata: metadata,
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final capturedFile = await SupportCameraDialog.show(context);
    if (capturedFile == null || !mounted) return;

    final exists = await capturedFile.exists();
    if (!exists) return;

    final size = await capturedFile.length();
    final fileName = capturedFile.uri.pathSegments.isNotEmpty
        ? capturedFile.uri.pathSegments.last
        : 'camera_image.jpg';

    widget.onSendMessage(
      SupportMessageEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: fileName,
        timestamp: DateTime.now(),
        isSentByCurrentUser: true,
        type: SupportMessageType.cameraImage,
        attachmentName: fileName,
        attachmentPath: capturedFile.path,
        metadata: _formatFileSize(size),
      ),
    );
  }

  SupportMessageType _resolveMessageType(
    String path, {
    required SupportMessageType fallback,
  }) {
    final extension = path.split('.').last.toLowerCase();
    const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp'};
    const videoExtensions = {'mp4', 'mov', 'm4v', 'avi', 'mkv'};

    if (fallback == SupportMessageType.cameraImage) {
      return SupportMessageType.cameraImage;
    }
    if (imageExtensions.contains(extension)) {
      return SupportMessageType.image;
    }
    if (videoExtensions.contains(extension)) {
      return SupportMessageType.video;
    }
    return fallback;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatRecordedDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Duration _messageDuration(SupportMessageEntity message) {
    final metadata = message.metadata;
    if (metadata == null || metadata.isEmpty || !metadata.contains(':')) {
      return Duration.zero;
    }
    final parts = metadata.split(':');
    if (parts.length != 2) {
      return Duration.zero;
    }
    return Duration(
      minutes: int.tryParse(parts[0]) ?? 0,
      seconds: int.tryParse(parts[1]) ?? 0,
    );
  }

  Duration _effectiveDuration(SupportMessageEntity message) {
    if (_playingMessageId == message.id && _playbackDuration > Duration.zero) {
      return _playbackDuration;
    }
    return _messageDuration(message);
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final canSendText = _messageController.text.trim().isNotEmpty;
    if (conversation == null) {
      return Center(
        child: Text(
          'Select a support chat',
          style: GoogleFonts.openSans(
            fontSize: 13.sp,
            color: AppColors.supportiveTextColor(context),
          ),
        ),
      );
    }

    final messageGroups = _groupMessagesByDate(conversation.messages);

    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 10.h),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.red, width: 2),
                  ),
                  child: Text(
                    conversation.initials,
                    style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  conversation.name,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.borderColor),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 12.h),
              itemCount: messageGroups.length,
              itemBuilder: (context, index) {
                final entry = messageGroups[index];
                return Column(
                  children: [
                    _DateChip(label: entry.label),
                    SizedBox(height: 14.h),
                    ...entry.messages.map(
                      (message) => _MessageBubble(
                        message: message,
                        isPlaying:
                            _playingMessageId == message.id &&
                            _audioPlayer.state == PlayerState.playing,
                        isPaused:
                            _playingMessageId == message.id &&
                            _audioPlayer.state == PlayerState.paused,
                        playbackPosition: _playingMessageId == message.id
                            ? _playbackPosition
                            : Duration.zero,
                        playbackDuration: _effectiveDuration(message),
                        onToggleAudioPlayback: () =>
                            _toggleAudioPlayback(message),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: _isRecording
                      ? _RecordingIndicator(
                          duration: _formatRecordedDuration(
                            _recordingStopwatch.elapsed,
                          ),
                        )
                      : CustomInputField(
                          hintText: 'Type a message',
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          width: double.infinity,
                          height: 38.h,
                          prefixIcon: IconButton(
                            icon: Icon(
                              _showEmojiPicker
                                  ? Icons.keyboard_rounded
                                  : Icons.emoji_emotions_outlined,
                              color: AppColors.primaryBlue,
                              size: 20.sp,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _toggleEmojiPicker,
                            splashRadius: 20.r,
                          ),
                          onChanged: (_) {
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          onSubmitted: (_) {
                            _submitMessage();
                            _messageFocusNode.requestFocus();
                          },
                          borderColor: AppColors.primaryBlue,
                        ),
                ),
                SizedBox(width: 8.w),
                if (!_isRecording) ...[
                  _ComposerActionIcon(
                    key: _attachmentKey,
                    icon: Icons.attach_file_rounded,
                    onTap: _showAttachmentPicker,
                  ),
                  SizedBox(width: 2.w),
                ],
                _ComposerActionIcon(
                  icon: canSendText
                      ? Icons.send_rounded
                      : (_isRecording ? Icons.stop_rounded : Icons.mic_rounded),
                  onTap: canSendText ? _submitMessage : _toggleVoiceRecording,
                  filled: true,
                ),
              ],
            ),
          ),
          if (_showEmojiPicker)
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: 250.h,
                  child: emoji.EmojiPicker(
                    textEditingController: _messageController,
                    config: emoji.Config(
                      emojiViewConfig: emoji.EmojiViewConfig(
                        backgroundColor: AppColors.white,
                        columns: (constraints.maxWidth / 50).floor() < 7
                            ? 7
                            : (constraints.maxWidth / 50).floor(),
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform == TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                      ),
                      bottomActionBarConfig: const emoji.BottomActionBarConfig(
                        enabled: false,
                        backgroundColor: AppColors.white,
                        buttonColor: AppColors.white,
                        buttonIconColor: AppColors.primaryBlue,
                      ),
                      categoryViewConfig: const emoji.CategoryViewConfig(
                        backgroundColor: AppColors.white,
                        indicatorColor: AppColors.primaryBlue,
                        iconColorSelected: AppColors.primaryBlue,
                        iconColor: AppColors.textGrey,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  List<_MessageGroup> _groupMessagesByDate(
    List<SupportMessageEntity> messages,
  ) {
    final groups = <_MessageGroup>[];
    String? currentLabel;

    for (final message in messages) {
      final label = DateFormat('dd/MM/yy').format(message.timestamp);
      if (currentLabel != label) {
        groups.add(_MessageGroup(label: label, messages: [message]));
        currentLabel = label;
      } else {
        groups.last.messages.add(message);
      }
    }

    return groups;
  }
}

class _MessageGroup {
  final String label;
  final List<SupportMessageEntity> messages;

  _MessageGroup({required this.label, required this.messages});
}

class _DateChip extends StatelessWidget {
  final String label;

  const _DateChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD8E8F5),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final SupportMessageEntity message;
  final bool isPlaying;
  final bool isPaused;
  final Duration playbackPosition;
  final Duration playbackDuration;
  final VoidCallback onToggleAudioPlayback;

  const _MessageBubble({
    required this.message,
    required this.isPlaying,
    required this.isPaused,
    required this.playbackPosition,
    required this.playbackDuration,
    required this.onToggleAudioPlayback,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = message.isSentByCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bubbleColor = message.isSentByCurrentUser
        ? const Color(0xFFDDECFF)
        : AppColors.white;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.48.sw),
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: message.isSentByCurrentUser
                ? Colors.transparent
                : AppColors.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageContent(context),
            SizedBox(height: 6.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.openSans(
                    fontSize: 9.sp,
                    color: AppColors.supportiveTextColor(context),
                  ),
                ),
                if (message.isSentByCurrentUser) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.done_all_rounded,
                    size: 14.sp,
                    color: AppColors.supportiveTextColor(context),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case SupportMessageType.document:
        return _AttachmentCard(
          icon: Icons.description_rounded,
          title: message.attachmentName ?? message.text,
          subtitle: message.metadata,
          onTap: _openAttachment,
        );
      case SupportMessageType.image:
      case SupportMessageType.cameraImage:
        return _ImageCard(
          path: message.attachmentPath,
          title: message.attachmentName ?? message.text,
          onTap: _openAttachment,
        );
      case SupportMessageType.video:
        return _AttachmentCard(
          icon: Icons.play_circle_fill_rounded,
          title: message.attachmentName ?? message.text,
          subtitle: message.metadata ?? 'Video',
          onTap: _openAttachment,
        );
      case SupportMessageType.audioFile:
      case SupportMessageType.voiceNote:
        return _AudioCard(
          title: message.type == SupportMessageType.voiceNote
              ? 'Voice note'
              : (message.attachmentName ?? message.text),
          subtitle: message.metadata,
          elapsed: playbackPosition,
          duration: playbackDuration,
          isPlaying: isPlaying,
          isPaused: isPaused,
          isSentByCurrentUser: message.isSentByCurrentUser,
          onTap: onToggleAudioPlayback,
        );
      case SupportMessageType.contact:
      case SupportMessageType.poll:
      case SupportMessageType.event:
        return Text(
          message.text,
          style: GoogleFonts.openSans(fontSize: 12.sp, color: AppColors.black),
        );
      case SupportMessageType.sticker:
        return Text(message.text, style: TextStyle(fontSize: 32.sp));
      case SupportMessageType.text:
        return Text(
          message.text,
          style: GoogleFonts.openSans(fontSize: 12.sp, color: AppColors.black),
        );
    }
  }

  void _openAttachment() {
    final path = message.attachmentPath;
    if (path == null || path.isEmpty) {
      return;
    }
    OpenFilex.open(path);
  }
}

class _RecordingIndicator extends StatelessWidget {
  final String duration;

  const _RecordingIndicator({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0F2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFF1B5BE)),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE04B5A),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Recording...',
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const Spacer(),
          Text(
            duration,
            style: GoogleFonts.openSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerActionIcon extends StatelessWidget {
  final Key? key;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _ComposerActionIcon({
    this.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: filled ? AppColors.white : AppColors.primaryBlue,
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _AttachmentCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F1F8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 22.sp),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: GoogleFonts.openSans(
                      fontSize: 10.sp,
                      color: AppColors.supportiveTextColor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String? path;
  final String title;
  final VoidCallback? onTap;

  const _ImageCard({required this.path, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        path != null && path!.isNotEmpty && File(path!).existsSync();
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: hasImage
                ? Image.file(
                    File(path!),
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 140.h,
                    width: double.infinity,
                    color: const Color(0xFFE7F1F8),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.photo_camera_back_rounded,
                      size: 36.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Duration elapsed;
  final Duration duration;
  final bool isPlaying;
  final bool isPaused;
  final bool isSentByCurrentUser;
  final VoidCallback? onTap;

  const _AudioCard({
    required this.title,
    this.subtitle,
    required this.elapsed,
    required this.duration,
    required this.isPlaying,
    required this.isPaused,
    required this.isSentByCurrentUser,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalDuration = duration > Duration.zero
        ? duration
        : _parseDuration(subtitle);
    final safeElapsed = totalDuration > Duration.zero && elapsed > totalDuration
        ? totalDuration
        : elapsed;
    final progress = totalDuration.inMilliseconds == 0
        ? 0.0
        : safeElapsed.inMilliseconds / totalDuration.inMilliseconds;
    final waveformColor = isSentByCurrentUser
        ? const Color(0xFF61C38D)
        : const Color(0xFF6AA8D3);
    final trailingStatus = isPlaying
        ? 'Playing'
        : isPaused
        ? 'Paused'
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1, end: isPlaying ? 1.08 : 1),
            duration: const Duration(milliseconds: 220),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isPlaying
                    ? const Color(0xFF2D8CFF)
                    : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: isPlaying
                    ? [
                        BoxShadow(
                          color: const Color(0x332D8CFF),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: AppColors.white,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 220.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24.h,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        children: List.generate(42, (index) {
                          final barProgress = (index + 1) / 42;
                          final isActive = progress >= barProgress;
                          final baseHeight = 6 + ((index % 6) * 2);
                          final animatedHeight = isPlaying && isActive
                              ? baseHeight + ((index % 3) + 2)
                              : baseHeight;
                          return Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 120 + ((index % 5) * 35),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 1.w),
                                width: 3.w,
                                height: animatedHeight.h,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? (isPlaying
                                            ? waveformColor
                                            : AppColors.primaryBlue)
                                      : const Color(0xFFB7C9D8),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      if (totalDuration > Duration.zero)
                        Positioned(
                          left: progress.clamp(0.0, 1.0) * 206.w,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: isPlaying
                                  ? const Color(0xFF43B3FF)
                                  : AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isPlaying
                                    ? const Color(0xFF43B3FF)
                                    : AppColors.primaryBlue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      isPlaying || isPaused
                          ? _formatDuration(safeElapsed)
                          : _formatDuration(totalDuration),
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.supportiveTextColor(context),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 10.sp,
                          color: AppColors.supportiveTextColor(context),
                        ),
                      ),
                    ),
                    if (trailingStatus != null)
                      Padding(
                        padding: EdgeInsets.only(left: 6.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? const Color(0xFFD9F2E5)
                                : const Color(0xFFE7F1F8),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isPlaying) const _PlayingPulse(),
                              if (isPlaying) SizedBox(width: 4.w),
                              Text(
                                trailingStatus,
                                style: GoogleFonts.openSans(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Duration _parseDuration(String? value) {
    if (value == null || value.isEmpty || !value.contains(':')) {
      return Duration.zero;
    }
    final parts = value.split(':');
    if (parts.length != 2) {
      return Duration.zero;
    }
    return Duration(
      minutes: int.tryParse(parts[0]) ?? 0,
      seconds: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString();
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayingPulse extends StatefulWidget {
  const _PlayingPulse();

  @override
  State<_PlayingPulse> createState() => _PlayingPulseState();
}

class _PlayingPulseState extends State<_PlayingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: const BoxDecoration(
          color: Color(0xFF1FA765),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
