import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/auth_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Login page with authentication form
/// Matches the design from the screenshots
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedServer = AuthConstants.serverOptions.first;
  bool _obscurePassword = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.loginBackgroundGif),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.errorColor,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else if (state is AuthAuthenticated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AuthConstants.loginSuccessMessage),
                        backgroundColor: AppColors.successColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // Navigate to market watch page after successful login
                    Navigator.of(context).pushReplacementNamed('/market-watch');
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo
                        _buildLogo(),
                        const SizedBox(height: AppDimensions.marginXL),

                        // Login Title
                        _buildTitle(),
                        const SizedBox(height: AppDimensions.marginL),

                        // Server Selection
                        _buildServerDropdown(),
                        const SizedBox(height: AppDimensions.marginM),

                        // Username Field
                        _buildUsernameField(),
                        const SizedBox(height: AppDimensions.marginM),

                        // Password Field
                        _buildPasswordField(),
                        const SizedBox(height: AppDimensions.marginXL),

                        // Login Button
                        _buildLoginButton(isLoading),
                        const SizedBox(height: AppDimensions.marginM),

                        // Demo Login & Forgot Password
                        _buildFooterLinks(),
                        const SizedBox(height: AppDimensions.marginXL),

                        // Education Purpose Text
                        _buildEducationText(),
                        const SizedBox(height: AppDimensions.marginS),

                        // Version
                        _buildVersionText(),
                        const SizedBox(height: AppDimensions.marginM),

                        // Terms & Privacy
                        _buildLegalLinks(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          AppImages.appLogo,
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.storefront, size: 48, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  AuthConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          AuthConstants.loginTitle,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeXXL,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AuthConstants.loginSubtitle,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeM,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServerDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        border: Border.all(color: AppColors.borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: DropdownButtonFormField<String>(
        value: _selectedServer,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.dns, color: AppColors.primaryBlue),
          hintText: AuthConstants.selectServerLabel,
        ),
        items: AuthConstants.serverOptions.map((server) {
          return DropdownMenuItem(
            value: server,
            child: Text(server),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedServer = value!;
          });
        },
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: AuthConstants.usernameLabel,
        prefixIcon: Icon(Icons.person, color: AppColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AuthConstants.emptyUsernameError;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: AuthConstants.passwordLabel,
        prefixIcon: Icon(Icons.lock, color: AppColors.primaryBlue),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.secondaryTextColor,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AuthConstants.emptyPasswordError;
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          AuthConstants.loginButtonText,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeL,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _handleDemoLogin,
          child: Text(
            AuthConstants.demoLoginText,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: AppDimensions.fontSizeM,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement forgot password
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Forgot password feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            AuthConstants.forgotPasswordText,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: AppDimensions.fontSizeM,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationText() {
    return Text(
      AuthConstants.educationPurposeText,
      style: TextStyle(
        fontSize: AppDimensions.fontSizeS,
        color: AppColors.secondaryTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVersionText() {
    return Text(
      AuthConstants.versionText,
      style: TextStyle(
        fontSize: AppDimensions.fontSizeS,
        color: AppColors.secondaryTextColor,
      ),
    );
  }

  Widget _buildLegalLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // TODO: Implement terms and conditions
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terms & Conditions page coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            AuthConstants.termsAndConditionsText,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: AppDimensions.fontSizeS,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          ' | ',
          style: TextStyle(
            color: AppColors.secondaryTextColor,
            fontSize: AppDimensions.fontSizeS,
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement privacy policy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Privacy Policy page coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text(
            AuthConstants.privacyPolicyText,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: AppDimensions.fontSizeS,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}