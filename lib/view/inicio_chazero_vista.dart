import 'package:chazaunapp/view/Sprint2/configuracion_vista.dart';
import 'package:chazaunapp/view/Sprint2/info_cuenta.dart';
import 'package:chazaunapp/view/menu_inicial_chazero_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class InicioChazeroVista extends StatefulWidget {
  const InicioChazeroVista({super.key});

  @override
  State<InicioChazeroVista> createState() => _InicioChazeroVistaState();
}

class _InicioChazeroVistaState extends State<InicioChazeroVista> {
  int _currentPageIndex = 0;

  static List<Widget> pages = [
    MenuChazeroVista(FirebaseAuth.instance.currentUser?.uid.toString().trim()),
    const InfoCuenta(),
    const ConfiguracionVista(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: colorPrincipal,
        unselectedItemColor: const Color(0xff909090),
        unselectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        selectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        iconSize: 34,
      ),
    );
  }
}
