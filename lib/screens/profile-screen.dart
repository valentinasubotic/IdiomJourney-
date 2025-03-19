import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/activity-screen.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/screens/login-screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String phoneNumber = '';
  String email = '';
  int dayStreak = 0;
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
          phoneNumber = userDoc.data()?['phoneNumber'] ?? 'Nema broja';
          email = userDoc.data()?['email'] ?? 'Nema email-a';
          dayStreak = userDoc.data()?['dayStreak'] ?? 0;

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

  Future<void> updateEmoji(IconData newEmoji) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String emojiString = getEmojiString(newEmoji);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'emoji': emojiString});
      setState(() {
        selectedEmoji = newEmoji;
      });
    } catch (e) {
      print("Greška pri ažuriranju emotikona: $e");
    }
  }

  String getEmojiString(IconData emoji) {
    if (emoji == Icons.emoji_emotions) {
      return 'emoji_emotions';
    } else if (emoji == Icons.emoji_people) {
      return 'emoji_people';
    } else {
      return 'account_circle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
        actions: [
          IconButton(
            iconSize: 32,
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SettingsScreen(onEmojiChanged: updateEmoji)),
              );
            },
          ),
          IconButton(
            iconSize: 32,
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                selectedEmoji,
                size: 110,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.whatshot,
                    color: const Color.fromARGB(255, 236, 104, 95)),
                SizedBox(width: 5, height: 15),
                Text(
                  '$dayStreak/31',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 236, 104, 95),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            buildProfileInfo(Icons.person, fullName),
            buildProfileInfo(Icons.phone, phoneNumber),
            buildProfileInfo(Icons.email, email),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(197, 194, 194, 100),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Premium registracija',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inknut Antiqua',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Registrujte se za dodatne lekcije,\nkoje bi Vas podučavali profesori',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inknut Antiqua',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 155, 154, 154),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      child: Text(
                        'Registracija',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inknut Antiqua',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Color.fromARGB(255, 94, 93, 93),
          ),
          SizedBox(width: 15, height: 42),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(IconData) onEmojiChanged;

  SettingsScreen({required this.onEmojiChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _focuscurrentPassword = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusConfirmPassword = FocusNode();
  bool _isLoading = false;
  bool isObscured1 = true;
  bool isObscured2 = true;
  bool isObscured3 = true;

  @override
  void initState() {
    super.initState();

    _focuscurrentPassword.addListener(() {
      setState(() {});
    });

    _focusPassword.addListener(() {
      setState(() {});
    });

    _focusConfirmPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusPassword.dispose();
    _focuscurrentPassword.dispose();
    _focusConfirmPassword.dispose();
    super.dispose();
  }

  Future<void> _reauthenticateUser(String currentPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? '';

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);

        await user.reauthenticateWithCredential(credential);
        print("Korisnik uspješno ponovo autentifikovan.");
      }
    } catch (e) {
      print("Greška pri ponovnoj autentifikaciji: $e");
      throw e;
    }
  }

  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lozinke se ne poklapaju!")),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lozinka mora biti najmanje 6 karaktera!")),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await _reauthenticateUser(currentPassword);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lozinka uspešno promijenjena!")),
        );
      }
    } catch (e) {
      print("Greška pri promjeni lozinke: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Došlo je do greške prilikom promjene lozinke.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podešavanja'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
      backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Izaberi emotikon:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inknut Antiqua',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions, size: 50),
                  onPressed: () {
                    widget.onEmojiChanged(Icons.emoji_emotions);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_people, size: 50),
                  onPressed: () {
                    widget.onEmojiChanged(Icons.emoji_people);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, size: 50),
                  onPressed: () {
                    widget.onEmojiChanged(Icons.account_circle);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            Divider(),
            Text(
              'Promijeni lozinku:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inknut Antiqua',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: isObscured1,
              focusNode: _focuscurrentPassword,
              cursorColor: Color.fromRGBO(94, 94, 94, 1),
              decoration: InputDecoration(
                labelText: 'Trenutna lozinka',
                labelStyle: TextStyle(
                  color: _focuscurrentPassword.hasFocus
                      ? Color.fromRGBO(94, 94, 94, 1)
                      : Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
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
                    isObscured1 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscured1 = !isObscured1;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: isObscured2,
              focusNode: _focusPassword,
              cursorColor: Color.fromRGBO(10, 10, 10, 1),
              decoration: InputDecoration(
                labelText: 'Nova lozinka',
                labelStyle: TextStyle(
                  color: _focusPassword.hasFocus
                      ? Color.fromRGBO(46, 39, 39, 1)
                      : Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
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
                    isObscured2 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscured2 = !isObscured2;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: isObscured3,
              focusNode: _focusConfirmPassword,
              cursorColor: Color.fromRGBO(12, 12, 12, 1),
              decoration: InputDecoration(
                labelText: 'Potvrdite lozinku',
                labelStyle: TextStyle(
                  color: _focusConfirmPassword.hasFocus
                      ? Color.fromRGBO(94, 94, 94, 1)
                      : Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
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
                    isObscured3 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscured3 = !isObscured3;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 25),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 155, 154, 154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.grey,
                          elevation: 5,
                          minimumSize: Size(double.infinity, 50),
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          "Promijeni lozinku",
                          style: TextStyle(
                            fontFamily: 'Inknut Antiqua',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 155, 154, 154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.grey,
                          elevation: 5,
                          minimumSize: Size(double.infinity, 50),
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          "Odjavite se",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inknut Antiqua',
                            fontWeight: FontWeight.bold,
                          ),
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
