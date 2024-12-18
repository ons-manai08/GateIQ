import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Realtime Database
import '../Responsive.dart'; // Import Responsive.dart

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 0; // To track the selected tab
  final DatabaseReference _doorHistoryRef = FirebaseDatabase.instance.ref().child('status'); // Realtime Database reference

  // Function called when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation to different pages based on selected index
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/Spaces');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/Users');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('dd MMMM, yyyy | HH:mm').format(DateTime.now());

    // Use the Responsive class to get width and height
    double screenWidth = Responsive.getWidth(context);
    double screenHeight = Responsive.getHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getPadding(context, 20), // Responsive horizontal padding
          vertical: Responsive.getPadding(context, 20), // Responsive vertical padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with date and bell icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: Responsive.getWidth(context) * 0.05, color: Colors.grey), // Responsive icon size
                    SizedBox(width: 8.0),
                    Text(
                      currentDate,
                      style: TextStyle(
                        fontSize: Responsive.getFontSize(context, 16.0), // Responsive font size
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.notifications, size: Responsive.getWidth(context) * 0.06, color: Colors.grey), // Responsive icon size
              ],
            ),
            SizedBox(height: Responsive.getHeight(context) * 0.02),
            // History Title
            Text(
              'History',
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 24.0), // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: Responsive.getHeight(context) * 0.02),
            // Search Box
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: Responsive.getHeight(context) * 0.02),
            // Table Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Doors', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Users Name', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Date & Timing', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10.0),
            Divider(thickness: 1.0, color: Colors.grey[300]),
            SizedBox(height: 10.0),
            // Table Content displaying door history
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _doorHistoryRef.onValue, // Using Realtime Database
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error fetching data', style: TextStyle(color: Colors.red)));
                  }

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return Center(
                        child: Text('No history available', style: TextStyle(color: Colors.grey)));
                  }

                  final doorHistory = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  return ListView.builder(
                    itemCount: doorHistory.length,
                    itemBuilder: (context, index) {
                      var history = doorHistory.values.toList()[index];

                      if (history is Map) {
                        String door = history['door'] ?? 'Unknown Door';
                        String user = history['user'] ?? 'Unknown User';
                        String time = history['time'] ?? DateTime.now().toString();

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: Responsive.getPadding(context, 8.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Door Name
                              Text(
                                door,
                                style: TextStyle(fontSize: Responsive.getFontSize(context, 16.0), color: Colors.black), // Responsive text size
                              ),
                              // User Name
                              Text(
                                user,
                                style: TextStyle(fontSize: Responsive.getFontSize(context, 16.0), color: Colors.black), // Responsive text size
                              ),
                              // Date and Time
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${DateFormat('dd/MM/yyyy').format(DateTime.parse(time))} | ${DateFormat('hh:mm a').format(DateTime.parse(time))}",
                                  style: TextStyle(
                                    fontSize: Responsive.getFontSize(context, 14.0), // Responsive text size
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: Responsive.getWidth(context) * 0.06), // Responsive icon size
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.space_bar, size: Responsive.getWidth(context) * 0.06), // Responsive icon size
            label: 'Spaces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: Responsive.getWidth(context) * 0.06), // Responsive icon size
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
