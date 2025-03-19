import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idiom_journey/screens/education-screen.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/screens/profile-screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivitytScreenState createState() => _ActivitytScreenState();
}

class _ActivitytScreenState extends State<ActivityScreen> {
  List<DateTime> dailyActivity = [];
  Map<String, int> lessonsPerDay = {};
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  bool isLoading = true;
  int maxLessons = 1;     

  @override
  void initState() {
    super.initState();
    fetchDailyActivity();
  }

  Future<void> fetchDailyActivity() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        List<dynamic> activityDates = userDoc.data()?['dailyActivity'] ?? [];
        setState(() {
          dailyActivity = activityDates.map((e) => DateTime.parse(e)).toList();
          processActivityData();     
          isLoading = false;
        });
      }
    } catch (e) {
      print("Greška pri preuzimanju podataka o aktivnosti: $e");
    }
  }

  void processActivityData() {
    lessonsPerDay.clear();

    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

        
    for (DateTime date in dailyActivity) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      if (formattedDate
                  .compareTo(DateFormat('yyyy-MM-dd').format(sevenDaysAgo)) >=
              0 &&
          formattedDate.compareTo(DateFormat('yyyy-MM-dd').format(now)) <= 0) {
        lessonsPerDay[formattedDate] = (lessonsPerDay[formattedDate] ?? 0) + 1;
      }
    }

        
    if (lessonsPerDay.isNotEmpty) {
      maxLessons = lessonsPerDay.values.reduce((a, b) => a > b ? a : b);
    } else {
      maxLessons =
          1;     
    }
  }

      
  List<Widget> generateLessonIndicators(int lessonCount) {
    List<Widget> indicators = [];
    for (int i = 0; i < lessonCount; i++) {
      indicators.add(
        Container(
          margin: EdgeInsets.only(right: 3),
          width: 10,     
          height: 10,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 177, 176, 176),
            shape: BoxShape.circle,     
          ),
        ),
      );
    }
    return indicators;
  }

      
  Widget buildLessonRow(String date, int lessonCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Row(
            children: generateLessonIndicators(lessonCount),     
          ),
          Spacer(),
          Text(
            '$lessonCount lekcij${lessonCount > 1 ? 'e' : 'a'}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivnost'),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      ),
       backgroundColor: Color.fromRGBO(218, 218, 218, 1),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                        });
                      },
                      calendarFormat: calendarFormat,     
                      onFormatChanged: (format) {
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: const Color.fromARGB(255, 177, 176, 176),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: const Color.fromARGB(255, 99, 99, 98),
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 1,     
                      ),
                      eventLoader: (day) {
                        if (dailyActivity.any(
                            (activityDay) => isSameDay(activityDay, day))) {
                          return [1];     
                        }
                        return [];
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Broj lekcija naučenih u poslednjih 7 dana:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                            
                        ...lessonsPerDay.keys
                            .toList()
                            .reversed
                            .take(7)
                            .map((date) {
                          return buildLessonRow(
                            DateFormat('dd.MM.yyyy')
                                .format(DateTime.parse(date)),
                            lessonsPerDay[date]!,
                          );
                        }).toList(),
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
            IconButton(icon: Icon(Icons.show_chart), onPressed: () {}),
            IconButton(icon: Icon(Icons.person), onPressed: () {  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );}),
          ],
        ),
      ),
    );
  }
}
