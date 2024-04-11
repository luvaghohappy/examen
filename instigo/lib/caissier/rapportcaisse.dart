import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Caisserapport extends StatefulWidget {
  const Caisserapport({Key? key}) : super(key: key);

  @override
  State<Caisserapport> createState() => _CaisserapportState();
}

class _CaisserapportState extends State<Caisserapport> {
  TextEditingController txtdate = TextEditingController();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    // Load initial data when the app starts
  }

  // Fonction pour récupérer les données depuis le serveur
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargerrapport.php"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Rapport Journalier Caisse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0), // Adjust the top padding as needed
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Date: ${items[index]['Dates']}'),
              subtitle: Text('Total: ${items[index]['TotalJournalier']}'),
            );
          },
        ),
      ),
    );
  }
}