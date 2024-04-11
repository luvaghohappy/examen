import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  List<Map<String, dynamic>> items = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargeruser.php"),
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

  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/insert.php"),
      body: {
        "email": txtemail.text,
        "passwords": txtpassword.text,
      },
    );
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
      var url = 'http://localhost:81/inscription/deleteuser.php?id=$id';

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
    txtemail.text = item['email'] ?? '';
    txtpassword.text = item['passwords'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier Services'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtemail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: txtpassword,
                  decoration: const InputDecoration(labelText: 'Password'),
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
    final email = txtemail.text;
    final password = txtpassword.text;

    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/update.php"),
      body: {
        'id': id,
        'email': email,
        'passwords': password,
      },
    );

    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtemail.clear();
      txtpassword.clear();

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

// boite de dialogue
//
  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter Services'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtemail,
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  controller: txtpassword,
                  decoration: const InputDecoration(labelText: 'password'),
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
                fetchData();
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
        centerTitle: true,
        title: const Text('Services'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: fetchData,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text('Emails'),
                ),
                DataColumn(
                  label: Text('passwords'),
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
                        item['email'].toString(),
                      ),
                    ),
                    DataCell(
                      Text(item['passwords'].toString()),
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
    );
  }
}
