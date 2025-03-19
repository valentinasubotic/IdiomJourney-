import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/activity-screen.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/screens/lessons-screen.dart';
import 'package:idiom_journey/screens/profile-screen.dart';
import 'package:idiom_journey/screens/test-list-screen%20.dart';

class EducationScreen extends StatefulWidget {
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  String fullName = '';
  int lessonsNumber = 0;
  int testsNumber = 0;
  IconData selectedEmoji = Icons.account_circle;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc.data()?['fullName'] ?? 'Korisnik';
          lessonsNumber = userDoc.data()?['lessonsNumber'] ?? 0;
          testsNumber = userDoc.data()?['testsNumber'] ?? 0;

          if (userDoc.data()?.containsKey('emoji') == true) {
            String emoji = userDoc.data()?['emoji'] ?? 'account_circle';
            selectedEmoji = getIconFromString(emoji);
          } else {
            FirebaseFirestore.instance.collection('Users').doc(uid).update({
              'emoji': 'account_circle',
            });
            selectedEmoji = Icons.account_circle;
          }
        });
      }
    } catch (e) {
      print("Greška pri preuzimanju podataka: $e");
    }
  }

  IconData getIconFromString(String emojiName) {
    switch (emojiName) {
      case 'emoji_emotions':
        return Icons.emoji_emotions;
      case 'emoji_people':
        return Icons.emoji_people;
      default:
        return Icons.account_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        title: const Text('Kurs ruskog jezika'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(selectedEmoji, size: 100),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFB0ADAD),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Добро пожаловать, $fullName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inknut Antiqua',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD1D0D0),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Idiomi',
                      style: TextStyle(
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB0ADAD),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Fraze',
                      style: TextStyle(
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: Card(
                    color: Color(0xFFD1D0D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Stack(
                      children: [
                        ListTile(
                          title: const Text(
                            'Lekcije',
                            style: TextStyle(
                              fontFamily: 'Inknut Antiqua',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing:const  Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 114, 113, 113),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        LessonsScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
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
                        ),
                        Positioned(
                          bottom: 8,
                          left: 16,
                          child: Text(
                            '$lessonsNumber  naučenih lekcija',
                            style: const TextStyle(
                              fontFamily: 'Inknut Antiqua',
                              fontSize: 16,
                              color: Color.fromARGB(255, 114, 113, 113),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  child: Card(
                    color: Color(0xFFD1D0D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Stack(
                      children: [
                        ListTile(
                          title:const  Text(
                            'Testovi',
                            style: TextStyle(
                              fontFamily: 'Inknut Antiqua',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 114, 113, 113),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        TestListScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
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
                        ),
                        Positioned(
                          bottom: 8,
                          left: 16,
                          child: Text(
                            '$testsNumber testova',
                            style:const  TextStyle(
                              fontFamily: 'Inknut Antiqua',
                              fontSize: 16,
                              color: Color.fromARGB(255, 114, 113, 113),
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
        ],
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
            IconButton(icon: Icon(Icons.school), onPressed: () {}),
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
