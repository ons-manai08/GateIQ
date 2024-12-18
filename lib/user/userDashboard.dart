import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Pour formater l'heure
import '../Responsive.dart';

class UserDashboard extends StatelessWidget {
  final DatabaseReference _doorRef = FirebaseDatabase.instance.ref('status'); // Référence à Firebase Realtime Database

  // Méthode pour changer le statut de la porte dans Firebase et sauvegarder l'historique
  Future<void> _updateDoorStatus(String doorName, bool isOn, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userName = await _getUserName(user.uid); // Récupérer le nom depuis Firestore
      String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()); // Temps actuel

      // Ajouter une nouvelle entrée à l'historique des portes avec le nom de la porte
      await _doorRef.push().set({
        'status': isOn ? 1 : 0, // Changer le statut de la porte (1 pour 'On', 0 pour 'Off')
        'user': userName, // Ajouter le nom de l'utilisateur
        'door': doorName, // Ajouter le nom de la porte
        'time': time, // Ajouter l'heure de l'activation
      });

      // Afficher une alerte avec un design agréable
      _showAlert(context, doorName, isOn);
    }
  }

  // Méthode pour récupérer le nom de l'utilisateur depuis Firestore
  Future<String> _getUserName(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc['name'] ?? 'Utilisateur'; // Retourne le nom si disponible, sinon 'Utilisateur'
    } else {
      return 'Utilisateur'; // Si l'utilisateur n'a pas de nom enregistré
    }
  }

  // Méthode pour afficher l'alerte
  void _showAlert(BuildContext context, String doorName, bool isOn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Porte ${isOn ? 'ouverte' : 'fermée'}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'La ${doorName} a été ${isOn ? 'ouverte' : 'fermée'} avec succès.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour se déconnecter
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Déconnexion de Firebase
    Navigator.pushReplacementNamed(context, '/login'); // Redirection vers la page de login
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    // Si l'utilisateur n'est pas connecté, rediriger vers la page de connexion
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Veuillez vous connecter pour accéder à ce tableau de bord'),
        ),
      );
    }

    return FutureBuilder<String>(
      future: _getUserName(user.uid), // Utilisation de FutureBuilder pour récupérer le nom
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Chargement en attendant la récupération du nom
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erreur de récupération du nom'),
            ),
          );
        }

        // Récupérer le nom de l'utilisateur (si disponible)
        String userName = snapshot.data ?? 'Utilisateur';

        return Scaffold(
          appBar: AppBar(
            title: Text('Bienvenue $userName'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout), // Icône de déconnexion
                onPressed: () {
                  _logout(context); // Appel à la méthode de déconnexion
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(Responsive.getPadding(context, 16.0)), // Utilisation de Responsive pour les paddings
            child: Column(
              children: [
                // Carte pour la porte du salon
                DoorCard(
                  icon: Icons.living,
                  title: 'Porte du Salon',
                  status: 'Off',
                  onStatusChange: (isOn) => _updateDoorStatus('Porte du Salon', isOn, context),
                ),
                SizedBox(height: Responsive.getPadding(context, 16.0)), // Taille dynamique de l'espacement
                // Carte pour la porte de la salle de bain
                DoorCard(
                  icon: Icons.bathroom,
                  title: 'Porte de la Salle de Bain',
                  status: 'Off',
                  onStatusChange: (isOn) => _updateDoorStatus('Porte de la Salle de Bain', isOn, context),
                ),
                SizedBox(height: Responsive.getPadding(context, 16.0)), // Taille dynamique de l'espacement
                // Carte pour la porte de la salle à manger
                DoorCard(
                  icon: Icons.restaurant,
                  title: 'Porte de la Salle à Manger',
                  status: 'Off',
                  onStatusChange: (isOn) => _updateDoorStatus('Porte de la Salle à Manger', isOn, context),
                ),
                SizedBox(height: Responsive.getPadding(context, 16.0)), // Taille dynamique de l'espacement
                // Carte pour la porte de la chambre
                DoorCard(
                  icon: Icons.bed,
                  title: 'Porte de la Chambre',
                  status: 'Off',
                  onStatusChange: (isOn) => _updateDoorStatus('Porte de la Chambre', isOn, context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DoorCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String status;
  final ValueChanged<bool> onStatusChange;

  const DoorCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.status,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  _DoorCardState createState() => _DoorCardState();
}

class _DoorCardState extends State<DoorCard> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    // Initialiser l'état de la porte à "Off"
    _isOn = widget.status == 'On';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: _isOn ? Colors.green : Colors.grey, // Changer la couleur selon l'état
          size: Responsive.getWidth(context) * 0.1, // Ajuster la taille de l'icône
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: Responsive.getFontSize(context, 16.0)), // Adapter la taille du texte
        ),
        trailing: Switch(
          value: _isOn,
          onChanged: (value) {
            setState(() {
              _isOn = value;
            });
            // Appel à la fonction pour changer le statut de la porte dans Firebase
            widget.onStatusChange(value);
          },
        ),
      ),
    );
  }
}
