import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:instigo/login.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../print/printrecu.dart';

class Payement extends StatefulWidget {
  const Payement({super.key});

  @override
  State<Payement> createState() => _PayementState();
}

class _PayementState extends State<Payement> {
  //chargement recu
  //
  Future<Map<String, dynamic>> _fetchReceiptData(
      String matricule, String datePaiement) async {
    final Uri url = Uri.parse(
        'http://localhost:81/inscription/recu.php?matricule=$matricule&DatePaiement=$datePaiement');

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(response.body);

        if (responseBody is List) {
          // Si la réponse est une liste, prenez le premier élément
          if (responseBody.isNotEmpty) {
            return responseBody[0];
          } else {
            // Retournez une carte vide si la liste est vide
            return {};
          }
        } else {
          // Si la réponse est une carte, retournez-la directement
          return responseBody;
        }
      } else {
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load receipt data: $e');
    }
  }

  //insertion
  //
  //
  List<Map<String, dynamic>> items = [];
  final TextEditingController txtnom = TextEditingController();
  final TextEditingController txtpostnom = TextEditingController();
  final TextEditingController txtprenom = TextEditingController();
  final TextEditingController txtclasse = TextEditingController();
  final TextEditingController txtemotif = TextEditingController();
  final TextEditingController txtmontant = TextEditingController();
  final TextEditingController txtdate = TextEditingController();

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    txtnom.dispose();
    txtpostnom.dispose();
    txtprenom.dispose();
    txtclasse.dispose();
    txtemotif.dispose();
    txtmontant.dispose();
    txtdate.dispose();
    super.dispose();
  }

  //selecte data
  //
  //
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        txtdate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //insert data
  //
  //
  Future<void> insertData() async {
    final nom = txtnom.text;
    final postnom = txtpostnom.text;
    final prenom = txtprenom.text;
    final classe = txtclasse.text;
    final motif = txtemotif.text;
    final montant = txtmontant.text;
    final date = txtdate.text;

    if (
        nom.isNotEmpty &&
        postnom.isNotEmpty &&
        prenom.isNotEmpty &&
        classe.isNotEmpty &&
        motif.isNotEmpty &&
        montant.isNotEmpty &&
        date.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse("http://localhost:81/inscription/insertpayement.php"),
          body: {
            'nom': nom,
            'postnom': postnom,
            'prenom': prenom,
            'classe': classe,
            'MotifPaiement': motif,
            'montant': montant,
            'DatePaiement': date,
          },
        );

        if (response.statusCode == 200) {
          txtnom.clear();
          txtpostnom.clear();
          txtprenom.clear();
          txtclasse.clear();
          txtemotif.clear();
          txtmontant.clear();
          txtdate.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Enregistrement réussi'),
            ),
          );
        } else {
          throw Exception('Failed to insert data');
        }
      } catch (e) {
        print('Error inserting data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'enregistrement'),
          ),
        );
      }
    }
  }

  //chargement donnee
  //
  //
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/charger.php"),
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
      var url = 'http://localhost:81/inscription/deletepayement.php?id=$id';

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
  void initState() {
    super.initState();
    fetchData(); // Load initial data when the app starts
  }

//
// Ajoutez une méthode pour afficher une boîte de dialogue de modification
  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    // Initialiser les contrôleurs de texte avec les valeurs de l'élément à modifier
    txtnom.text = item['nom'] ?? '';
    txtpostnom.text = item['postnom'] ?? '';
    txtprenom.text = item['prenom'] ?? '';
    txtclasse.text = item['classe'] ?? '';
    txtemotif.text = item['MotifPaiement'] ?? '';
    txtmontant.text = item['montant'] ?? '';
    txtdate.text = item['DatePaiement'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier Paiement'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtnom,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: txtpostnom,
                  decoration: const InputDecoration(labelText: 'Postnom'),
                ),
                TextField(
                  controller: txtprenom,
                  decoration: const InputDecoration(labelText: 'Prenom'),
                ),
                TextField(
                  controller: txtclasse,
                  decoration: const InputDecoration(labelText: 'Classe'),
                ),
                TextField(
                  controller: txtemotif,
                  decoration:
                      const InputDecoration(labelText: 'Motif Paiement'),
                ),
                TextField(
                  controller: txtmontant,
                  decoration: const InputDecoration(labelText: 'Montant'),
                ),
                TextField(
                  controller: txtdate,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: IconButton(
                      iconSize: 15,
                      onPressed: () => _selectDate(),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
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
    final nom = txtnom.text;
    final postnom = txtpostnom.text;
    final prenom = txtprenom.text;
    final classe = txtclasse.text;
    final motif = txtemotif.text;
    final montant = txtmontant.text;
    final date = txtdate.text;

    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/updatepayement.php"),
      body: {
        'id': id,
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'classe': classe,
        'MotifPaiement': motif,
        'montant': montant,
        'DatePaiement': date,
      },
    );

    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtnom.clear();
      txtpostnom.clear();
      txtprenom.clear();
      txtclasse.clear();
      txtemotif.clear();
      txtmontant.clear();
      txtdate.clear();

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
          title: const Text('Enregister payement'),
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
                  controller: txtemotif,
                  decoration: const InputDecoration(labelText: 'motif'),
                ),
                TextField(
                  controller: txtmontant,
                  decoration: const InputDecoration(labelText: 'montant'),
                ),
                TextField(
                  controller: txtdate,
                  decoration: InputDecoration(
                    labelText: 'date',
                    prefixIcon: IconButton(
                      iconSize: 15,
                      onPressed: () => _selectDate(),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
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
        title: const Text('Enregistrement Payement'),
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
            onPressed: fetchData,
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
                  DataColumn(label: Text('Matricule')),
                  DataColumn(label: Text('nom')),
                  DataColumn(label: Text('postnom')),
                  DataColumn(label: Text('prenom')),
                  DataColumn(label: Text('classe')),
                  DataColumn(label: Text('Motif')),
                  DataColumn(label: Text('montantPaye')),
                  DataColumn(label: Text('Date de payement')),
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
                        Text(
                          item['matricule'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['nom'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['postnom'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['prenom'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['classe'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['MotifPaiement'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['montant'].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['DatePaiement'].toString(),
                        ),
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
                              onPressed: () {
                                deleteData(context, item['id']);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              iconSize: 15,
                              icon: const Icon(Icons.download),
                              onPressed: () async {
                                try {
                                  Map<String, dynamic> receiptData =
                                      await _fetchReceiptData(
                                    item['matricule'].toString(),
                                    item['DatePaiement'].toString(),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Print(
                                          receiptData['matricule'].toString(),
                                          receiptData['DatePaiement'].toString()
                                          // Pass other necessary receipt data to the Print widget
                                          ),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error fetching receipt data: $e');
                                  // Handle error, e.g., display a snackbar with an error message
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
