import 'package:chazaunapp/view/login_vista.dart';
import 'package:chazaunapp/view/menu_inicial_chazero_vista.dart';
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
            //ingreso?
            if (snapshot.hasData) {
              if (FirebaseAuth.instance.currentUser != null){
                if (FirebaseAuth.instance.currentUser!.email!
                    .endsWith('unal.edu.co')) {
                  return  const MenuInicialVistaView();
                } else {
                  return const MenuChazeroVista();
                }
              } else{
                return const LoginVista();
              }
            } else {
              return const LoginVista();
            }
          }),
    );
  }
}
