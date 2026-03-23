import 'package:equatable/equatable.dart';

class ShortcutEntity extends Equatable {
  final String title;
  final String keyComb;
  final String iconPath;
  const ShortcutEntity({
    required this.title,
    required this.keyComb,
    required this.iconPath,
  });
  @override
  List<Object?> get props => [title, keyComb, iconPath];
}
