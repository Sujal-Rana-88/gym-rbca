import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../constants/url_constants.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final Dio _dio = Dio();
  final _baseUrl = APPConstants.BASE_URL;
  final sendVerificationEmail = URLConstants.sendVerificationEmail;
  final verifyEmail = URLConstants.verifyEmail;
  final setPassword = URLConstants.setPassword;

  late final TextEditingController _emailController;
  late final TextEditingController _otpController;
  late final TextEditingController _passwordController;

  int _currentStep = 0;
  bool _isLoading = false;
  String? _userEmail;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationEmail() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        '$_baseUrl$sendVerificationEmail',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'userEmail': _emailController.text.trim()},
      );

      if (response.statusCode == 200) {
        setState(() {
          _userEmail = _emailController.text.trim();
          _currentStep = 1;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Failed to send OTP: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        '$_baseUrl$verifyEmail',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'userEmail': _userEmail,
          'activationCode': _otpController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _authToken = response.data['token'];
          _currentStep = 2;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Invalid OTP: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setPassword() async {
    if (_passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        '$_baseUrl$setPassword',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        }),
        data: {
          'userEmail': _userEmail,
          'password': _passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        _showSuccessSnackbar('Password set successfully!');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to set password: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenPaddingTop * 3.0,
            left: 24,
            right: 24,
            bottom: 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Text(
                  _currentStep == 0
                      ? "Verify Email"
                      : _currentStep == 1
                      ? "Enter OTP"
                      : "Set Password",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _currentStep == 0
                      ? "Please enter your email to receive a verification code"
                      : _currentStep == 1
                      ? "We sent a code to $_userEmail"
                      : "Create a new password for your account",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Dynamic Form Fields
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentStep == 0
                      ? _buildInputField(
                    controller: _emailController,
                    label: "Email Address",
                    icon: Icons.email_outlined,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  )
                      : _currentStep == 1
                      ? _buildInputField(
                    controller: _otpController,
                    label: "Verification Code",
                    icon: Icons.lock_outlined,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                  )
                      : _buildInputField(
                    controller: _passwordController,
                    label: "New Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 40),

                // Primary Action Button
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    if (_currentStep == 0) _sendVerificationEmail();
                    else if (_currentStep == 1) _verifyOtp();
                    else _setPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    _currentStep == 0 ? "Send OTP"
                        : _currentStep == 1 ? "Verify OTP"
                        : "Set Password",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),

                // Secondary Actions
                if (_currentStep == 1) ...[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading ? null : _sendVerificationEmail,
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],

                if (_currentStep == 2) ...[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
        ),
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
