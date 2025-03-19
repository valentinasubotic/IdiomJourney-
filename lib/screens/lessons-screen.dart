import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/activity-screen.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/screens/lessons-details-screen.dart';
import 'package:idiom_journey/screens/profile-screen.dart';

class LessonsScreen extends StatelessWidget {
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
        title: const Text('Lekcije'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Lessons').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Došlo je do greške prilikom učitavanja lekcija.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nema dostupnih lekcija.'));
          }

          final lessons = snapshot.data!.docs;

          return Container(
            color: Color.fromRGBO(218, 218, 218, 1),
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lessonData =
                    lessons[index].data() as Map<String, dynamic>;
                final lessonName = lessonData['lesson'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color(0xFFF2F0F0),
                  child: ListTile(
                    title: Text(
                      lessonName,
                      style: const TextStyle(
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonDetailsScreen(lessonData),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
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
