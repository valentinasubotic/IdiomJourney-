import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idiom_journey/screens/registration-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idiom_journey/services/firebase-auth-methods.dart';
import 'package:idiom_journey/utils/showSnackBar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscured = true;  

  @override
  void initState() {
    super.initState();

    _focusNodeEmail.addListener(() {
      setState(() {});
    });

    _focusNodePassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> _showForgotPasswordDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unesite vašu email adresu'),
          backgroundColor: Color.fromRGBO(218, 218, 218, 1),
          content: TextField(
            controller: emailController,
            cursorColor: Color.fromRGBO(94, 94, 94, 1),  
            decoration: const InputDecoration(
              hintText: "Email adresa",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(94, 94, 94, 1),  
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(94, 94, 94, 1),  
                  width: 2.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop("");
              },
              style: TextButton.styleFrom(
                foregroundColor: Color.fromRGBO(94, 94, 94, 1),
              ),
              child: Text('Odustani'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(emailController.text);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Color.fromRGBO(94, 94, 94, 1),  
              ),
              child: Text('Pošalji'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Link za resetovanje lozinke je poslan na email.');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Došlo je do greške.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Korisnik sa ovom email adresom nije pronađen.';
      }
      showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(218, 218, 218, 1),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -30,
                left: 0,
                child: Container(
                  width: screenWidth,
                  height: 254,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/hi.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 243,
                left: 27,
                child: Text(
                  'Dobrodošli!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
               
              Positioned(
                top: screenHeight * 0.36,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(94, 94, 94, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'PRIJAVA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, _createRouteToRegistration());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(218, 218, 218, 1),
                            border: Border.all(
                              color: Color.fromRGBO(94, 94, 94, 1),
                              width: 2.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'REGISTRACIJA',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: screenHeight * 0.46,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Container(
                  width: screenWidth * 0.8,
                  child: TextField(
                    controller: _emailController,
                    focusNode: _focusNodeEmail,
                    cursorColor: Color.fromRGBO(94, 94, 94, 1),
                    decoration: InputDecoration(
                      labelText: 'Unesite email adresu',
                      labelStyle: TextStyle(
                        color: _focusNodeEmail.hasFocus
                            ? Color.fromRGBO(94, 94, 94, 1)
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(94, 94, 94, 1),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.55,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Container(
                  width: screenWidth * 0.8,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: isObscured,
                    focusNode: _focusNodePassword,
                    cursorColor: Color.fromRGBO(94, 94, 94, 1),
                    decoration: InputDecoration(
                      labelText: 'Unesite lozinku',
                      labelStyle: TextStyle(
                        color: _focusNodePassword.hasFocus
                            ? Color.fromRGBO(94, 94, 94, 1)
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(94, 94, 94, 1),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.65,
                left: screenWidth * 0.3,
                child: GestureDetector(
                  onTap: _loginUser,
                  child: Container(
                    width: screenWidth * 0.4,
                    height: 53,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromRGBO(94, 94, 94, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'PRIJAVI SE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.71,
                left: screenWidth * 0.6,
                child: TextButton(
                  onPressed: () async {
                    String email = await _showForgotPasswordDialog(context);
                    if (email.isNotEmpty) {
                      _resetPassword(email, context);
                    }
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Color.fromRGBO(179, 178, 178, 1);
                        }
                        return null;
                      },
                    ),
                  ),
                  child: const Text(
                    'Zaboravili ste lozinku?',
                    style: TextStyle(
                      color: Color.fromRGBO(224, 1, 1, 1),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.79,
                left: 0,
                right: 0,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Prijavi se sa Google nalogom',
                      textAlign: TextAlign.center,  
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: screenHeight * 0.84,
                left: 0,
                right: 0,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Prijavi se sa Facebook nalogom',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRouteToRegistration() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        RegistrationScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
