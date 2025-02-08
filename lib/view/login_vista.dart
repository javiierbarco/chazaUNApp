import 'package:chazaunapp/Components/boton_google.dart';
import 'package:chazaunapp/Controller/login_controller.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginVista extends StatefulWidget {
  const LoginVista({super.key});

  @override
  State<LoginVista> createState() => _LoginVistaState();
}

class _LoginVistaState extends State<LoginVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Container(
          color: colorBackground,
          child: Column(
            children: [
              Stack(
                children: [
                  // Contenedor con texto y fondo
                  barraSuperior_(),
                ],
              ),
              const SizedBox(
                height: 33,
              ),
              inputEmail_(),
              inputPassword_(),
              Row(
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  olvidoPassButtom_(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              inicioSesionButtom_(),
              const SizedBox(
                height: 15,
              ),
              const BotonGoogle(),
              Row(
                children: [
                  const SizedBox(
                    width: 55,
                  ),
                  const Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  registrarseButtom_(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox barraSuperior_() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height*0.25;
    return SizedBox(
      height: screenHeight,
      child: Container(
        decoration: const BoxDecoration(
          color:
              colorPrincipal, // Establece el color de fondo del contenedor con el texto
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
        ),
        child: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Ingresar', // el texto que quieres mostrar
              style: TextStyle(
                  color: Colors.white, // Establece el color del texto
                  fontSize: 60.0, // Establece el tamaño del texto
                  fontFamily: "Inder",
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  inputEmail_() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: correoController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorFondoField,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          labelText: 'Correo',
          labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  inputPassword_() {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: contrasenaController,
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorFondoField,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          labelText: 'Contraseña',
          labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  TextButton olvidoPassButtom_() {
    return TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(1)),
        onPressed: recuperarPassword_(),
        child: const Text(
          '¿Olvidó su contraseña?',
          style: TextStyle(
              color: colorChazero,
              fontSize: 15,
              fontFamily: "Inder",
              fontWeight: FontWeight.bold),
        ));
  }

  ElevatedButton inicioSesionButtom_() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: const Size(
              340, 55), // double.infinity is the width and 30 is the height
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: verificar_(),
        child: const Text(
          "Iniciar sesión",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ));
  }

  TextButton registrarseButtom_() {
    return TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 10)),
        onPressed: registrarse_(),
        child: const Text(
          'Regístrate aquí',
          style: TextStyle(
              color: colorChazero,
              fontSize: 15,
              fontFamily: "Inder",
              fontWeight: FontWeight.bold),
        ));
  }

  recuperarPassword_() {
    return () {
      Navigator.pushNamed(context, '/contrasena');
    };
  }

  verificar_() {
    return () async {
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: correoController.text,
            password: contrasenaController.text);
      } on FirebaseAuthException {
        mostrarErroe();
      }

    };
  }

  registrarse_() {
    return () {
      Navigator.pushNamed(context, '/registro/selector');
    };
  }

  bool verificarUsuario(String mail, List data, String pass) {
    for (var i = 0; i < data.length; i++) {
      if (data[i]['correo'] == mail && verificarContrasena(pass, data, i)) {
        return true;
      }
    }
    return false;
  }

  bool verificarContrasena(String text, List data, int posicion) {
    if (data[posicion]['contraseña'] == text) {
      return true;
    }
    return false;
  }

  void mostrarErroe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Credenciales incorrectas",
            style: TextStyle(fontSize: 35, color: colorPrincipal),
          ),
          content: const Text("Por favor, inténtelo de nuevo.",
              style: TextStyle(fontSize: 25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text("Cerrar",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
