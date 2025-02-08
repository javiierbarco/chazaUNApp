import 'package:chazaunapp/view/inicio_chazero_vista.dart';
import 'package:chazaunapp/view/login_vista.dart';
import 'package:chazaunapp/view/menu_inicial_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<StatefulWidget> createState() => _PaginaInicio();
}

class _PaginaInicio extends State<PaginaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          //cambios en el ingreso
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //se supone que esto bloquea que no sea null por lo que borre los if extra
            if (snapshot.hasData) {
              // si no se ha registrado con google ->
              if (FirebaseAuth.instance.currentUser!.providerData
                  .where((element) => element.providerId == 'google.com')
                  .isEmpty) {
                return const InicioChazeroVista();
              } else {
                return const MenuInicialVistaView();
              }
            }
            return const LoginVista();
          }),
    );
  }
}