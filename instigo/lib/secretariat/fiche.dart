import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class Fiche extends StatefulWidget {
  final String matricule;

  Fiche(this.matricule);

  @override
  State<Fiche> createState() => _FicheState();
}

class _FicheState extends State<Fiche> {
  final String schoolName = "INSTIGO GOMA";
  final String secretaire = "Mr Mwanza";
  String nom = "Nom";
  String postnom = "Postnom";
  String prenom = "Prenom";
  String classe = "classe";
  String section = "section";
  String option = "options";
  String matricule = "matricule";
  String annee = "AnneScolaire";
  int receiptNumber = 0;

  @override
  void initState() {
    super.initState();
    _fetchReceiptData();
  }

  //imprimer recu
  //
  //
  Future<Uint8List> generatePdf() async {
    final pdf = pdfLib.Document();

    // Add content to PDF
    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.SizedBox(height: 10),
              pdfLib.Text(
                "FICHE D'INSCRIPTION ELEVE",
                style: pdfLib.TextStyle(
                    fontWeight: pdfLib.FontWeight.bold, fontSize: 15),
              ),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text('Fiche de: $nom $postnom $prenom'),
              pdfLib.Text('Inscrit(e) en $classe , section: $section'),
              pdfLib.Text('Option: $option avec matricule: $matricule'),
              pdfLib.Text('Annee Scolaire: $annee'),
              pdfLib.Text('Signé par le Secretaire: $secretaire'),
            ],
          );
        },
      ),
    );

    // Return PDF as bytes
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

//charger les donnees
  Future<void> _fetchReceiptData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:81/inscription/fiche.php?matricule=${widget.matricule}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> receiptData = jsonDecode(response.body);
        setState(() {
          nom = receiptData['nom'];
          postnom = receiptData['postnom'];
          prenom = receiptData['prenom'];
          classe = receiptData['classe'];
          section = receiptData['section'];
          option = receiptData['options'];
          matricule = receiptData['matricule'];
          annee = receiptData['AnneScolaire'];

          // Calculate total based on class
        });
      } else {
        // Handle non-200 status code
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error fetching receipt data: $e');
      // Show error message to user
      // You can implement this part
    }
  }

  //file picker

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Fiche Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(width: 10),
          Text(
            schoolName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Fiche N° $receiptNumber',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            'Fiche de: $nom $postnom $prenom',
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
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            "Signé par le Secretaire : $secretaire",
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
        ]),
      ),
    );
  }
}
