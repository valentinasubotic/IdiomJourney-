import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/activity-screen.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/profile-screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> activeDays = [];

  @override
  void initState() {
    super.initState();
    fetchUserActivity();
  }

  Future<void> fetchUserActivity() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        List<dynamic>? dailyActivity = userDoc.data()?['dailyActivity'];
        if (dailyActivity != null) {
          setState(() {
            activeDays = List<String>.from(dailyActivity);
          });

          calculateAndUpdateDayStreak(uid);
        }
      }
    } catch (e) {
      print("Greška pri povlačenju aktivnosti: $e");
    }
  }

  Future<void> calculateAndUpdateDayStreak(String uid) async {
    List<DateTime> last7Days = List.generate(
        7, (index) => DateTime.now().subtract(Duration(days: index)));

    int dayStreak = 0;

    for (DateTime day in last7Days) {
      if (checkActivityForDay(day)) {
        dayStreak++;
      }
    }

    await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'dayStreak': dayStreak,
    });
  }

  bool checkActivityForDay(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return activeDays.contains(formattedDate);
  }

  String getSerbianDayName(DateTime date) {
    List<String> days = ['pon', 'uto', 'sri', 'čet', 'pet', 'sub', 'ned'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> last7Days = List.generate(
        7, (index) => DateTime.now().subtract(Duration(days: 6 - index)));

    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
        title: const Text('Početna stranica'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Sedmični izvještaj',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inknut Antiqua',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: last7Days.map((day) {
                    bool hadActivity = checkActivityForDay(day);
                    return Column(
                      children: [
                        Icon(
                          hadActivity
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: hadActivity
                              ? const Color.fromARGB(255, 117, 119, 117)
                              : Colors.grey,
                          size: 45,
                        ),
                        Text(getSerbianDayName(day)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const Text(
                  '    Kursevi',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inknut Antiqua',
                  ),
                ),
                const SizedBox(height: 10),
                buildCourseTile(
                    'Ruski jezik', 'assets/images/Russia2.png', '719', context),
                buildCourseTile('Engleski jezik', 'assets/images/Eng1.png',
                    '2305', context),
                buildCourseTile('Italijanski jezik', 'assets/images/italy2.jpg',
                    '1999', context),
                buildCourseTile('Francuski jezik', 'assets/images/France1.png',
                    '1300', context),
                buildCourseTile('Njemački jezik', 'assets/images/Germany11.png',
                    '1123', context),
                buildCourseTile('Španski jezik', 'assets/images/Spain21.png',
                    '854', context),
                buildCourseTile(
                    'Kineski jezik', 'assets/images/Ch1.png', '364', context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(218, 218, 218, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
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

  Widget buildCourseTile(String courseName, String imagePath, String numUsers,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EducationScreen()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.65),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
            color: Color.fromRGBO(242, 240, 240, 1),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 25,
            ),
            title: Text(
              courseName,
              style: const TextStyle(
                fontFamily: 'Inknut Antiqua',
                fontSize: 14,
              ),
            ),
            subtitle: Text('$numUsers korisnika',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                )),
            trailing:const  Text(
              '>>>',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
