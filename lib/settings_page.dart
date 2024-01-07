import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late mongo.Db _db;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    final db = mongo.Db(
        'mongodb+srv://Park_usr:tv9VOI902dcAyLvr@cluster0.dsb0mda.mongodb.net/ParkDB'); // Remplacez <USERNAME> et <PASSWORD> par vos informations d'identification MongoDB Atlas
    await db.open();
    _db = db;
  }

  Future<void> _updateUser() async {
    final collection = _db.collection('user');

    final user = await collection.findOne({'email': emailController.text});

    if (user != null) {
      final currentDate = DateTime.now();

      await collection.update(
        mongo.where.eq('email', emailController.text),
        mongo.modify
          ..set('first_name', firstNameController.text)
          ..set('last_name', lastNameController.text)
          ..set('password', passwordController.text)
          ..set('updated_at', currentDate),
      );

      debugPrint("Mise à jour réussie!");

      // Vous pouvez ajouter d'autres actions après la mise à jour ici.
    } else {
      debugPrint("Utilisateur non trouvé!");
      // Gérer le cas où l'utilisateur n'est pas trouvé
    }
  }

  Future<void> _addUser() async {
    final collection = _db.collection('user');
    final currentDate = DateTime.now();

    await collection.insert({
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'created_at': currentDate,
      'updated_at': currentDate,
    });

    debugPrint("Utilisateur ajouté!");

    // Vous pouvez ajouter d'autres actions après l'ajout ici.
  }

  @override
  Widget build(BuildContext context) {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Prénom', firstNameController),
            _buildTextField('Nom', lastNameController),
            _buildTextField('Adresse Mail', emailController),
            _buildTextField('Mot de passe', passwordController,
                isPassword: true),
            const SizedBox(height: 20),
            _buildUpdateButton(),
            const SizedBox(height: 20),
            _buildAddUserButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.done),
          ),
          obscureText: isPassword,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () async {
        await _updateUser();
      },
      child: const Text("Mettre à jour l'utilisateur"),
    );
  }

  Widget _buildAddUserButton() {
    return ElevatedButton(
      onPressed: () async {
        await _addUser();
      },
      child: const Text("Ajouter un utilisateur"),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
