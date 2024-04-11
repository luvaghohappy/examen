import 'package:flutter/material.dart';
import 'package:instigo/secretaire.dart';
import 'package:instigo/secretariat/rapport.dart';
import 'secretariat/inscription.dart';

class Navsec extends StatefulWidget {
  const Navsec({super.key});

  @override
  State<Navsec> createState() => _NavsecState();
}

class _NavsecState extends State<Navsec> {
  int currentindex = 0;
  List<Widget> screen = [
    const Secretaire(),
     Iscrire(),
    const SecRapport(),

  ];
  void _listbotton(int index) {
    currentindex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomSheet: screen[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey.shade500,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentindex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_add,
                size: 19,
                color: Colors.black,
              ),
              label: 'Identification',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.school_outlined,
                size: 19,
                color: Colors.black,
              ),
              label: 'Inscription',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.remember_me_outlined,
                size: 19,
                color: Colors.black,
              ),
              label: 'Rapport',
              backgroundColor: Colors.black),
        ],
      ),
    );
  }
}
