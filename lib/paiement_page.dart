import 'package:flutter/material.dart';
import 'abonnement_page.dart';

class PaiementPage extends StatelessWidget {
  final BuildContext parentContext; // Ajoutez cette ligne

  PaiementPage({required this.parentContext}); // Ajoutez ce constructeur

  // ... (votre code existant pour la page de paiement)

  Widget _buildPaiementButton() {
    return ElevatedButton(
      onPressed: () {
        // Effectuer le paiement (c'est ici que vous intégrerez votre logique de paiement réelle)

        // Après le paiement réussi, rediriger vers la page d'abonnement
        Navigator.pushReplacement(
          parentContext, // Utilisez le contexte passé en paramètre
          MaterialPageRoute(builder: (context) => AbonnementPage()),
        );

        // Vous pouvez également envoyer un e-mail ici après le paiement réussi
      },
      child: Text("Payer maintenant"),
    );
  }

  // ... (votre code existant pour la page de paiement)

  @override
  Widget build(BuildContext context) {
    // ... (votre code existant)

    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... (votre code existant)
            _buildPaiementButton(),
          ],
        ),
      ),
    );
  }
}
