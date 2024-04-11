// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:instigo/login.dart';

// import 'dart:convert';

// class Enregistrement extends StatefulWidget {
//   const Enregistrement({Key? key}) : super(key: key);

//   @override
//   State<Enregistrement> createState() => _EnregistrementState();
// }

// class _EnregistrementState extends State<Enregistrement> {
//   List<Map<String, dynamic>> items = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData(); // Load initial data when the app starts
//   }

//   //chargement data
//   //
//   //
//  Future<void> fetchData() async {
//   try {
//     final response = await http.post(
//       Uri.parse("http://localhost:81/inscription/solde.php"),
//     );
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       if (responseData is List) {
//         setState(() {
//           // Assurez-vous que les clés correspondent aux noms de colonnes de votre table solde
//           items = List<Map<String, dynamic>>.from(responseData);
//         });
//       } else {
//         throw Exception('Invalid data format');
//       }
//     } else {
//       throw Exception('Failed to load items: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching data: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Failed to load items'),
//       ),
//     );
//   }
// }

//   //delete data
//   //
//   //

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: const Text('Solde Payement'),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Mylogin()),
//             );
//           },
//           icon: const Icon(Icons.exit_to_app_outlined),
//         ),
//         actions: [
//           const Padding(padding: EdgeInsets.only(left: 10)),
//           IconButton(
//             onPressed: fetchData,
//             icon: const Icon(Icons.refresh_outlined),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Padding(padding: EdgeInsets.only(top: 30)),
//               DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Matricule')),
//                   DataColumn(label: Text('Montant')),
//                   DataColumn(label: Text('Date de Paiement')),
//                 ],
//                 rows: items.map<DataRow>((item) {
//                   return DataRow(
//                     color: MaterialStateColor.resolveWith(
//                       (states) {
//                         // Mettez ici la couleur que vous souhaitez pour la première ligne
//                         return Colors.grey.shade200;
//                       },
//                     ),
//                     cells: [
//                       DataCell(
//                         Text(
//                           item['matricule'].toString(),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           item['somme'].toString(),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           item['Datepayement'].toString(),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
