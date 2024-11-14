import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'inicio.dart';

class ContrasenaVista extends StatefulWidget{
  const ContrasenaVista({super.key});

  @override
  State<ContrasenaVista> createState() => _ContrasenaVistaState();

}

class _ContrasenaVistaState extends State<ContrasenaVista>{

  final emailTextController = TextEditingController();
  bool correoEnviado = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: colorBackground,
          child: Column(
            children: [
              // Titulo "¿Olvidaste tu Contraseña?
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "¿Olvidaste tu\n contraseña?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontFamily: "Inder"
                    ),
                  ),
                ) ,
              ),
              const SizedBox(
                height: 100,
                child:  Center(
                  child: Text(
                    "Escribe el correo electrónico con\nel que te registraste para poder\n      recuperar tu contraseña",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: "Inder"
                    ),
                  ),
                ) ,
              ),
              InputEmailVista(emailTextController: emailTextController),
              enviarCorreoButton(),
              const SizedBox(height: 40,),
            ],
          )
        ),
      ),
    );
  }

  ElevatedButton enviarCorreoButton() {
    return ElevatedButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextController.text);
            mostrarMensaje(emailTextController.text);

          } on FirebaseAuthException {
            print(emailTextController.text);
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: colorChazero,
            minimumSize: const Size(340, 55),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
            )
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18
          ),
        )
    );
  }

  void mostrarMensaje(String correo){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: const Text(
              "Correo enviado",
              style: TextStyle(
                fontSize: 24.0,
                color: colorPrincipal
              ),
            ),
            content: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: "Te hemos enviado un correo a ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: "Inder"
                    )
                  ),
                  TextSpan(
                    text: correo,
                    style: const TextStyle(
                      color: colorChazero,
                      fontSize: 18.0,
                      fontFamily: "Inder"
                    ),

                  ),
                  const TextSpan(
                    text: " para cambiar tu contraseña, después de cambiarla intenta acceder de nuevo a tu cuenta.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Inder"
                    )
                  )
                ]
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 20),
                ),
                onPressed: () async { await goMenu(); },
                child: const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                      fontSize: 16,
                      color: colorPrincipal
                  ), textAlign: TextAlign.center
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(right: 20),
                ),
                onPressed: ()  { Navigator.of(context).pop(); },
                child: const Text(
                  "Modificar correo",
                  style: TextStyle(
                      fontSize: 16,
                      color: colorPrincipal
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            ],
          );
        }
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

class InputEmailVista extends StatefulWidget{
  final TextEditingController emailTextController;

  const InputEmailVista({super.key, required this.emailTextController});

  @override
  State<InputEmailVista> createState() => _InputEmailVistaState();

}

class _InputEmailVistaState extends State<InputEmailVista>{



  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: widget.emailTextController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          labelText: "Correo",
          hintText: "example@mail.com",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontFamily: "Inder",
            fontWeight: FontWeight.normal,
          )
        ),
      ),
    );
  }
}
