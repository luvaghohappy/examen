import 'package:flutter/material.dart';
import 'package:instigo/caissier.dart';
import 'package:instigo/caissier/rapportcaisse.dart';

class Caisse extends StatefulWidget {
  const Caisse({super.key});

  @override
  State<Caisse> createState() => _CaisseState();
}

class _CaisseState extends State<Caisse> {
  int currentindex = 0;
  List<Widget> screen = [
    const Caissier(),
    const Caisserapport(),
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
                Icons.money_sharp,
                size: 19,
                color: Colors.black,
              ),
              label: 'Caisse',
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
