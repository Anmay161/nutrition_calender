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

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPass.dispose();
    super.dispose();
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
            // Background
            _Methods._background,
            // Bowl image
            _Methods._bowl,
            // Input form
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 410,
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
                            // Email field
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _email,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color.fromARGB(
                                    255,
                                    248,
                                    233,
                                    148,
                                  ),
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.merriweather(
                                    color: Colors.brown,
                                  ),
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
                            // Password
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _password,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                obscureText: !_icontoggle,
                                decoration: InputDecoration(
                                  isDense: true,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _icontoggle = !_icontoggle;
                                      });
                                    },
                                    icon: Icon(
                                      (_icontoggle)
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(
                                    255,
                                    248,
                                    233,
                                    148,
                                  ),
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.merriweather(
                                    color: Colors.brown,
                                  ),
                                  focusedBorder: _Methods._containerborder1,
                                  enabledBorder: _Methods._containerborder2,
                                ),
                                validator: (newValue) {
                                  newValue = newValue?.trim();
                                  if (newValue == null ||
                                      newValue.isEmpty ||
                                      !Regex.isValidPassword(newValue)) {
                                    return '''Password must be at least 6 characters long''';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Confirm password
                            SizedBox(
                              width: screensize.width * 0.85,
                              child: TextFormField(
                                controller: _confirmPass,
                                style: GoogleFonts.merriweather(fontSize: 15),
                                obscureText: !_icontoggle,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color.fromARGB(
                                    255,
                                    248,
                                    233,
                                    148,
                                  ),
                                  labelText: 'Confirm Password',
                                  labelStyle: GoogleFonts.merriweather(
                                    color: Colors.brown,
                                  ),
                                  focusedBorder: _Methods._containerborder1,
                                  enabledBorder: _Methods._containerborder2,
                                ),
                                validator: (newValue) {
                                  if (newValue == null ||
                                      newValue.trim() !=
                                          _password.text.trim()) {
                                    return 'Passwords must match';
                                  }
                                  return null;
                                },
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
