import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pdfLib;

class Print extends StatefulWidget {
  final String matricule;
  final String datePaiement;

  Print(this.matricule, this.datePaiement);

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  final String schoolName = "INSTIGO GOMA";
  final String Director = "Mr Mwisho";
  String nom = "Nom";
  String postnom = "Postnom";
  String prenom = "Prenom";
  String classe = "classe";
  String section = "section";
  String option = "options";
  String matricule = "matricule";
  double sommepaye = 0.0;
  double montantPaye = 0.0;
  double total = 0.0;
  double resteAPayer = 0;
  DateTime datePaiement = DateTime.now();
  int receiptNumber = 0;

  @override
  void initState() {
    super.initState();
    _fetchReceiptData(widget.matricule, widget.datePaiement);
  }

  // Charger les données
  Future<void> _fetchReceiptData(String matricule, String datePaiement) async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:81/inscription/recu.php?matricule=$matricule&DatePaiement=$datePaiement'));

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(response.body);

        if (responseBody is List) {
          // Si la réponse est une liste, prenez le premier élément
          if (responseBody.isNotEmpty) {
            final Map<String, dynamic> receiptData = responseBody[0];
            _updateReceiptData(receiptData);
          } else {
            // Gérer le cas où la liste est vide
            // Peut-être afficher un message à l'utilisateur ou effectuer d'autres actions nécessaires
          }
        } else if (responseBody is Map<String, dynamic>) {
          // Si la réponse est une carte, traitez-la directement
          _updateReceiptData(responseBody);
        } else {
          // Gérer les autres cas si nécessaire
        }
      } else {
        // Gérer le code d'état non-200
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs lors de la requête
      print('Error fetching receipt data: $e');
      // Afficher un message d'erreur à l'utilisateur ou effectuer d'autres actions nécessaires
    }
  }

// Mettre à jour les données du reçu
  void _updateReceiptData(Map<String, dynamic> receiptData) {
    setState(() {
      nom = receiptData['nom'];
      postnom = receiptData['postnom'];
      prenom = receiptData['prenom'];
      classe = receiptData['classe'];
      section = receiptData['section'];
      option = receiptData['options'];
      matricule = receiptData['matricule'];
      sommepaye = double.parse(receiptData['somme']);
      montantPaye = double.parse(receiptData['montant']);
      datePaiement = DateTime.parse(receiptData['DatePaiement']);

      // Calcul du total en fonction de la classe
      switch (classe) {
        case "7ieme":
        case "8ieme":
          total = 150.0;
          break;
        case "1iere":
        case "2ieme":
        case "3ieme":
          total = 200.0;
          break;
        case "4ieme":
          total = 300.0;
          break;
        default:
          total = 0.0; // Gérer d'autres cas si nécessaire
          break;
      }

      // Calcul du montant restant à payer
      resteAPayer = total - sommepaye;
    });
  }


// Générer le PDF
  Future<Uint8List> generatePdf() async {
    final pdf = pdfLib.Document();
  
      // Ajouter le contenu au PDF
      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text('$schoolName'),
                 pdfLib.SizedBox(height: 20),
                pdfLib.SizedBox(height: 20),
                pdfLib.Text('Reçu N° $receiptNumber'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text('Reçu de: $nom $postnom $prenom'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text('Inscrit(e) en $classe , section: $section'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text('Option: $option avec matricule: $matricule'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                    'Montant Payé: $montantPaye , Reste à payer: $resteAPayer'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                    'Date de paiement: ${DateFormat('dd/MM/yyyy').format(datePaiement)}'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text(
                    'Fait à Goma le: ${DateFormat('dd/MM/yyyy').format(datePaiement)}'),
                pdfLib.SizedBox(height: 10),
                pdfLib.Text('Signé par le Comptable: $Director'),
              ],
            );
          },
        ),
      );
      // Retourner le PDF sous forme de bytes
      return pdf.save();
    } 

//print
//
//
  Future<void> printPdf() async {
    final pdfBytes = await generatePdf();
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Recu Paiement'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 40)),
                  Text(
                    schoolName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 70),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Recu N° $receiptNumber',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                'Reçu de: $nom $postnom $prenom',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                'Inscrit(e) en $classe , section: $section',
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                ' option: $option avec matricule: $matricule',
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                'Montant Payé: $montantPaye, Reste à payer: $resteAPayer',
                style: const TextStyle(fontSize: 14),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                'Date de paiement: ${DateFormat('dd/MM/yyyy').format(datePaiement)}',
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Fait à Goma le: ${DateFormat('dd/MM/yyyy').format(datePaiement)}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  "Signé par le Comptable : $Director",
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 100)),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    receiptNumber++; // Increment receipt number
                  });
                  await printPdf(); // Generate and print PDF
                },
                child: const Text('Imprimer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
