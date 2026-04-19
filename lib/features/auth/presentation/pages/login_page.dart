import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/auth_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widget/custom_button.dart';
import '../widget/custom_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // String? _selectedServer;
  bool _obscurePassword = true;
  bool _backgroundImageError = false;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          expiresInMins: AuthConstants.tokenExpiryMinutes,
        ),
      );
    }
  }

  void _handleDemoLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        titlePadding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        title: Text(
          'Select Demo Account',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.primaryBlue,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDemoOption('Client'),
            _buildDemoOption('Master'),
            _buildDemoOption('Admin'),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoOption(String role) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
      ),
      hoverColor: AppColors.primaryBlue.withOpacity(0.15),
      title: Text(
        role,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: AppColors.primaryBlue,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.read<AuthBloc>().add(DemoLoginEvent(role: role));
      },
    );
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _backgroundImageError
            ? _buildGradientBackground(context)
            : _buildBackgroundWithImage(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: _handleAuthStateChange,
                builder: (context, state) {
                  if (state is AuthCheckingSession) {
                    return const SizedBox(
                      height: 360,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _buildForm(context, state is AuthLoading);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.marketWatch);
    } else if (state is AuthError) {
      var message = state.message;
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _showSnackBar(
        message,
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Container(
      width: 420,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(context),
            const SizedBox(height: AppDimensions.marginXL),
            _buildTitleSection(context),
            const SizedBox(height: AppDimensions.paddingL),
            // _buildServerDropdown(context),
            // const SizedBox(height: AppDimensions.paddingM),
            _buildUsernameField(context),
            const SizedBox(height: AppDimensions.paddingM),
            _buildPasswordField(context),
            const SizedBox(height: AppDimensions.paddingXL),
            _buildLoginButton(context, isLoading),
            const SizedBox(height: AppDimensions.paddingM),
            _buildFooterLinks(context),
            const SizedBox(height: AppDimensions.paddingXL),
            _buildFooterText(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundWithImage() {
    return BoxDecoration(
      image: DecorationImage(
        image: const AssetImage(AppImages.loginBackgroundGif),
        fit: BoxFit.cover,
        onError: (_, __) {
          if (mounted) setState(() => _backgroundImageError = true);
        },
      ),
    );
  }

  BoxDecoration _buildGradientBackground(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [DarkThemeColors.backgroundColor, DarkThemeColors.cardBackground]
            : [
                AppColors.headerBgColor,
                AppColors.white,
                AppColors.headerBgColor,
              ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.marginL),
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.contain,
            opacity: const AlwaysStoppedAnimation(1.0),
            errorBuilder: (_, __, ___) => _buildFallbackLogo(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AuthConstants.appName,
          style: GoogleFonts.openSans(
            color: AppColors.white,
            fontSize: AppDimensions.fontSizeXXL,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          'P',
          style: GoogleFonts.openSans(
            color: AppColors.secondaryColor(context),
            fontSize: AppDimensions.fontSizeXXL + 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AuthConstants.loginTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.primaryColor(context),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          AuthConstants.loginSubtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: AppDimensions.fontSizeS,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0.25,
            color: AppColors.primaryColor(context),
          ),
        ),
      ],
    );
  }

  // Widget _buildServerDropdown(BuildContext context) {
  //   return CustomDropdownField(
  //     hintText: AuthConstants.selectServerLabel,
  //     value: _selectedServer,
  //     items: [
  //       DropdownOption(
  //         value: AuthConstants.serverRGX,
  //         label: AuthConstants.serverRGX,
  //         iconPath: AppImages.dropDown1,
  //         trailingIconPath: AppImages.serverIcon,
  //       ),
  //       DropdownOption(
  //         value: AuthConstants.serverTests,
  //         label: AuthConstants.serverRGX,
  //         iconPath: AppImages.dropDown2,
  //         trailingIconPath: AppImages.serverIcon,
  //       ),
  //       DropdownOption(
  //         value: AuthConstants.serverForex,
  //         label: AuthConstants.serverForex,
  //         iconPath: AppImages.dropDown3,
  //         trailingIconPath: AppImages.serverIcon,
  //       ),
  //     ],
  //     onChanged: (value) => setState(() => _selectedServer = value!),
  //   );
  // }

  Widget _buildUsernameField(BuildContext context) {
    return CustomInputField(
      hintText: AuthConstants.usernameLabel,
      controller: _usernameController,
      svgIconPath: AppImages.input2,
      validator: (value) =>
          value?.isEmpty ?? true ? AuthConstants.emptyUsernameError : null,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomInputField(
      hintText: AuthConstants.passwordLabel,
      controller: _passwordController,
      obscureText: _obscurePassword,
      suffixIcon: _obscurePassword
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined,
      onSuffixIconPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      validator: (value) =>
          value?.isEmpty ?? true ? AuthConstants.emptyPasswordError : null,
    );
  }

  Widget _buildLoginButton(BuildContext context, bool isLoading) {
    return CustomButton(
      text: AuthConstants.loginButtonText,
      onPressed: _handleLogin,
      isLoading: isLoading,
      backgroundColor: AppColors.primaryColor(context),
      borderColor: AppColors.primaryColor(context),
    );
  }

  Widget _buildFooterLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextLink(
          context,
          text: AuthConstants.demoLoginText,
          onPressed: _handleDemoLogin,
        ),
        _buildTextLink(
          context,
          text: AuthConstants.forgotPasswordText,
          onPressed: () =>
              _showSnackBar(AuthConstants.forgotPasswordComingSoon),
        ),
      ],
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Column(
      children: [
        Text(
          AuthConstants.educationPurposeText,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: AppDimensions.fontSizeM,
            height: 1.0,
            letterSpacing: 0.1,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          AuthConstants.versionText,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: AppDimensions.fontSizeM,
            height: 1.0,
            letterSpacing: 0.1,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),
        _buildLegalLinks(context),
      ],
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextLink(
            context,
            text: AuthConstants.termsAndConditionsText,
            onPressed: () => _showSnackBar(AuthConstants.termsComingSoon),
          ),
          const SizedBox(height: AppDimensions.paddingXS + 1),
          _buildTextLink(
            context,
            text: AuthConstants.privacyPolicyText,
            onPressed: () => _showSnackBar(AuthConstants.privacyComingSoon),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLink(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
        overlayColor: AppColors.transparent,
        foregroundColor: AppColors.primaryBlue,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          fontSize: AppDimensions.fontSizeM,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.1,
          color: AppColors.primaryBlue,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primaryBlue,
          decorationThickness: 2,
          decorationStyle: TextDecorationStyle.solid,
        ),
      ),
    );
  }
}
