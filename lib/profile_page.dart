import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisez le contrôleur d'email avec l'email actuel de l'utilisateur
    emailController.text =
        "utilisateur@example.com"; // Remplacez par l'email réel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildChangePasswordForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresse e-mail :",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          emailController.text,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Ajoutez ici la logique pour modifier l'email
          },
          child: Text("Modifier l'adresse e-mail"),
        ),
      ],
    );
  }

  Widget _buildChangePasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Modifier le mot de passe :",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPasswordField("Nouveau mot de passe", newPasswordController),
        const SizedBox(height: 10),
        _buildPasswordField(
            "Confirmer le mot de passe", confirmPasswordController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Ajoutez ici la logique pour modifier le mot de passe
            if (newPasswordController.text == confirmPasswordController.text) {
              // Mot de passe confirmé, appliquez la logique de modification
              // newPasswordController.text contient le nouveau mot de passe
            } else {
              // Affichez un message d'erreur indiquant que les mots de passe ne correspondent pas
              // Vous pouvez utiliser un SnackBar pour cela
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Les mots de passe ne correspondent pas."),
                ),
              );
            }
          },
          child: Text("Modifier le mot de passe"),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      obscureText: true,
    );
  }
}
