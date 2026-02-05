import '../../domain/entities/shortcut_entity.dart';
class ShortcutModel extends ShortcutEntity {
  const ShortcutModel({
    required String title,
    required String keyComb,
    required String iconPath,
  }) : super(title: title, keyComb: keyComb, iconPath: iconPath);
  factory ShortcutModel.fromJson(Map<String, dynamic> json) {
    return ShortcutModel(
      title: json['title'],
      keyComb: json['keyComb'],
      iconPath: json['iconPath'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'title': title, 'keyComb': keyComb, 'iconPath': iconPath};
  }
}
