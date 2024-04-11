import 'package:flutter/material.dart';
import 'package:instigo/nav/student.dart';
import 'nav/enregistrement.dart';
import 'nav/solde.dart';
import 'nav/rapport.dart';

class navigation extends StatefulWidget {
  const navigation({super.key});

  @override
  State<navigation> createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  int currentindex = 0;
  List<Widget> screen = [
    const Payement(),
    const Recouvrement(),
    const Rapports(),
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
                Icons.save,
                size: 19,
                color: Colors.black,
              ),
              label: 'Enregistrement',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.money_outlined,
                size: 19,
                color: Colors.black,
              ),
              label: 'Recouvrement',
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
