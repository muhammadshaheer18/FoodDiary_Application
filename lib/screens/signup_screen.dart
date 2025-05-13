import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD54F), // Golden yellow
              Color(0xFFF5A623), // Warm orange
            ],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Welcome to the table!"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFF43A047), // Green success color
                ),
              );
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFD84315), // Deep orange for error
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Header
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE65100).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.restaurant_menu, // Food menu icon
                        size: 60,
                        color: Color(0xFFFF8F00), // Amber accent
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Join Our Menu",
                      style: TextStyle(
                        color: Color(0xFF3E2723), // Dark brown text
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Email Field
                    TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: Color(0xFF3E2723),
                      ), // Dark brown text
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Color(0xFF5D4037),
                        ), // Brown label
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFFFF9800),
                        ), // Orange icon
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFFB74D),
                          ), // Light orange border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFF9800),
                            width: 2,
                          ), // Darker orange when focused
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      style: TextStyle(
                        color: Color(0xFF3E2723),
                      ), // Dark brown text
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Color(0xFF5D4037),
                        ), // Brown label
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFFFF9800),
                        ), // Orange icon
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility_off,
                            color: Color(0xFFFF9800),
                          ),
                          onPressed:
                              () {}, // Add toggle functionality if needed
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFFB74D),
                          ), // Light orange border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFFF9800),
                            width: 2,
                          ), // Darker orange when focused
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),

                    // Sign Up Button
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE65100).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF7043), // Deep orange
                            Color(0xFFFF9800), // Orange
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            context.read<AuthBloc>().add(
                              AuthSignUpRequested(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "RESERVE YOUR SPOT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Login Option
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already a regular? ",
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                          ), // Brown text
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Color(0xFFE65100), // Deep orange
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Loading Indicator
                    if (state is AuthLoading)
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Color(0xFFFF9800),
                          ), // Orange spinner
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
