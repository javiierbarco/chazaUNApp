import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'inicio.dart';

class VerificacionEmail extends StatefulWidget{

  const VerificacionEmail({super.key});

  @override
  State<VerificacionEmail> createState() => VerificacionEmailState();
}

class VerificacionEmailState extends State<VerificacionEmail> {

  bool verificado = false;
  Timer? timer;
  String? correo;

  @override
  void initState() {
    super.initState();
    correo = FirebaseAuth.instance.currentUser?.email;
    FirebaseAuth.instance.currentUser?.sendEmailVerification();

    // verifica cada 2 segundos si el link de verificacion enviado al correo
    // ya fue clickeado o no
    timer = Timer.periodic(const Duration(seconds: 2),
            (_) => verificarCorreo());
  }

  @override
  dispose() {
    super.dispose();
    timer?.cancel();
  }


  verificarCorreo() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      verificado = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (verificado){
      await FirebaseAuth.instance.currentUser?.reload();
      //print(FirebaseAuth.instance.currentUser);
      await goMenu();
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: colorBackground,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                "Revisa tu correo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontFamily: "Inder"
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                """Te acabamos de enviar un correo a\n $correo\n para verificar la validez\ndel correo ingresado""",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: "Inder"
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: CircularProgressIndicator(),
            )

          ],
        ),
      ),
    );
  }

  goMenu() async {
    //Vuelve al inicio y borra lo anterior(login, registro y trabajador) para que no se pueda regresar al registro una vez ingresado,
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PaginaInicio(),
      ),
      //Esta funcion es para decidir hasta donde hacer pop, ej: ModalRoute.withName('/'));, como está ahí borra todoo
          (_) => false,
    );
  }
}