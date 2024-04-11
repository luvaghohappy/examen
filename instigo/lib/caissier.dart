import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'dart:convert';
import 'login.dart';

class Caissier extends StatefulWidget {
  const Caissier({super.key});

  @override
  State<Caissier> createState() => _CaissierState();
}

class _CaissierState extends State<Caissier> {
  List<Map<String, dynamic>> items = [];

  //delete
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
      var url = 'http://localhost:81/inscription/deletecaisse.php?id=$id';

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

  //chargement data
  //
  //
  @override
  void initState() {
    super.initState();
    fetchData();
    // Charger les données dès que le widget est initialisé
  }

  Future<void> fetchData() async {
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

  Future<void> refreshData() async {
    setState(() {
      items.clear(); // Effacez les données existantes avant de rafraîchir
    });
    await fetchData();
  }

  //insertlaoded data
  //
 Future<void> insertData() async {
  try {
    // Envoi des données à l'API pour insertion
    for (var item in items) {
      final response = await http.post(
        Uri.parse("http://localhost:81/inscription/insertcaisse.php"),
        body: json.encode(item), // Envoyer chaque élément individuellement
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data inserted successfully'),
          ),
        );
      
      } else {
        print('Failed to insert data. Error: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to insert data'),
          ),
        );
      }
    }
  } catch (e) {
    print('Failed to insert data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to insert data'),
      ),
    );
  }
}
  //calculer total
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Instigo Caisse'),
        centerTitle: true,
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
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              DataTable(
                columns: const [
                  DataColumn(label: Text('matricule')),
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
                        Text(item['matricule'].toString()),
                      ),
                      DataCell(
                        Text(item['montant'].toString()),
                      ),
                      DataCell(
                        Text(item['DatePaiement'].toString()),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const Padding(padding: EdgeInsets.only(top: 130)),
              ElevatedButton(
                onPressed: insertData,
                child: const Text('Insert Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
