import 'package:flutter/material.dart';
import 'abonnement_page.dart';
import 'historique_page.dart';
import 'settings_page.dart';
import 'parking_page.dart';

// Supposons que ces informations viennent de l'état de l'application ou d'une requête au backend
final String userName = 'Nom Utilisateur';
final String userPrenom = 'Prénom Utilisateur';
final String userEmail = 'email@exemple.com';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parking"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Ici, vous récupérerez les informations de l'utilisateur à partir du backend
              // et afficherez une boîte de dialogue avec ces informations
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Profil Utilisateur'),
                  content: Text(
                      'Nom: $userName\nPrénom: $userPrenom\nEmail: $userEmail'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Fermer'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Bienvenu, cliquez sur Abonnement pour vous abonner',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: <Widget>[
                MenuButton(
                  title: 'Abonnement',
                  icon: Icons.subscriptions,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AbonnementPage())),
                ),
                MenuButton(
                  title: 'Parking',
                  icon: Icons.local_parking,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParkingPage(
                                numeroMatricule: '',
                              ))),
                ),
                MenuButton(
                  title: 'Historique',
                  icon: Icons.history,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoriquePage(
                                numeroMatricule: '',
                              ))),
                ),
                MenuButton(
                  title: 'Paramètres',
                  icon: Icons.settings,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage())),
                ),
              ],
            ),
          ),
          Image.asset('image/smart_parking_logo.png', fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 80.0, color: Colors.white),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 24.0)),
          ],
        ),
      ),
    );
  }
}
