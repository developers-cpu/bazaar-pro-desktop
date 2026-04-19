class AuthConstants {
  AuthConstants._();
  static const String baseUrl = 'https://equity.bazaarpro.app';
  static const String loginEndpoint = '/auth/login';
  static const String authHiveBoxName = 'auth_session';
  static const String authHiveUserKey = 'user_json';
  static const String authHiveJwtKey = 'jwt_token';
  static const String authHiveApiTokenKey = 'api_token';
  static const String refreshTokenEndpoint = '';
  static const String demoUsername = 'emilys';
  static const String demoPassword = 'emilyspass';
  static const String clientUsername = 'client@bazarpro.com';
  static const String clientPassword = 'client@bazarpro';
  static const String masterUsername = 'master@bazarpro.com';
  static const String masterPassword = 'master@bazarpro';
  static const String adminUsername = 'admin@@bazarpro.com';
  static const String adminPassword = 'admin@@bazarpro';
  static const String superAdminUsername = 'superadmin@bazarpro.com';
  static const String superAdminPassword = 'superadmin@bazarpro';
  static const int tokenExpiryMinutes = 30;
  static const String appName = 'BAZAAR';
  static const String loginTitle = 'Log In';
  static const String loginSubtitle = 'Glad you\'re back.!';
  static const String selectServerLabel = 'Select Server';
  static const String usernameLabel = 'Username';
  static const String passwordLabel = 'Password';
  static const String loginButtonText = 'Login';
  static const String demoLoginText = 'Demo Login';
  static const String forgotPasswordText = 'Forgot Password';
  static const String educationPurposeText =
      'This application is Used for Education Purpose Only.';
  static const String versionText = 'Version 1.2.2';
  static const String termsAndConditionsText = 'Terms & Conditions';
  static const String privacyPolicyText = 'Privacy Policy';
  static const String emptyUsernameError = 'Please enter username';
  static const String emptyPasswordError = 'Please enter password';
  static const String loginSuccessMessage = 'Login successful!';
  static const String loginFailedMessage = 'Login failed. Please try again.';
  static const String invalidCredentialsMessage =
      'Invalid username or password';
  static const String forgotPasswordComingSoon =
      'Forgot password feature coming soon!';
  static const String termsComingSoon = 'Terms & Conditions page coming soon!';
  static const String privacyComingSoon = 'Privacy Policy page coming soon!';
  static const String serverRGX = 'RGX';
  static const String serverTests = 'TESTS';
  static const String serverForex = 'FOREXSERVER';
}
