import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:idiom_journey/screens/login-screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 352,
        height: 800,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(94, 94, 94, 1),
          
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 475.1080322265625,
              left: 1.946438312530518,
              child: Transform.rotate(
                angle: 18.841859264940062 * (math.pi / 180),
                child: Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(125),
                        topRight: Radius.circular(125),
                        bottomLeft: Radius.circular(125),
                        bottomRight: Radius.circular(125),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/Ch1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 8,
              left: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 580,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Mapa1.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 510,
              left: 226.5843048095703,
              child: Transform.rotate(
                angle: -9.729274627255453 * (math.pi / 180),
                child: Container(
                    width: 84.67021942138672,
                    height: 84.46644592285156,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/France1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          const Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Idiom Journey',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Irish Grover',
                  fontSize: 48,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  height: 1,
                ),
              ),
            ),
          ),
          Positioned(
              top: 453.8731384277344,
              left: 293,
              child: Transform.rotate(
                angle: 14.383697522876107 * (math.pi / 180),
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(86.5),
                        topRight: Radius.circular(86.5),
                        bottomLeft: Radius.circular(86.5),
                        bottomRight: Radius.circular(86.5),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/Spain21.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 500.8731384277344,
              left: 120,
              child: Transform.rotate(
                angle: 0,
                child: Container(
                    width: 112.59580993652344,
                    height: 114.77545166015625,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(120),
                        topRight: Radius.circular(120),
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/italy2.jpg'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 396,
              left: 10.117046356201172,
              child: Transform.rotate(
                angle: -10.24441433087375 * (math.pi / 180),
                child: Container(
                    width: 91,
                    height: 85,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/Russia2.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(top: 10, left: 11, child: Container()),
          Positioned(
              top: 495.9546203613281,
              left: 46.02082443237305,
              child: Transform.rotate(
                angle: -8.538832486718734 * (math.pi / 180),
                child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Germany11.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 405.1536865234375,
              left: 86,
              child: Transform.rotate(
                angle: 9.947945315072952 * (math.pi / 180),
                child: Container(
                    width: 116.66152954101562,
                    height: 104.0526123046875,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(150.5),
                        topRight: Radius.circular(150.5),
                        bottomLeft: Radius.circular(150.5),
                        bottomRight: Radius.circular(150.5),
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/images/Eng1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 400,
              left: 189.377197265625,
              child: Transform.rotate(
                angle: -5.089218963977061 * (math.pi / 180),
                child: Container(
                    width: 119,
                    height: 116.98304748535156,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Serb1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 680,
              left: (MediaQuery.of(context).size.width / 2) - 12.5,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    '^',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        decoration: TextDecoration.none,
                        fontFamily: 'Irish Grover',
                        fontSize: 25,
                        letterSpacing:
                            0,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
          Positioned(
              top: 700,
              left: (MediaQuery.of(context).size.width / 2) - 12.5,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    '^',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        decoration: TextDecoration.none,
                        fontFamily: 'Irish Grover',
                        fontSize: 25,
                        letterSpacing:
                            0 ,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
          Positioned(
              top: 720,
              left: (MediaQuery.of(context).size.width / 2) - 12.5,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(0.0, 1.0); 
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    '^',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        decoration: TextDecoration.none,
                        fontFamily: 'Irish Grover',
                        fontSize: 25,
                        letterSpacing:
                            0 ,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
          Positioned(
              top: 740,
              left: (MediaQuery.of(context).size.width / 2) - 12.5,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(0.0, 1.0); 
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    '^',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        decoration: TextDecoration.none,
                        fontFamily: 'Irish Grover',
                        fontSize: 25,
                        letterSpacing:
                            0 ,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
        ]));
  }
}
