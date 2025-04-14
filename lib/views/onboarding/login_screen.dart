import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_rbca/views/onboarding/verification_screen.dart';
import 'package:sample_rbca/views/owner/owner_screen.dart';
import 'package:sample_rbca/views/manager/manager_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();

            String? role = prefs.getString('role');

            switch (role) {
              case 'ROLE_ADMIN':
                Navigator.pushReplacementNamed(context, '/admin');
                break;

              case 'ROLE_ORGANIZATION':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OwnerScreen()),
                );
                break;
              case 'employee':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerScreen()),
                );
                break;
              default:
                break;
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Center( // Centering the content
            child: Padding(
              padding: EdgeInsets.only(
                top: screenPaddingTop * 3.0, // Reduced padding
                left: 24,
                right: 24,
                bottom: 40,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Welcome back! Please sign in to continue.",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus(); // Dismiss keyboard
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        BlocProvider.of<AuthBloc>(context).add(
                          SignInRequested(email: email, password: password),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007AFF), // Apple-like blue color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationScreen(
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Verify your email",
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF007AFF), width: 2),
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
