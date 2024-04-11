import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instigo/admin.dart';
import 'package:instigo/caissier.dart';
import 'package:instigo/caissier/title.dart';
import 'package:instigo/navigation.dart';
import 'navsec.dart';

class Mylogin extends StatefulWidget {
  const Mylogin({super.key});

  @override
  State<Mylogin> createState() => _MyloginState();
}

class _MyloginState extends State<Mylogin> {
  bool _obscureText = true;
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 150),
            ),
            const Text(
              'LOGIN PAGE',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            const Text(
              "Bienvenue INSTIGO",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Padding(
                padding: const EdgeInsets.all(17),
                child: TextField(
                  controller: txtemail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: TextField(
                controller: txtpassword,
                obscureText: _obscureText,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            GestureDetector(
              onTap: () {
                // insertData();
                String password = txtpassword.text;
                print('Passwords: $password');
                if (txtemail.text == 'a' && txtpassword.text == 'a') {
                  // Accès autorisé, ouvrir la page 'admin'
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Admin(),
                    ),
                  );
                }
                // Vérifier les conditions de connexion
                else if (txtemail.text == 'com' &&
                    txtpassword.text == 'com') {
                  // Accès autorisé, ouvrir la page 'Compte'
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const navigation(),
                    ),
                  );
                } else if (txtemail.text == 'sec' &&
                    txtpassword.text == 'sec') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Navsec(),
                    ),
                  );
                } else if (txtemail.text == 'caisse' &&
                    txtpassword.text == 'caisse') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Caisse(),
                    ),
                  );
                } else {
                  // Accès refusé, afficher un message d'erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email ou mot de passe incorrect.'),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                width: 230,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: const Center(
                  child: Text(
                    "Connectez-vous",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Text(
                'Instigo Services',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
