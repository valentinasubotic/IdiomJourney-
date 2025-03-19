import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/test-list-screen%20.dart';

class TestScreen extends StatefulWidget {
  final int testIndex;

  TestScreen({required this.testIndex});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String question = '';
  List<String> answers = [];
  int correctAnswerIndex = -1;
  int selectedAnswerIndex = -1;
  bool isAnswered = false;
  String description = '';
  String? userId;
  int testsNumber = 0;
  bool isCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    fetchTestData();
    fetchUserData();
  }

  Future<void> fetchTestData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> testDoc = await FirebaseFirestore.instance
          .collection('Tests')
          .doc(widget.testIndex.toString())     
          .get();

      if (testDoc.exists) {
        setState(() {
          question = testDoc.data()?['question'] ?? '';
          answers = List<String>.from(testDoc.data()?['answers'] ?? []);
          correctAnswerIndex = testDoc.data()?['correctAnswer'] ?? -1;
          description = testDoc.data()?['description'] ?? '';     
        });
      }
    } catch (e) {
      print("Greška pri preuzimanju podataka: $e");
    }
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;

        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          setState(() {
            testsNumber = userDoc.data()?['testsNumber'] ?? 0;
          });
        }
      }
    } catch (e) {
      print("Greška pri preuzimanju korisničkih podataka: $e");
    }
  }

  Future<void> updateUserTestProgress() async {
    try {
      if (userId != null && selectedAnswerIndex == correctAnswerIndex) {
        await FirebaseFirestore.instance.collection('Users').doc(userId).update({
          'testsNumber': testsNumber + 1,     
        });
        print("Korisnikov napredak uspješno ažuriran.");
      }
    } catch (e) {
      print("Greška pri ažuriranju napretka: $e");
    }
  }

  Widget buildAnswerButton(String answer, int answerIndex) {
    return GestureDetector(
      onTap: isAnswered
          ? null
          : () {
              setState(() {
                selectedAnswerIndex = answerIndex;
                isAnswered = true;
                isCorrectAnswer = (answerIndex == correctAnswerIndex);

                if (isCorrectAnswer) {
                      
                  updateUserTestProgress();
                }
              });
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: selectedAnswerIndex == answerIndex
              ? (correctAnswerIndex == answerIndex
                  ? Colors.green[300]
                  : Colors.red[300])
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),     
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),     
            ),
          ],
        ),
        child: Center(
          child: Text(
            answer,
            style: TextStyle(
              fontFamily: 'Inknut Antiqua',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
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
                builder: (context) => TestListScreen(),
              ),
            );
          },
        ),
        title: Text('Test ${widget.testIndex}'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),     
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),     
                  ),
                ],
              ),
              child: Text(
                question,
                style: TextStyle(
                  fontFamily: 'Inknut Antiqua',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,     
              ),
            ),
            SizedBox(height: 20),
                
            ...answers.map((answer) {
              int answerIndex = answers.indexOf(answer);
              return buildAnswerButton(answer, answerIndex);
            }).toList(),
            SizedBox(height: 20),
                
            if (isAnswered)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),     
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),     
                        ),
                      ],
                    ),
                    child: Text(
                      description,     
                      style:const  TextStyle(
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                      
                  if (isCorrectAnswer)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestListScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ">>>",     
                            style: TextStyle(
                              fontFamily: 'Inknut Antiqua',
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
