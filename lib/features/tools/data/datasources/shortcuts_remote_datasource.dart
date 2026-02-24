import '../../../../../core/constants/app_images.dart';
import '../models/shortcut_model.dart';

abstract class ShortcutsRemoteDataSource {
  Future<List<ShortcutModel>> getShortcuts();
}

class ShortcutsRemoteDataSourceImpl implements ShortcutsRemoteDataSource {
  @override
  Future<List<ShortcutModel>> getShortcuts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const ShortcutModel(
        title: 'BUY',
        keyComb: 'F1',
        iconPath: AppImages.buyIcon,
      ),
      const ShortcutModel(
        title: 'Sell',
        keyComb: 'F2',
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
      const ShortcutModel(
        title: 'Cut Symbol',
        keyComb: 'CTRL + X',
        iconPath: AppImages.menu5Icon,
      ),
      const ShortcutModel(
        title: 'Paste Symbol',
        keyComb: 'CTRL + V',
        iconPath: AppImages.menu6Icon,
      ),
      const ShortcutModel(
        title: 'Undo Symbol',
        keyComb: 'CTRL + Z',
        iconPath: AppImages.reloadIcon,
      ),
      const ShortcutModel(
        title: 'Select Symbol Upside',
        keyComb: 'UP ARROW',
        iconPath: AppImages.menu7Icon,
      ),
      const ShortcutModel(
        title: 'Select Symbol Downside',
        keyComb: 'DOWN ARROW',
        iconPath: AppImages.menu8Icon,
      ),
    ];
  }
}
