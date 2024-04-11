import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecRapport extends StatefulWidget {
  const SecRapport({super.key});

  @override
  State<SecRapport> createState() => _SecRapportState();
}

class _SecRapportState extends State<SecRapport> {
  List<Map<String, dynamic>> items = [];
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargersec.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
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
  void initState() {
    super.initState();
    fetchData(); // Load initial data when the app starts
  }

  //delete
  //
  Future<void> deleteData(BuildContext context, String id) async {
    // Affiche une boîte de dialogue de confirmation
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // L'utilisateur ne veut pas supprimer
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // L'utilisateur veut supprimer
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // L'utilisateur a confirmé la suppression, procéder à la suppression des données
      var url = 'http://localhost:81/inscription/deleteeleve.php?id=$id';

      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Données supprimées avec succès');
      } else {
        print(
            'Échec de la suppression des données. Erreur: ${response.reasonPhrase}');
      }
    } else {
      // L'utilisateur a annulé la suppression, ne rien faire
      print('Suppression annulée');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Rapport Paiement'),
        actions: [
          IconButton(
            onPressed: () {
              fetchData();
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: h,
                width: w,
                child: Card(
                  color: Colors.grey.shade100,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('nom')),
                      DataColumn(label: Text('postnom')),
                      DataColumn(label: Text('prenom')),
                      DataColumn(label: Text('sexe')),
                      DataColumn(label: Text('DateNaissance')),
                      DataColumn(label: Text('LieuNaissance')),
                      DataColumn(label: Text('EtatCivil')),
                      DataColumn(label: Text('Adresse')),
                      DataColumn(label: Text('Telephone')),
                      DataColumn(label: Text('NomPere')),
                      DataColumn(label: Text('NomMere')),
                      DataColumn(label: Text('ProvOrigine')),
                      DataColumn(label: Text('Territoire')),
                      DataColumn(label: Text('EcoleProv')),
                      DataColumn(label: Text('Dossier')),
                      DataColumn(label: Text('Action')),
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
                            Text(
                                item['nom'] ?? ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['postnom'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['prenom'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['sexe'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['DateNaissance'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['LieuNaissance'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['EtatCivil'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['Adresse'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['Telephone'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['NomPere'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['NomMere'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['ProvOrigine'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['Territoire'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['EcoleProv'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Text(item['Dossier'] ??
                                ''), // Use default value if null
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  iconSize: 15,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deleteData(
                                        context,
                                        item[
                                            'id']); // Pass the ID of the item to delete
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
