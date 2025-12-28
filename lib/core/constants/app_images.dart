/// Constants for app images and assets
class AppImages {
  AppImages._();

  static const String _imagesPath = 'assets/images';
  static const String _gifsPath = 'assets/gifs';
  static const String _iconsPath = 'assets/icons/auth';
  static const String _commonIconsPath = 'assets/icons/market';

  // Images
  static const String appLogo = '$_imagesPath/bazaar_logo.png';
  static const String loginBackgroundGif = '$_gifsPath/login_background.gif';
  static const String userPlaceholder = '$_imagesPath/user_placeholder.png';

  // Input Field SVG Icons
  static const String input1 = '$_iconsPath/driver.svg';
  static const String input2 = '$_iconsPath/profile.svg';
  static const String input3 = '$_iconsPath/view.svg';

  // Dropdown Item Icons (Leading icons - left side)
  static const String dropDown1 = '$_iconsPath/dp1.png';
  static const String dropDown2 = '$_iconsPath/dp2.png';
  static const String dropDown3 = '$_iconsPath/dp3.png';

  // Server Icon (Trailing icons - right side in dropdown)
  static const String serverIcon = '$_iconsPath/driver.svg';

  // AppBar Icons
  static const String reloadIcon = '$_commonIconsPath/reload.svg';
  static const String logoutIcon = '$_commonIconsPath/logout.svg';
}