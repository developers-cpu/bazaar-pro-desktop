import 'package:flutter/foundation.dart';
import '../../../../../core/constants/app_images.dart';
import '../models/shortcut_model.dart';
abstract class ShortcutsRemoteDataSource {
  Future<List<ShortcutModel>> getShortcuts();
}
class ShortcutsRemoteDataSourceImpl implements ShortcutsRemoteDataSource {
  @override
  Future<List<ShortcutModel>> getShortcuts() async {
    final cmdStr = defaultTargetPlatform == TargetPlatform.macOS
        ? 'CMD'
        : 'CTRL';
    return [
      const ShortcutModel(
        title: 'BUY',
        keyComb: 'F1/+',
        iconPath: AppImages.buyIcon,
      ),
      const ShortcutModel(
        title: 'Sell',
        keyComb: 'F2/-',
        iconPath: AppImages.sellIcon,
      ),
      const ShortcutModel(
        title: 'Pending Orders',
        keyComb: 'F3',
        iconPath: AppImages.pendingOrdersIcon,
      ),
      const ShortcutModel(
        title: 'Market Picture',
        keyComb: 'F5',
        iconPath: AppImages.menu1Icon,
      ),
      const ShortcutModel(
        title: 'Net Positions',
        keyComb: 'F6',
        iconPath: AppImages.menu2con,
      ),
      const ShortcutModel(
        title: 'Trades',
        keyComb: 'F8',
        iconPath: AppImages.menu3Icon,
      ),
      const ShortcutModel(
        title: 'Deals',
        keyComb: 'F9',
        iconPath: AppImages.menu4Icon,
      ),
      const ShortcutModel(
        title: 'Messages',
        keyComb: 'F10',
        iconPath: AppImages.messageIcon,
      ),
      ShortcutModel(
        title: 'Cut Symbol',
        keyComb: '$cmdStr + X',
        iconPath: AppImages.menu5Icon,
      ),
      ShortcutModel(
        title: 'Paste Symbol',
        keyComb: '$cmdStr + V',
        iconPath: AppImages.menu6Icon,
      ),
      ShortcutModel(
        title: 'Undo Symbol',
        keyComb: '$cmdStr + Z',
        iconPath: AppImages.reloadIcon,
      ),
    ];
  }
}
