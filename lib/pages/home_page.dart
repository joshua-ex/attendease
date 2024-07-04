import 'package:attendease/services/notification_services.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:attendease/pages/auth_page.dart';
import 'package:attendease/pages/leave_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final emailPrefix = FirebaseAuth.instance.currentUser!.email!.split('@')[0];

  DateTime currentDate = DateTime.now();
  DateTime? checkInTime;
  DateTime? checkOutTime;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    notificationServices.requestNotificationPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    });
  }

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _checkIn() async {
    if (checkInTime == null || checkInTime!.day != DateTime.now().day) {
      setState(() {
        checkInTime = DateTime.now();
      });

      // Save check-in time to Firestore
      await FirebaseFirestore.instance.collection('checkins').add({
        'userId': user.uid,
        'checkInTime': checkInTime,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _checkOut() async {
    if (checkInTime == null) {
      // Show a message to the user indicating that check-in is required before check-out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You need to check in before checking out.'),
        ),
      );
      return;
    }

    if (checkOutTime == null || checkOutTime!.day != DateTime.now().day) {
      setState(() {
        checkOutTime = DateTime.now();
      });

      // Save check-out time to Firestore
      await FirebaseFirestore.instance.collection('checkouts').add({
        'userId': user.uid,
        'checkOutTime': checkOutTime,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  List<DateTime> getCurrentWeekDates() {
    int weekday = currentDate.weekday;
    DateTime startOfWeek = currentDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LeaveDetailsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getCurrentWeekDates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendEase'),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.photoURL ??
                      'https://as1.ftcdn.net/v2/jpg/03/53/11/00/1000_F_353110097_nbpmfn9iHlxef4EDIhXB1tdTD0lcWhG9.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? emailPrefix,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(currentDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    DateTime date = weekDates[index];
                    bool isToday = date.day == currentDate.day &&
                        date.month == currentDate.month &&
                        date.year == currentDate.year;
                    return Column(
                      children: [
                        Text(
                          [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ][index],
                          style: TextStyle(
                              color: isToday ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                              color: isToday ? Colors.blue : Colors.grey),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: _checkIn,
                  child: _buildAttendanceTile(
                    'Check In',
                    checkInTime != null
                        ? DateFormat('hh:mm a').format(checkInTime!)
                        : 'Not checked in',
                    'Tap to Check In',
                  ),
                ),
                GestureDetector(
                  onTap: _checkOut,
                  child: _buildAttendanceTile(
                    'Check Out',
                    checkOutTime != null
                        ? DateFormat('hh:mm a').format(checkOutTime!)
                        : 'Not checked out',
                    'Tap to Check Out',
                  ),
                ),
                _buildAttendanceTile('Total Days', '26', 'Working Days'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Handle view all press
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Check In'),
              subtitle: checkInTime != null
                  ? Text(DateFormat('MMMM d, yyyy').format(checkInTime!))
                  : null,
              trailing: checkInTime != null
                  ? Text(DateFormat('hh:mm a').format(checkInTime!),
                      style: const TextStyle(color: Colors.green))
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.red),
              title: const Text('Check Out'),
              subtitle: checkOutTime != null
                  ? Text(DateFormat('MMMM d, yyyy').format(checkOutTime!))
                  : null,
              trailing: checkOutTime != null
                  ? Text(DateFormat('hh:mm a').format(checkOutTime!),
                      style: const TextStyle(color: Colors.red))
                  : null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Leave Details'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAttendanceTile(String title, String time, String status) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(time, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(status, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
