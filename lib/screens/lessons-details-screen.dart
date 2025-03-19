import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/activity-screen.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/screens/profile-screen.dart';
import 'package:intl/intl.dart';

class LessonDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> lessonData;

  LessonDetailsScreen(this.lessonData);

  @override
  _LessonDetailsScreenState createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  bool showTranslation = false;
  String fullName = '';
  int lessonsNumber = 0;
  List<String> learnedLessons = [];

  @override
  void initState() {
    super.initState();
    updateUserProgress();
  }

  Future<void> updateUserProgress() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc.data()?['fullName'] ?? 'Korisnik';
          lessonsNumber = userDoc.data()?['lessonsNumber'] ?? 0;
          learnedLessons =
              List<String>.from(userDoc.data()?['learnedLessons'] ?? []);
        });
        String lessonName = widget.lessonData['lesson'];

        if (!learnedLessons.contains(lessonName)) {
          await FirebaseFirestore.instance.collection('Users').doc(uid).update({
            'lessonsNumber': lessonsNumber + 1,
            'dailyActivity': FieldValue.arrayUnion([]),
          });

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .get();
          List<dynamic> currentDailyActivity =
              userDoc.get('dailyActivity') ?? [];

          currentDailyActivity
              .add(DateFormat('yyyy-MM-dd').format(DateTime.now()));

          await FirebaseFirestore.instance.collection('Users').doc(uid).update({
            'dailyActivity': currentDailyActivity,
            'learnedLessons': FieldValue.arrayUnion([lessonName]),
          });
        }
      }
    } catch (e) {
      print("Greška pri ažuriranju: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String lesson = widget.lessonData['lesson'] ?? 'Lekcija';
    String description = widget.lessonData['description'] ?? 'Opis';
    String translation = widget.lessonData['translation'] ?? 'Prevod';
    String example = widget.lessonData['example'] ?? 'Primer';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalji lekcije'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: Container(
        color: Color.fromRGBO(218, 218, 218, 1),
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F0F0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        lesson,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Inknut Antiqua',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        description,
                        style:const  TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inknut Antiqua',
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showTranslation = !showTranslation;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9),
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.g_translate,
                              size: 20,
                            ),
                            SizedBox(width: 11),
                            Text('Prevod'),
                          ],
                        ),
                      ),
                      if (showTranslation) ...[
                        const SizedBox(height: 10),
                        Text(
                          translation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inknut Antiqua',
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'PRIMJER',
                              style: TextStyle(
                                fontFamily: 'Inknut Antiqua',
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              example,
                              style:  const TextStyle(
                                fontFamily: 'Inknut Antiqua',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(218, 218, 218, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.school),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EducationScreen()),
                );
              },
            ),
            IconButton(
                icon: Icon(Icons.show_chart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityScreen()),
                  );
                }),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
