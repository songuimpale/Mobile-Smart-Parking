import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingPage extends StatefulWidget {
  final String numeroMatricule;

  const ParkingPage({Key? key, required this.numeroMatricule})
      : super(key: key);

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  late Future<Map<String, dynamic>?> _parkingInfoFuture;

  @override
  void initState() {
    super.initState();
    _parkingInfoFuture = fetchParkingInfo();
  }

  Future<Map<String, dynamic>?> fetchParkingInfo() async {
    debugPrint("Numéro Matricule: ${widget.numeroMatricule}");
    try {
      final response = await http.get(
        Uri.parse('http://192.168.58.25:5000/api/userParking/AS%209527XV'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['message'] != null) {
          return null; // Handle the case when parking info is not found.
        }
        return data; // Parking info found.
      } else {
        debugPrint('Erreur lors de la requête : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données : $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _parkingInfoFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const NoParkingInfo();
          } else {
            var data = snapshot.data!;
            return ParkingInfo(
              slotNumber: data['place'].toString(),
              matricule: data['matricule'],
              // dateArrivee: data['dateArrivee'],
              //datePartir: data['datePartir'],
            );
          }
        },
      ),
    );
  }
}

class ParkingInfo extends StatelessWidget {
  final String slotNumber;
  final String matricule;
  // final String dateArrivee;
  // final String datePartir;

  const ParkingInfo({
    Key? key,
    required this.slotNumber,
    required this.matricule,
    // required this.dateArrivee,
    //  required this.datePartir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'BIENVENU',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Matricule: $matricule',
            textAlign: TextAlign.center,
          ),
          Text(
            'Vous pouvez garer à l\'emplacement N° $slotNumber',
            textAlign: TextAlign.center,
          ),
          /* Text(
            'Date d\'arrivée: $dateArrivee',
            textAlign: TextAlign.center,
          ),
          Text(
            'Date de départ prévue: $datePartir',
            textAlign: TextAlign.center,
          ),*/
          const SizedBox(height: 20),
          Image.asset(
              'image/smart_parking_logo.png'), // Assurez-vous que le chemin est correct.
        ],
      ),
    );
  }
}

class NoParkingInfo extends StatelessWidget {
  const NoParkingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'BIENVENU',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Veuillez vérifier votre abonnement ou contacter l\'équipe support à l\'accueil',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Image.asset(
              'image/smart_parking_logo.png'), // Assurez-vous que le chemin est correct.
        ],
      ),
    );
  }
}
