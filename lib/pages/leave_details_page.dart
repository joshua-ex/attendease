import 'package:flutter/material.dart';
import 'home_page.dart';

class LeaveDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leave Balance Section
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildLeaveTile('Leave Balance', '20', Colors.lightBlue),
                _buildLeaveTile('Leave Approved', '2', Colors.lightGreen),
                _buildLeaveTile('Leave Pending', '4', Colors.lightBlueAccent),
                _buildLeaveTile('Leave Cancelled', '10', Colors.redAccent),
              ],
            ),
            SizedBox(height: 20),
            // Tabs Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Upcoming',
                      style: TextStyle(fontSize: 18, color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Past',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Team Leave',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
              ],
            ),
            // Leave Details Section
            Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Apr 15, 2023 - Apr 18, 2023',
                        style: TextStyle(fontSize: 16)),
                    Text('Approved', style: TextStyle(color: Colors.green)),
                    SizedBox(height: 10),
                    Text('Apply Days',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('3 Days', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Leave Balance',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('16', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Approved By',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Martin Deo', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveTile(String title, String count, Color color) {
    return Card(
      margin: EdgeInsets.all(8),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(count, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
