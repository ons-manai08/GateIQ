import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../AppBar.dart';
import '../Responsive.dart';

class SpacesListPage extends StatefulWidget {
  @override
  _SpacesListPageState createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/History');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/Users');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('dd MMMM, yyyy | HH:mm').format(DateTime.now());

    // Use Responsive utility to get screen size and scale factors
    final screenWidth = Responsive.getWidth(context);
    final screenHeight = Responsive.getHeight(context);
    final scaleFactor = Responsive.getScaleFactor(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% of the screen width
          vertical: screenHeight * 0.03, // 3% of the screen height
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20.0 * scaleFactor, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Text(
                      currentDate,
                      style: TextStyle(fontSize: screenWidth * 0.04 * scaleFactor, color: Colors.grey),
                    ),
                  ],
                ),
                Icon(Icons.notifications, size: 24.0 * scaleFactor, color: Colors.grey),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spaces List',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07 * scaleFactor, // Adjust font size based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Add Space action
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Space'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance.ref().child('status').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data', style: TextStyle(color: Colors.red)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return Center(
                      child: Text('No spaces available', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final data = snapshot.data!.snapshot.value;

                  // Vérifier que data est bien un Map
                  if (data is! Map) {
                    return Center(
                      child: Text('Invalid data format', style: TextStyle(color: Colors.red)),
                    );
                  }

                  final Map<dynamic, dynamic> spaces = data as Map<dynamic, dynamic>;

                  // Filtrer et ne pas afficher les entrées qui ne sont pas des maps valides
                  final validSpaces = spaces.entries.where((entry) => entry.value is Map).toList();

                  return ListView.builder(
                    itemCount: validSpaces.length,
                    itemBuilder: (context, index) {
                      var spaceKey = validSpaces[index].key;
                      var spaceData = validSpaces[index].value as Map;

                      // Utiliser les champs de manière sécurisée avec des valeurs par défaut si null
                      String door = spaceData['door']?.toString() ?? 'Unknown Door';
                      String user = spaceData['user']?.toString() ?? 'Unknown User';
                      String time = spaceData['time']?.toString() ?? DateTime.now().toString();
                      int status = spaceData['status'] ?? 0; // 0 as default for status

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ListTile(
                          leading: Text(
                            user,
                            style: TextStyle(fontSize: screenWidth * 0.045 * scaleFactor),
                          ),
                          title: Text(door),
                          subtitle: Text('Time: $time'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Status: $status'),
                              Icon(Icons.more_vert),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
