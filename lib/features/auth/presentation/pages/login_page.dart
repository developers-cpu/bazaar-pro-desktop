import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/auth_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widget/custom_button.dart';
import '../widget/custom_dropdown_field.dart';
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
  String? _selectedServer;
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
    context.read<AuthBloc>().add(const DemoLoginEvent());
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
    final isDark = AppColors.isDarkMode(context);

    return Scaffold(
      body: Container(
        decoration: _backgroundImageError
            ? _buildGradientBackground(isDark)
            : _buildBackgroundWithImage(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: _handleAuthStateChange,
                builder: (context, state) {
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
    if (state is AuthError) {
      _showSnackBar(state.message, backgroundColor: AppColors.errorColor);
    } else if (state is AuthAuthenticated) {
      _showSnackBar(
        AuthConstants.loginSuccessMessage,
        backgroundColor: AppColors.successColor,
      );
      Navigator.of(context).pushReplacementNamed('/market-watch');
    }
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(context),
            const SizedBox(height: 40),
            _buildTitleSection(context),
            const SizedBox(height: 24),
            _buildServerDropdown(context),
            const SizedBox(height: 16),
            _buildUsernameField(context),
            const SizedBox(height: 16),
            _buildPasswordField(context),
            const SizedBox(height: 24),
            _buildLoginButton(context, isLoading),
            const SizedBox(height: 16),
            _buildFooterLinks(context),
            const SizedBox(height: 32),
            _buildFooterText(context),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // BACKGROUND
  // ─────────────────────────────────────────────────────────────────

  BoxDecoration _buildBackgroundWithImage() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(AppImages.loginBackgroundGif),
        fit: BoxFit.cover,
        onError: (_, __) {
          if (mounted) setState(() => _backgroundImageError = true);
        },
      ),
    );
  }

  BoxDecoration _buildGradientBackground(bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFF0D0D0D), const Color(0xFF1A1A1A)]
            : [const Color(0xFFE3F2FD), Colors.white, const Color(0xFFE3F2FD)],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // HEADER SECTION
  // ─────────────────────────────────────────────────────────────────

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 140,
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
    final isDark = AppColors.isDarkMode(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'BAZAAR',
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          'P',
          style: TextStyle(
            color: AppColors.secondaryColor(context),
            fontSize: 24,
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
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.primaryColor(context),
          ),
        ),


        const SizedBox(height: 8),
        Text(
          AuthConstants.loginSubtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0.25,
            color: AppColors.primaryColor(context),
          ),
        ),

      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // FORM FIELDS
  // ─────────────────────────────────────────────────────────────────

  Widget _buildServerDropdown(BuildContext context) {
    return CustomDropdownField(
      hintText: AuthConstants.selectServerLabel,
      value: _selectedServer,
      items: [
        DropdownOption(
          value: 'RGX',
          label: 'RGX',
          iconPath: AppImages.dropDown1,
          trailingIconPath: AppImages.serverIcon,
        ),
        DropdownOption(
          value: 'TESTS',
          label: 'TESTS',
          iconPath: AppImages.dropDown2,
          trailingIconPath: AppImages.serverIcon,
        ),
        DropdownOption(
          value: 'FOREXSERVER',
          label: 'FOREXSERVER',
          iconPath: AppImages.dropDown3,
          trailingIconPath: AppImages.serverIcon,
        ),
      ],
      onChanged: (value) => setState(() => _selectedServer = value!),

    );
  }

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
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
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

  // ─────────────────────────────────────────────────────────────────
  // FOOTER SECTION
  // ─────────────────────────────────────────────────────────────────

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
          onPressed: () => _showSnackBar('Forgot password feature coming soon!'),
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
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0.1,
            color: const Color(0xFF1F4A66),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AuthConstants.versionText,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0.1,
            color: const Color(0xFF1F4A66),
          ),
        ),
        const SizedBox(height: 16),
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

            onPressed: () => _showSnackBar('Terms & Conditions page coming soon!'),
          ),
          SizedBox(height: 5,),
          _buildTextLink(
            context,
            text: AuthConstants.privacyPolicyText,

            onPressed: () => _showSnackBar('Privacy Policy page coming soon!'),
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
    const Color textColor = Color(0xFF1F4A66);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
        overlayColor: Colors.transparent,
        foregroundColor: textColor,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.0,
          letterSpacing: 0.1,
          color: textColor,
          decoration: TextDecoration.underline,
          decorationColor: textColor,
          decorationThickness: 2,
          decorationStyle: TextDecorationStyle.solid,
        ),
      ),
    );
  }

}