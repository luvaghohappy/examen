import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instigo/secretariat/fiche.dart';
import 'dart:convert';
import '../login.dart';

class Iscrire extends StatefulWidget {
  @override
  State<Iscrire> createState() => _IscrireState();
}

class _IscrireState extends State<Iscrire> {
  // generer une fiche
  static Future<Map<String, dynamic>> loadfiche(String matricule) async {
    final Uri url = Uri.parse(
        'http://localhost:81/inscription/fiche.php?matricule=$matricule');

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> receiptData = jsonDecode(response.body);
        return receiptData;
      } else {
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load receipt data: $e');
    }
  }

  //modification dans la table eleve
  //
  //
  TextEditingController txtnom = TextEditingController();
  TextEditingController txtpostnom = TextEditingController();
  TextEditingController txtprenom = TextEditingController();
  TextEditingController txtclasse = TextEditingController();
  TextEditingController txtsection = TextEditingController();
  TextEditingController txtoption = TextEditingController();
  TextEditingController txtannee = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //insertion dans la table eleve
  //
  //

  List<Map<String, dynamic>> items = [];
  Future<List> insertData() async {
    final nom = txtnom.text;
    final postnom = txtpostnom.text;
    final prenom = txtprenom.text;
    final classe = txtclasse.text;
    final section = txtsection.text;
    final option = txtoption.text;
    final annee = txtannee.text;

    if (
        nom.isNotEmpty &&
        postnom.isNotEmpty &&
        prenom.isNotEmpty &&
        classe.isNotEmpty &&
        section.isNotEmpty &&
        option.isNotEmpty &&
        annee.isNotEmpty) {
      final response = await http.post(
        Uri.parse("http://localhost:81/inscription/inserteleve.php"),
        body: {
          'nom': nom,
          'postnom': postnom,
          'prenom': prenom,
          'classe': classe,
          'section': section,
          'options': option,
          'AnneScolaire': annee,
        },
      );
      if (response.statusCode == 200) {
        // Effacer les champs de saisie
        txtnom.clear();
        txtpostnom.clear();
        txtprenom.clear();
        txtclasse.clear();
        txtsection.clear();
        txtoption.clear();
        txtannee.clear();

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enregistrement réussi'),
          ),
        );
      } else {
        // Vérifier si la réponse indique que l'insertion est interdite
        if (response.body ==
            "Insertion interdite : l'élève existe déjà deux fois dans la même année scolaire.") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Insertion interdite : l\'élève existe déjà deux fois dans la même année scolaire.'),
            ),
          );
        } else {
          // Afficher un message d'erreur en cas d'échec
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'enregistrement'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
        ),
      );
    }

    return [];
  }

  //chargement de la table eleve
  //
  //
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargementeleve.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

//fetch data
  Future<void> fetchReceiptData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargercaisse.php"),
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

//modifier
//
// Ajouter cette méthode pour afficher une boîte de dialogue de modification
  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    txtnom.text = item['nom'] ?? '';
    txtpostnom.text = item['postnom'] ?? '';
    txtprenom.text = item['prenom'] ?? '';
    txtclasse.text = item['classe'] ?? '';
    txtsection.text = item['section'] ?? '';
    txtoption.text = item['options'] ?? '';
    txtannee.text = item['AnneScolaire'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier élève'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtnom,
                  decoration: const InputDecoration(labelText: 'nom'),
                ),
                TextField(
                  controller: txtpostnom,
                  decoration: const InputDecoration(labelText: 'postnom'),
                ),
                TextField(
                  controller: txtprenom,
                  decoration: const InputDecoration(labelText: 'prenom'),
                ),
                TextField(
                  controller: txtclasse,
                  decoration: const InputDecoration(labelText: 'classe'),
                ),
                TextField(
                  controller: txtsection,
                  decoration: const InputDecoration(labelText: 'section'),
                ),
                TextField(
                  controller: txtoption,
                  decoration: const InputDecoration(labelText: 'option'),
                ),
                TextField(
                  controller: txtannee,
                  decoration:
                      const InputDecoration(labelText: 'annee scolaire'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                updateData(item['id'].toString());
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

// Ajouter cette méthode pour envoyer une requête de mise à jour
  Future<void> updateData(String id) async {
    final nom = txtnom.text;
    final postnom = txtpostnom.text;
    final prenom = txtprenom.text;
    final classe = txtclasse.text;
    final section = txtsection.text;
    final option = txtoption.text;
    final annee = txtannee.text;

    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/updateeleve.php"),
      body: {
        'id': id,
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'classe': classe,
        'section': section,
        'options': option,
        'AnneScolaire': annee,
      },
    );

    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtnom.clear();
      txtpostnom.clear();
      txtprenom.clear();
      txtclasse.clear();
      txtsection.clear();
      txtoption.clear();
      txtannee.clear();

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mise à jour réussie'),
        ),
      );
    } else {
      // Afficher un message d'erreur en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour'),
        ),
      );
    }
  }

// boite de dialogue insertion
//
//
  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inscription eleve'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtnom,
                  decoration: const InputDecoration(labelText: 'nom'),
                ),
                TextField(
                  controller: txtpostnom,
                  decoration: const InputDecoration(labelText: 'postnom'),
                ),
                TextField(
                  controller: txtprenom,
                  decoration: const InputDecoration(labelText: 'prenom'),
                ),
                TextField(
                  controller: txtclasse,
                  decoration: const InputDecoration(labelText: 'classe'),
                ),
                TextField(
                  controller: txtsection,
                  decoration: const InputDecoration(labelText: 'section'),
                ),
                TextField(
                  controller: txtoption,
                  decoration: const InputDecoration(labelText: 'option'),
                ),
                TextField(
                  controller: txtannee,
                  decoration:
                      const InputDecoration(labelText: 'annee scolaire'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                insertData();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Enregistrement Inscription'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Mylogin()),
            );
          },
          icon: const Icon(Icons.exit_to_app_outlined),
        ),
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          IconButton(
            onPressed: () {
              fetchData();
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              DataTable(
                columns: const [
                  DataColumn(label: Text('matricule')),
                  DataColumn(label: Text('nom')),
                  DataColumn(label: Text('postnom')),
                  DataColumn(label: Text('prenom')),
                  DataColumn(label: Text('classe')),
                  DataColumn(label: Text('section')),
                  DataColumn(label: Text('options')),
                  DataColumn(label: Text('Annee Scolaire')),
                  DataColumn(label: Text('action')),
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
                        Text(item['matricule'] ??
                            ''), // Use default value if null
                      ),
                      DataCell(
                        Text(item['nom'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(
                            item['postnom'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(item['prenom'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(item['classe'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(
                            item['section'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(
                            item['options'] ?? ''), // Use default value if null
                      ),
                      DataCell(
                        Text(item['AnneScolaire'] ??
                            ''), // Use default value if null
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              iconSize: 15,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(item);
                              },
                            ),
                            IconButton(
                              iconSize: 15,
                              icon: const Icon(Icons.download),
                              onPressed: () async {
                                try {
                                  Map<String, dynamic> receiptData =
                                      await loadfiche(
                                          item['matricule'].toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Fiche(
                                        receiptData['matricule'].toString(),
                                        // Pass other necessary receipt data to the Print widget
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  // Handle error, e.g., display a snackbar with an error message
                                  print('Error fetching receipt data: $e');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
