import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'dart:convert';

class Rapports extends StatefulWidget {
  const Rapports({Key? key}) : super(key: key);

  @override
  State<Rapports> createState() => _RapportsState();
}

class _RapportsState extends State<Rapports> {
  TextEditingController txtClasse = TextEditingController();

  List<Map<String, dynamic>> items = [];

  Future<void> fetchData(String classe) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:81/inscription/chargementpayement.php"),
        body: {'classe': classe}, // Envoyer le paramètre 'date' en POST
      );

      if (response.statusCode == 200) {
        setState(() {
          items = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        // Gérer les erreurs de statut HTTP
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Gérer les erreurs de connexion
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(txtClasse.text); // Load initial data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Rapport Paiement'),
        actions: [
          IconButton(
            onPressed: () {
              fetchData(txtClasse.text);
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtClasse,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  hintText: 'Saisir Classe',
                  labelText: 'Classe',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('matricule')),
                  DataColumn(label: Text('nom')),
                  DataColumn(label: Text('postnom')),
                  DataColumn(label: Text('prenom')),
                  DataColumn(label: Text('classe')),
                  DataColumn(label: Text('MotifPaiement')),
                  DataColumn(label: Text('montant')),
                  DataColumn(label: Text('DatePaiement')),
                ],
                rows: items.map<DataRow>((item) {
                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                      (states) {
                        // Mettez ici la couleur que vous souhaitez pour la première ligne
                        return Colors.grey.shade200;
                      },
                    ),
                    cells: [
                      DataCell(
                        Text(item['matricule'] ?? ''),
                      ),
                      DataCell(
                        Text(item['nom'] ?? ''),
                      ),
                      DataCell(
                        Text(item['postnom'] ?? ''),
                      ),
                      DataCell(
                        Text(item['prenom'] ?? ''),
                      ),
                      DataCell(
                        Text(item['classe'] ?? ''),
                      ),
                      DataCell(
                        Text(item['MotifPaiement'] ?? ''),
                      ),
                      DataCell(
                        Text(item['montant'] ?? ''),
                      ),
                      DataCell(
                        Text(item['DatePaiement'] ?? ''),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
