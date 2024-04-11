import 'package:flutter/material.dart';
import 'package:instigo/secretariat/identite.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'dart:html' as html;
import 'package:printing/printing.dart';

class Secretaire extends StatefulWidget {
  const Secretaire({super.key});

  @override
  State<Secretaire> createState() => _SecretaireState();
}

class _SecretaireState extends State<Secretaire> {
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        txtdatenaiss.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //word
  //
  Future<Uint8List> downloadImage() async {
    final ByteData data = await rootBundle.load('assets/logo.png');
    return data.buffer.asUint8List();
  }

  Future<Uint8List> imprimerDocumentWord() async {
    final pw.Document pdf = pw.Document();
    final Uint8List imageData = await downloadImage();

    // Télécharger l'image

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Titre et Image dans un Row
              pw.Row(
                children: [
                  // Titre
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 10),
                    child: pw.Text(
                      "FICHE D'IDENTIFICATION / INSTIGO",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  // Image
                  pw.Container(
                    width: 50,
                    height: 50,
                    child: pw.Image(pw.MemoryImage(imageData)),
                  ),
                ],
              ),
              // Votre formulaire
              _buildForm(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildForm() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildRow('Nom:', txtnom.text),
        _buildRow('PostNom:', txtpostnom.text),
        _buildRow('Prénom:', txtprenom.text),
        _buildRow('Sexe:', txtsexe.text),
        _buildRow('Date de Naissance:', txtdatenaiss.text),
        _buildRow('Lieu de Naissance:', txtlieunaiss.text),
        _buildRow('État Civil:', txtetat.text),
        _buildRow('Adresse:', txtadresse.text),
        _buildRow('Téléphone:', txtnumero.text),
        _buildRow('Nom du Père:', txtnompere.text),
        _buildRow('Nom de la Mère:', txtnommere.text),
        _buildRow('Province d\'Origine:', txtprov.text),
        _buildRow('Territoire:', txtterritoire.text),
        _buildRow('École de Provenance:', txtecoleprov.text),
        _buildRow('Dossier:', txtdossier.text),
        // Ajoutez les autres champs ici
      ],
    );
  }

  pw.Widget _buildRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.Text(label),
          pw.SizedBox(width: 30),
          pw.Text(value),
        ],
      ),
    );
  }

  TextEditingController txtnom = TextEditingController();
  TextEditingController txtpostnom = TextEditingController();
  TextEditingController txtprenom = TextEditingController();
  TextEditingController txtsexe = TextEditingController();
  TextEditingController txtdatenaiss = TextEditingController();
  TextEditingController txtlieunaiss = TextEditingController();
  TextEditingController txtetat = TextEditingController();
  TextEditingController txtadresse = TextEditingController();
  TextEditingController txtnumero = TextEditingController();
  TextEditingController txtnompere = TextEditingController();
  TextEditingController txtnommere = TextEditingController();
  TextEditingController txtprov = TextEditingController();
  TextEditingController txtterritoire = TextEditingController();
  TextEditingController txtecoleprov = TextEditingController();
  TextEditingController txtdossier = TextEditingController();
  List<Map<String, dynamic>> items = [];

  //selecte image
  // Uint8List? _imageBytes;
  // Uint8List? _imageData;
  // late html.File _selectedFile;
  // String? _imageBase64;// Variable pour stocker le fichier sélectionné

  // Future<void> _getImage() async {
  //   final html.FileUploadInputElement input = html.FileUploadInputElement();
  //   input.accept = 'image/*';
  //   input.click();

  //   input.onChange.listen((event) {
  //     final file = input.files!.first;
  //     final reader = html.FileReader();
  //     reader.readAsDataUrl(file);
  //     reader.onLoadEnd.listen((event) {
  //       setState(() {
  //         _imageData = const Base64Decoder()
  //             .convert(reader.result.toString().split(",").last);
  //         _imageBase64 = base64Encode(
  //             _imageData!); // Encodez les données de l'image en base64
  //         _selectedFile = file; // Stockage du fichier sélectionné
  //       });
  //     });
  //   });
  // }

  //insert data
  Future<List> insertData() async {
    final response = await http.post(
      Uri.parse("http://localhost:81/inscription/insertindent.php"),
      body: {
        'nom': txtnom.text,
        'postnom': txtpostnom.text,
        'prenom': txtprenom.text,
        'sexe': txtsexe.text,
        'DateNaissance': txtdatenaiss.text,
        'LieuNaissance': txtlieunaiss.text,
        'EtatCivil': txtetat.text,
        'Adresse': txtadresse.text,
        'Telephone': txtnumero.text,
        'NomPere': txtnompere.text,
        'NomMere': txtnommere.text,
        'ProvOrigine': txtprov.text,
        'Territoire': txtterritoire.text,
        'EcoleProv': txtecoleprov.text,
        'Dossier': txtdossier.text,
      },
    );
    if (response.statusCode == 200) {
      // Effacer les champs de saisie
      txtnom.clear();
      txtpostnom.clear();
      txtprenom.clear();
      txtsexe.clear();
      txtdatenaiss.clear();
      txtlieunaiss.clear();
      txtetat.clear();
      txtadresse.clear();
      txtnumero.clear();
      txtnompere.clear();
      txtnommere.clear();
      txtprov.clear();
      txtterritoire.clear();
      txtecoleprov.clear();
      txtdossier.clear();

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enregistrement réussi'),
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
    return [];
  }

  //
  Future<Map<String, dynamic>> getLastRecord() async {
    final response = await http.get(
      Uri.parse("http://localhost:81/inscription/dernier.php"),
    );
    if (response.statusCode == 200) {
      // Parsez la réponse JSON pour obtenir les données du dernier enregistrement
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Erreur lors de la récupération des données du dernier enregistrement');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: Container(
          height: 1325,
          width: 1350,
          child: Card(
            color: Colors.grey.shade100,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'IDENTIFICATION ELEVE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                ListTile(
                  leading: IconButton(
                    onPressed: () async {
                      try {
                        // Récupérez les données du dernier enregistrement
                        final Map<String, dynamic> lastRecord =
                            await getLastRecord();
                        // Mettez à jour les champs de texte avec les données du dernier enregistrement
                        setState(() {
                          txtnom.text = lastRecord['nom'];
                          txtpostnom.text = lastRecord['postnom'];
                          txtprenom.text = lastRecord['prenom'];
                          txtsexe.text = lastRecord['sexe'];
                          txtdatenaiss.text = lastRecord['DateNaissance'];
                          txtlieunaiss.text = lastRecord['LieuNaissance'];
                          txtetat.text = lastRecord['EtatCivil'];
                          txtadresse.text = lastRecord['Adresse'];
                          txtnumero.text = lastRecord['Telephone'];
                          txtnompere.text = lastRecord['NomPere'];
                          txtnommere.text = lastRecord['NomMere'];
                          txtprov.text = lastRecord['ProvOrigine'];
                          txtterritoire.text = lastRecord['Territoire'];
                          txtecoleprov.text = lastRecord['EcoleProv'];
                          txtdossier.text = lastRecord['Dossier'];
                          // Mettez à jour les autres champs de texte de la même manière
                        });
                      } catch (e) {
                        // Gérez les erreurs ici
                        print('Erreur: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Erreur lors du chargement du dernier enregistrement'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtnom,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre nom',
                        labelText: 'Nom'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtpostnom,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre postnom',
                        labelText: 'PostNom'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtprenom,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre prenom',
                        labelText: 'PreNom'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtsexe,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre sexe',
                        labelText: 'Sexe'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdatenaiss,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      fillColor: Colors.white54,
                      filled: true,
                      labelText: 'Date Naissance',
                      hintText: 'date',
                      prefixIcon: IconButton(
                        iconSize: 15,
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtlieunaiss,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre lieu naiss',
                        labelText: 'LieuNaissance'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtetat,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre Etatcivil',
                        labelText: 'Etatcivil'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtadresse,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre Adresse',
                        labelText: 'Adresse'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtnumero,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre Numero',
                        labelText: 'Telephone'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtnompere,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'NomPere',
                        labelText: 'NomPere'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtnommere,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'NomMere',
                        labelText: 'NomMere'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtprov,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre provOrig',
                        labelText: 'ProvinceOrig'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtterritoire,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre Territoire',
                        labelText: 'Territoire'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtecoleprov,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Votre Ecoleprov',
                        labelText: 'Ecoleprov'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdossier,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: 'Vos dossiers',
                        labelText: 'Dossier'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 300),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          insertData();
                        },
                        child: const Text('Ajouter'),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      ElevatedButton(
                        onPressed: () async {
                          final Uint8List docBytes =
                              await imprimerDocumentWord();
                          Printing.layoutPdf(onLayout: (format) => docBytes);
                        },
                        child: const Text('Imprimer'),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
