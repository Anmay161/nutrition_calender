import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_calender/components/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_calender/constants/values.dart';
import 'package:nutrition_calender/pages/verification_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SigninPage> {
  final _formkey = GlobalKey<FormState>();
  bool _icontoggle = false;
  bool _isloading = false;

  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _confirmPass;
  late TextEditingController _username;
  late TextEditingController _mobile;

  double _passwordStrength = 0;
  String _passwordStrengthText = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPass = TextEditingController();
    _username = TextEditingController();
    _mobile = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPass.dispose();
    _username.dispose();
    _mobile.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordStrengthText = "";
      });
      return;
    }

    if (password.length >= 6) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (password.contains(RegExp(r'\d'))) strength += 0.125;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength += 0.125;

    setState(() {
      _passwordStrength = strength;

      if (strength <= 0.25) {
        _passwordStrengthText = "Weak";
      } else if (strength <= 0.5) {
        _passwordStrengthText = "Fair";
      } else if (strength <= 0.75) {
        _passwordStrengthText = "Good";
      } else {
        _passwordStrengthText = "Strong";
      }
    });
  }

  Widget _buildPasswordRequirements(String password) {
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'\d'));
    bool hasSymbol = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    bool hasLength = password.length >= 6;

    Widget buildItem(bool condition, String text) {
      return Row(
        children: [
          Icon(
            condition ? Icons.check_circle : Icons.cancel,
            color: condition ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: condition ? Colors.green : Colors.red)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildItem(hasUpper, "At least 1 uppercase letter"),
        buildItem(hasLower, "At least 1 lowercase letter"),
        buildItem(hasDigit, "At least 1 digit"),
        buildItem(hasSymbol, "At least 1 symbol"),
        buildItem(hasLength, "Minimum 6 characters"),
      ],
    );
  }

  Future<void> addUser() async {
    late String message;
    try {
      setState(() {
        _isloading = true;
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      bool isNew = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (mounted) {
        if (!isNew) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }

      message = 'Sign up successful. Please verify your email.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          message = 'That email is already registered.';
          break;
        default:
          message = 'Something went wrong. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  bool checkForm() {
    final form = _formkey.currentState!.validate();
    return form;
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _Methods._background,
            _Methods._bowl,
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 520,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(50, 50),
                    topRight: Radius.elliptical(50, 50),
                  ),
                ),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 25,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.merriweather(
                            fontSize: 32,
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 20,
                          children: [
                            // Username
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _username,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 248, 233, 148),
                                  labelText: 'Username',
                                  labelStyle: GoogleFonts.merriweather(color: Colors.brown),
                                  focusedBorder: _Methods._containerborder1,
                                  enabledBorder: _Methods._containerborder2,
                                ),
                                validator: (newValue) {
                                  if (newValue == null || newValue.trim().isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Mobile Number
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _mobile,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 248, 233, 148),
                                  labelText: 'Mobile Number',
                                  hintText: 'e.g. +8801XXXXXXXXX',
                                  labelStyle: GoogleFonts.merriweather(color: Colors.brown),
                                  focusedBorder: _Methods._containerborder1,
                                  enabledBorder: _Methods._containerborder2,
                                ),
                                validator: (newValue) {
                                  if (newValue == null || newValue.trim().isEmpty) {
                                    return 'Please enter mobile number';
                                  }
                                  if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(newValue.trim())) {
                                    return 'Enter a valid mobile number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Email
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _email,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 248, 233, 148),
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.merriweather(color: Colors.brown),
                                  focusedBorder: _Methods._containerborder1,
                                  enabledBorder: _Methods._containerborder2,
                                ),
                                validator: (newValue) {
                                  newValue = newValue?.trim();
                                  if (newValue == null ||
                                      newValue.isEmpty ||
                                      !Regex.isValidEmail(newValue)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Password Section (New Order)
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ✅ Password requirements checklist
                                  _buildPasswordRequirements(_password.text),
                                  const SizedBox(height: 10),

                                  // ✅ Strength Indicator
                                  LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.grey[300],
                                    color: _passwordStrength <= 0.25
                                        ? Colors.red
                                        : _passwordStrength <= 0.5
                                            ? Colors.orange
                                            : _passwordStrength <= 0.75
                                                ? Colors.blue
                                                : Colors.green,
                                    minHeight: 6,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _passwordStrengthText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _passwordStrength <= 0.25
                                          ? Colors.red
                                          : _passwordStrength <= 0.5
                                              ? Colors.orange
                                              : _passwordStrength <= 0.75
                                                  ? Colors.blue
                                                  : Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // ✅ Password field
                                  TextFormField(
                                    controller: _password,
                                    style: GoogleFonts.merriweather(fontSize: 15),
                                    obscureText: !_icontoggle,
                                    onChanged: _checkPasswordStrength,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _icontoggle = !_icontoggle;
                                          });
                                        },
                                        icon: Icon(
                                          (_icontoggle) ? Icons.visibility : Icons.visibility_off,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color.fromARGB(255, 248, 233, 148),
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.merriweather(color: Colors.brown),
                                      focusedBorder: _Methods._containerborder1,
                                      enabledBorder: _Methods._containerborder2,
                                    ),
                                    validator: (newValue) {
                                      newValue = newValue?.trim();
                                      if (newValue == null || newValue.isEmpty) {
                                        return 'Password is required';
                                      }

                                      if (!Regex.isValidPassword(newValue)) {
                                        return 'Password must meet all requirements';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),

                                  // ✅ Confirm Password field
                                  TextFormField(
                                    controller: _confirmPass,
                                    style: GoogleFonts.merriweather(fontSize: 15),
                                    obscureText: !_icontoggle,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: const Color.fromARGB(255, 248, 233, 148),
                                      labelText: 'Confirm Password',
                                      hintText: 'Re-enter your password',
                                      labelStyle: GoogleFonts.merriweather(color: Colors.brown),
                                      focusedBorder: _Methods._containerborder1,
                                      enabledBorder: _Methods._containerborder2,
                                    ),
                                    validator: (newValue) {
                                      if (newValue == null || newValue.trim() != _password.text.trim()) {
                                        return 'Passwords must match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            _isloading
                                ? const CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () {
                                      if (checkForm()) {
                                        addUser();
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: screensize.width * 0.85,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black,
                                      ),
                                      child: Text(
                                        'Sign in',
                                        style: GoogleFonts.merriweather(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Methods {
  static final _background = Container(
    width: double.infinity,
    height: double.infinity,
    color: const Color.fromARGB(255, 248, 196, 148),
  );

  static final _bowl = Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: 350,
      height: 250,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Login_Signin.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    ),
  );

  static final _containerborder1 = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.brown, width: 3),
  );

  static final _containerborder2 = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.white),
  );
}
