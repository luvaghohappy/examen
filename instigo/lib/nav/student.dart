import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

class Recouvrement extends StatefulWidget {
  const Recouvrement({Key? key}) : super(key: key);

  @override
  State<Recouvrement> createState() => _RecouvrementState();
}

class _RecouvrementState extends State<Recouvrement> {
  String currentDate = DateFormat('y-MM-dd').format(DateTime.now());
  TextEditingController montantController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  List<Map<String, dynamic>> items = [];

  // Fonction pour charger les données
  Future<void> loadData() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://localhost:81/inscription/recouvrement.php?class=${classeController.text}&amount=${montantController.text}"),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded != null && decoded is List) {
          setState(() {
            items = List<Map<String, dynamic>>.from(decoded);
          });
        } else {
          throw Exception('Invalid data received from server');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: classeController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade100,
                  labelText: 'Classe',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: montantController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade100,
                  labelText: 'Montant',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Postnom')),
                  DataColumn(label: Text('Prenom')),
                  DataColumn(label: Text('classe')),
                  DataColumn(label: Text('Montant')),
                  DataColumn(label: Text('Total')),
                ],
                rows: items.map<DataRow>((item) {
                  return DataRow(cells: [
                    DataCell(Text(item['nom'] ?? '')),
                    DataCell(Text(item['postnom'] ?? '')),
                    DataCell(Text(item['prenom'] ?? '')),
                    DataCell(Text(item['classe'] ?? '')),
                    DataCell(Text(item['montant'] != null ? item['montant'].toString() : '')),
                    DataCell(Text(item['total_solde'] != null ? item['total_solde'].toString() : '')),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(
                height: 40), // Espace entre le DataTable et le MontantTotal
            Text(
              'DateRecouvrement: $currentDate', // Affichage du MontantTotal
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 60)),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: loadData,
                    child: const Text('Entrer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
