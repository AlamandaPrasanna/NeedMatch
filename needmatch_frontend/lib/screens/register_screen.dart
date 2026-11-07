import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String accountType = 'Individual';

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final location = locationController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        location.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    if (!email.contains('@')) {
      showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        location: location,
      );

      if (!mounted) return;

      showMessage(
        '$accountType account created successfully!',
        success: true,
      );

      /*
       * Registration creates the account on Django.
       *
       * We then send the user back to Login so they can
       * authenticate using the newly created account.
       */
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      String message = e.toString();

      if (message.startsWith('Exception:')) {
        message = message.replaceFirst('Exception: ', '');
      }

      showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void showMessage(
    String message, {
    bool success = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            success ? const Color(0xFF168B45) : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 15),

                // LOGO
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/heart.jpeg',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Join NeedMatch and make a difference.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ACCOUNT TYPE
                const Text(
                  'Account Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: accountTypeButton(
                        title: 'Individual',
                        icon: Icons.person_outline,
                        selected: accountType == 'Individual',
                        onTap: () {
                          setState(() {
                            accountType = 'Individual';
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: accountTypeButton(
                        title: 'Organization',
                        icon: Icons.business_outlined,
                        selected: accountType == 'Organization',
                        onTap: () {
                          setState(() {
                            accountType = 'Organization';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // NAME
                buildLabel(
                  accountType == 'Individual'
                      ? 'Full Name'
                      : 'Organization Name',
                ),

                const SizedBox(height: 8),

                buildTextField(
                  controller: nameController,
                  hint: accountType == 'Individual'
                      ? 'Enter your full name'
                      : 'Enter organization name',
                  icon: accountType == 'Individual'
                      ? Icons.person_outline
                      : Icons.business_outlined,
                ),

                const SizedBox(height: 18),

                // EMAIL
                buildLabel('Email Address'),

                const SizedBox(height: 8),

                buildTextField(
                  controller: emailController,
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                // PHONE
                buildLabel('Phone Number'),

                const SizedBox(height: 8),

                buildTextField(
                  controller: phoneController,
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 18),

                // LOCATION
                buildLabel('Location'),

                const SizedBox(height: 8),

                buildTextField(
                  controller: locationController,
                  hint: 'City, State',
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 18),

                // PASSWORD
                buildLabel('Password'),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  enabled: !_isLoading,

                  decoration: inputDecoration(
                    hint: 'Create a password',
                    icon: Icons.lock_outline,

                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),

                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                obscurePassword =
                                    !obscurePassword;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // CONFIRM PASSWORD
                buildLabel('Confirm Password'),

                const SizedBox(height: 8),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  enabled: !_isLoading,

                  decoration: inputDecoration(
                    hint: 'Re-enter your password',
                    icon: Icons.lock_outline,

                    suffix: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),

                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // VERIFICATION NOTICE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8F3),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: const [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFF168B45),
                        size: 22,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'NeedMatch may verify your account '
                          'to help maintain a safe and trusted '
                          'community.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // CREATE ACCOUNT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : createAccount,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF168B45),
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 22),

                // LOGIN
                Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },

                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF168B45),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget accountTypeButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,

      child: Container(
        height: 90,

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEAF7EF)
              : Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? const Color(0xFF168B45)
                : Colors.grey.shade300,

            width: selected ? 2 : 1,
          ),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 28,

              color: selected
                  ? const Color(0xFF168B45)
                  : Colors.grey,
            ),

            const SizedBox(height: 7),

            Text(
              title,

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,

                color: selected
                    ? const Color(0xFF168B45)
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: !_isLoading,

      decoration: inputDecoration(
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: Color(0xFF168B45),
          width: 2,
        ),
      ),
    );
  }
}