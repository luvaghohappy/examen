import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  List<Map<String, dynamic>> items = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:81/inscription/chargerjournal.php"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Journal des Operations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text('services et operations'),
                ),
                DataColumn(
                  label: Text('date_heure'),
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
                        item['service'].toString(),
                      ),
                    ),
                    DataCell(
                      Text(item['date_heure']),
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
