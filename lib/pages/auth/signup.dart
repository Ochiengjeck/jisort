import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jisort/provider/providers.dart';
import 'package:jisort/utils/widgets/custom_social_button.dart';
import 'package:jisort/utils/widgets/custom_text_field.dart';
import 'package:jisort/pages/home_page.dart';
import 'package:jisort/utils/my_controllers.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = MyControllers.signUpFirstNameController();
  final _lastNameController = MyControllers.signUpLastNameController();
  final _usernameController = MyControllers.signUpUsernameController();
  final _emailController = MyControllers.signUpEmailController();
  final _phoneController = MyControllers.signUpPhoneController();
  final _passwordController = MyControllers.signUpPasswordController();
  final _confirmPasswordController =
      MyControllers.signUpConfirmPasswordController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    MyControllers.disposeControllers([
      _firstNameController,
      _lastNameController,
      _usernameController,
      _emailController,
      _phoneController,
      _passwordController,
      _confirmPasswordController,
    ]);
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authProvider.notifier).signUp(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              username: _usernameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              password: _passwordController.text,
              passwordConfirmation: _confirmPasswordController.text,
            );
        final authState = ref.read(authProvider);
        if (authState.user != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF071B80),
                    const Color(0xFF121212),
                    const Color(0xFF7A0BE5).withOpacity(0.3),
                  ]
                : [
                    const Color(0xFF667EEA),
                    const Color(0xFFF7F7F7),
                    const Color(0xFF764BA2).withOpacity(0.3),
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () =>
                            ref.read(themeProvider.notifier).toggleTheme(),
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Create\\nAccount',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join us to start your journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            customTextFieldWidget(
                              context: context,
                              controller: _firstNameController,
                              label: 'First Name',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'First name is required';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _lastNameController,
                              label: 'Last Name',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Last name is required';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value!)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^\+?[1-9]\d{1,14}$')
                                    .hasMatch(value!)) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outlined,
                              obscureText: !_isPasswordVisible,
                              showVisibilityToggle: true,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Password is required';
                                }
                                if (value!.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            customTextFieldWidget(
                              context: context,
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              icon: Icons.lock_outlined,
                              obscureText: !_isConfirmPasswordVisible,
                              showVisibilityToggle: true,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Confirm password is required';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            if (authState.error != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  authState.error!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: authState.isLoading ? null : _signUp,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                ),
                                child: authState.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            customSocialButton(
                              Icons.g_mobiledata,
                              'Continue with Google',
                              () {},
                            ),
                            customSocialButton(
                              Icons.apple,
                              'Continue with Apple',
                              () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
