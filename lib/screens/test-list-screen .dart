import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/test-screen.dart';

class TestListScreen extends StatefulWidget {
  @override
  _TestListScreenState createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  int passedTests = 0;     
  String? userId;     

  @override
  void initState() {
    super.initState();
    fetchUserData();     
  }

  Future<void> fetchUserData() async {
    try {
          
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;

            
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('Users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          setState(() {
            passedTests = userDoc.data()?['testsNumber'] ??
                0;     
          });
        }
      }
    } catch (e) {
      print("Greška pri preuzimanju podataka o korisniku: $e");
    }
  }

  void _showTestDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Color.fromRGBO(218, 218, 218, 1),     
          title: Text(
            'Obaveštenje',
            style: TextStyle(color: const Color.fromARGB(255, 116, 113, 113)),
                
          ),
          content: Text(
            message,
            style: TextStyle(
                color: const Color.fromARGB(
                    221, 80, 79, 79)),     
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();     
              },
              child: Text(
                'OK',
                style: TextStyle(
                    color: const Color.fromARGB(
                        255, 116, 113, 113)),     
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EducationScreen(),
              ),
            );
          },
        ),
        title: Text('Testovi'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      backgroundColor: Color.fromRGBO(219, 219, 219, 1),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,     
          childAspectRatio: 1,     
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 10,     
        itemBuilder: (context, index) {
          bool isLocked = index > passedTests;
          bool isNextTest = index == passedTests;
          bool isPassed = index < passedTests;

          Color backgroundColor;
          Color numberColor;
          Color numberBoxColor;

          if (isPassed) {
            backgroundColor = Color.fromARGB(
                255, 202, 201, 201);     
            numberColor = Colors.black;
            numberBoxColor = Color.fromARGB(255, 176, 173, 173);
          } else if (isNextTest) {
            backgroundColor =
                Color.fromARGB(255, 206, 204, 204);     
            numberColor = Colors.black;
            numberBoxColor = Color.fromARGB(255, 198, 195, 195);
          } else {
            backgroundColor =
                Color.fromARGB(255, 221, 190, 190);     
            numberColor = Colors.black;
            numberBoxColor = Color.fromARGB(
                255, 231, 161, 161);     
          }

          return GestureDetector(
            onTap: () {
              if (isPassed) {
                    
                _showTestDialog(context,
                    'Ovaj test ste položili, pristupite sledećem slobodnom.');
              } else if (isLocked) {
                    
                _showTestDialog(context,
                    'Da biste otključali ovaj zadatak, neophodno je da pređete prethodne testove.');
              } else {
                    
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(testIndex: index + 1),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                      
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: numberBoxColor,     
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: numberColor,
                        ),
                      ),
                    ),
                  ),
                      
                  if (isPassed)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.check,     
                        color: Color.fromARGB(255, 102, 102, 102),
                        size: 30,
                      ),
                    )
                  else if (isNextTest)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.arrow_forward,     
                        color: Color.fromARGB(255, 102, 102, 102),
                        size: 30,
                      ),
                    )
                  else
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.lock,     
                        color: Color.fromARGB(255, 231, 42, 42),
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
