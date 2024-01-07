import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoriquePage extends StatefulWidget {
  final String numeroMatricule;

  const HistoriquePage({Key? key, required this.numeroMatricule})
      : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<HistoriqueEntry> historiqueEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoriqueData();
  }

  Future<void> _fetchHistoriqueData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.58.25:5000/api/userParking/historique/AS%209527XV'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        setState(() {
          historiqueEntries = parseHistoriqueEntries(jsonDecode(response.body));
        });
      } else {
        debugPrint("Erreur lors de la requête : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des données : $e");
    }
  }

  List<HistoriqueEntry> parseHistoriqueEntries(dynamic responseBody) {
    return List<HistoriqueEntry>.from(responseBody.map((data) {
      return HistoriqueEntry.fromJson(data);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'HISTORIQUE',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 38.0,
                columns: const [
                  DataColumn(label: Text('Matricule')),
                  DataColumn(label: Text('Arrivée')),
                  DataColumn(label: Text('Départ')),
                ],
                rows: historiqueEntries
                    .map((entry) => DataRow(cells: [
                          DataCell(Text(entry.matricule)),
                          DataCell(Text(entry.dateEntrance)),
                          DataCell(Text(entry.dateExit)),
                        ]))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(
                  'image/smart_parking_logo.png'), // Ajustez le chemin de l'image
            ),
          ],
        ),
      ),
    );
  }
}

class HistoriqueEntry {
  final String matricule;
  final String dateEntrance;
  final String dateExit;

  HistoriqueEntry({
    required this.matricule,
    required this.dateEntrance,
    required this.dateExit,
  });

  factory HistoriqueEntry.fromJson(Map<String, dynamic> json) {
    return HistoriqueEntry(
      matricule: json['matricule'] as String,
      dateEntrance: (json['dateArrivee'] as String?) ?? '',
      dateExit: (json['datePartir'] as String?) ?? '',
    );
  }
}
