import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'menu_page.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({Key? key}) : super(key: key);

  @override
  _AbonnementPageState createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  mongo.Db? _db;
  late String userId;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
    _getUserId();
  }

  Future<void> _connectToDatabase() async {
    final db = mongo.Db(
        'mongodb+srv://Park_usr:tv9VOI902dcAyLvr@cluster0.dsb0mda.mongodb.net/ParkDB');
    await db.open();
    _db = db;
  }

  Future<void> _getUserId() async {
    const email = "user@example.com";
    try {
      final user = await _db?.collection('user').findOne({'email': email});
      if (user != null) {
        setState(() {
          userId = user['_id'].toString();
        });
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération de l'ID de l'utilisateur: $e");
    }
  }

  Future<void> _makePayment() async {
    final paymentDetails = {
      'cardNumber': cardNumberController.text,
      'expirationDate': expirationDateController.text,
      'cvv': cvvController.text,
      'userId': userId,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    try {
      await _db?.collection('payment').insert(paymentDetails);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } catch (e) {
      debugPrint("Erreur lors du paiement: $e");
    }
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: () async {
        await _makePayment();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("Payer"),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Abonnement",
          style: TextStyle(
            color: myColor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: cardNumberController,
          decoration: const InputDecoration(labelText: 'Numéro de carte'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: expirationDateController,
          decoration: const InputDecoration(labelText: 'Date d\'expiration'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: cvvController,
          decoration: const InputDecoration(labelText: 'CVV'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        _buildPaymentButton(),
      ],
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_parking,
            size: 70,
            color: Color.fromARGB(255, 171, 103, 143),
          ),
          Text(
            "ParkCar",
            style: TextStyle(
              color: Color.fromARGB(255, 171, 103, 143),
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myColor = Colors.blue;
    mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(top: 50, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ],
      ),
    );
  }
}
