import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instigo/admin/historique.dart';
import 'admin/service.dart';
import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController txtdesignation = TextEditingController();
  TextEditingController txtsection = TextEditingController();
  TextEditingController txtoption = TextEditingController();
  //insert data
  //
  //
 Future<List> insertData() async {
    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/insertclasse.php"),
      body: {
        'designation': txtdesignation.text,
        'section': txtsection.text,
        'options': txtoption.text,
      },
    );
    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtdesignation.clear();
      txtoption.clear();
      txtsection.clear();

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enregistrement réussi'),
        ),
      );

      // Charger à nouveau les données
      fetchData();
    } else {
      // Afficher un message d'erreur en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
        ),
      );
    }

    return [];
  }

  //charger data
  //
  //
  List<Map<String, dynamic>> items = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargerclasse.php"),
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

  @override
  void initState() {
    super.initState();
    fetchData(); // Load initial data when the app starts
  }

  //delete data
  //
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
      var url = 'http://localhost:81/inscription/deleteadmin.php?id=$id';

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

//
// Ajoutez cette méthode pour afficher une boîte de dialogue de modification
  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    // Initialiser les contrôleurs de texte avec les valeurs de l'élément à modifier
    txtdesignation.text = item['designation'] ?? '';
    txtsection.text = item['section'] ?? '';
    txtoption.text = item['options'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier Classe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtdesignation,
                  decoration: const InputDecoration(labelText: 'Designation'),
                ),
                TextField(
                  controller: txtsection,
                  decoration: const InputDecoration(labelText: 'Section'),
                ),
                TextField(
                  controller: txtoption,
                  decoration: const InputDecoration(labelText: 'Option'),
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

// Ajoutez cette méthode pour envoyer une requête de mise à jour
  Future<void> updateData(String id) async {
    final designation = txtdesignation.text;
    final section = txtsection.text;
    final option = txtoption.text;

    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/updateclasse.php"),
      body: {
        'id': id,
        'designation': designation,
        'section': section,
        'options': option,
      },
    );

    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtdesignation.clear();
      txtsection.clear();
      txtoption.clear();

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

//
  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter Classe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtdesignation,
                  decoration: const InputDecoration(labelText: 'designation'),
                ),
                TextField(
                  controller: txtsection,
                  decoration: const InputDecoration(labelText: 'section'),
                ),
                TextField(
                  controller: txtoption,
                  decoration: const InputDecoration(labelText: 'option'),
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
                // fetchData();
                // Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Admin Panel'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  fetchData();
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              IconButton(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black, // Couleur de fond souhaitée
              ),
              child: Column(
                children: const [
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Center(
                    child: Text(
                      'Admin Panel',
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold), // Couleur du texte
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Historique(),
                  ),
                );
              },
              title: const Text('Historiques'),
              leading: const Icon(Icons.work_history),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Services(),
                  ),
                );
              },
              title: const Text('Services'),
              leading: const Icon(Icons.work_outline),
            ),
            const Padding(padding: EdgeInsets.only(top: 310)),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Mylogin()),
                );
              },
              title: const Text('Deconnexion'),
              leading: const Icon(Icons.app_blocking),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              DataTable(
                columns: const [
                  DataColumn(
                    label: Text('designation'),
                  ),
                  DataColumn(
                    label: Text('Section'),
                  ),
                  DataColumn(
                    label: Text('Option'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
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
                          item['designation'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(item['section']),
                      ),
                      DataCell(
                        Text(item['options']),
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
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteData(context, item['id']);
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
