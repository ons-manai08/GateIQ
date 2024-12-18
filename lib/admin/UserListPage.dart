import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../AppBar.dart';
import '../Responsive.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  int _selectedIndex = 0; // To track the selected tab

  // This function is called when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/Spaces');
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
      appBar: AppBar(
        title: Text('Users List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Action to add users
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getPadding(context, 16.0), // Scaled horizontal padding
          vertical: Responsive.getPadding(context, 12.0), // Scaled vertical padding
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
                    Icon(Icons.calendar_today, size: 20.0 * scaleFactor, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Text(
                      currentDate,
                      style: TextStyle(fontSize: Responsive.getFontSize(context, 16.0), color: Colors.grey),
                    ),
                  ],
                ),
                Icon(Icons.notifications, size: 24.0 * scaleFactor, color: Colors.grey),
              ],
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height for spacing
            // Title
            Text(
              'Users List',
              style: TextStyle(fontSize: Responsive.getFontSize(context, 24.0), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Search Box
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
            // User List
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
                      child: Text('No users available', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final data = snapshot.data!.snapshot.value;

                  // Vérifier que data est bien un Map
                  if (data is! Map) {
                    return Center(
                      child: Text('Invalid data format', style: TextStyle(color: Colors.red)),
                    );
                  }

                  final Map<dynamic, dynamic> users = data as Map<dynamic, dynamic>;

                  // Filtrer et ne pas afficher les entrées qui ne sont pas des maps valides
                  final validUsers = users.entries.where((entry) => entry.value is Map).toList();

                  return ListView.builder(
                    itemCount: validUsers.length,
                    itemBuilder: (context, index) {
                      var userKey = validUsers[index].key;
                      var userData = validUsers[index].value as Map;

                      // Utiliser les champs de manière sécurisée avec des valeurs par défaut si null
                      String user = userData['user']?.toString() ?? 'Unknown User';
                      String door = userData['door']?.toString() ?? 'Unknown Door';
                      bool status = userData['status'] == 1; // Assurez-vous que 'status' est converti en bool

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          title: Text(
                            user,
                            style: TextStyle(fontSize: Responsive.getFontSize(context, 18.0), fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            door,
                            style: TextStyle(fontSize: Responsive.getFontSize(context, 16.0), color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: status,
                                onChanged: (value) {
                                  setState(() {
                                    // Update user status
                                    FirebaseDatabase.instance.ref().child('status/$userKey/status').set(value ? 1 : 0);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  // More options for the user
                                  _showUserOptions(context, userData);
                                },
                              ),
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

  // Display more options for the user
  void _showUserOptions(BuildContext context, Map userData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit User'),
                onTap: () {
                  // Edit user logic
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete User'),
                onTap: () {
                  // Delete user logic
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
