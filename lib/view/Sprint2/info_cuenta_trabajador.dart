import 'dart:io';

// ignore: file_names

import 'package:chazaunapp/Services/Sprint2/select_image.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../Services/Sprint2/info_personal_trabajador_services.dart';

class InfoCuentaTrabajador extends StatefulWidget {
  const InfoCuentaTrabajador({super.key});
  @override
  State<InfoCuentaTrabajador> createState() => _InfoCuentaTrabajadorState();
}

const colorTextSuperior = Color(0xff2C2C2C);
const colorTextInferior = Color(0xffA7A7A7);

class _InfoCuentaTrabajadorState extends State<InfoCuentaTrabajador> {
  late TextEditingController controllerCampo;
  String campolleno = ' ';
  String nombre = '';
  String contrasena = '';
  String apellido = '';
  String telefono = '';
  String telefonoOculto = '';
  String email = '';
  String foto = '';
  String uploades = '';
  String emailOculto = '';
  Timestamp fechaCrea = Timestamp(0, 0);
  List<dynamic> resultado = [];
  @override
  void initState() {
    controllerCampo = TextEditingController();
    super.initState();
    obtenerInfoPersonal();
  }

  @override
  void dispose() {
    super.dispose();
    controllerCampo.dispose();
  }

  Future<void> obtenerInfoPersonal() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        resultado = await traerInfoGeneralTrabajo(uid);

        setState(() {
          apellido = resultado[0];
          email = resultado[1];
          foto = resultado[2];
          nombre = resultado[3];
          telefono = resultado[4];
          fechaCrea = resultado[5];
          telefonoOculto = telefono.replaceRange(3, 6, '***');
          emailOculto = email.replaceRange(3, 8, '******');
        }); // Actualizar el estado para mostrar los datos en el widget
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener la información personal: $e');
    }
  }

  //Con esta variable haremos el proceso de las imagenes
  File? imageToUpload;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondoField,
      body: SingleChildScrollView(
        child: Column(children: [
          barraSuperior_(),
          const SizedBox(
            height: 15,
          ),
          fotoPerfil(),
          const SizedBox(
            height: 10,
          ),
          botonNombre(),
          const SizedBox(
            height: 5,
          ),
          botonApellido(),
          const SizedBox(
            height: 5,
          ),
          botonTelefono(),
          const SizedBox(
            height: 5,
          ),
          botonEmail(),
          const SizedBox(
            height: 5,
          ),
          botonContrasena(),
          const SizedBox(
            height: 10,
          ),
          visibilidadCuenta()
        ]),
      ),
    );
  }

  Stack barraSuperior_() {
    return Stack(children: [
      Container(
        color: colorPrincipal,
        height: 85,
        width: 500,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(children: [
                volverBoton_(),
                const Text(
                  "Configuración",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )
              ]),
            ],
          ),
        ),
      ),
    ]);
  }

  Row fotoPerfil() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        fotoActual(),
        const SizedBox(width: 10),
        botonCambiar(),
      ],
    );
  }

  CircleAvatar fotoActual() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
        foto,
      ),
    );
  }

  Expanded botonCambiar() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () async {
              final imagen = await getImage();
              if (imagen?.path == null) {
                return;
              }
              uploades = await uploadImage(File(imagen!.path));
              cambiarDatos(4);
              setState(() {
                imageToUpload = File(imagen.path);
              });
            },
            child: const Text(
              "Editar foto de perfil",
              style: TextStyle(fontSize: 20, color: Color(0xff404040)),
            ),
          ),
          const Icon(Icons.arrow_forward_ios),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  TextButton botonNombre() {
    return TextButton(
        onPressed: () async {
          final name = await openDialog(cambiarDatos, 0, TextInputType.text);
          if (name == null || name.isEmpty) return;
          setState(() => campolleno = name);
        },
        child: datosPersonales('Nombres', nombre));
  }

  TextButton botonApellido() {
    return TextButton(
        onPressed: () async {
          final name = await openDialog(cambiarDatos, 1, TextInputType.text);
          if (name == null || name.isEmpty) return;
          setState(() => campolleno = name);
        },
        child: datosPersonales('Apellidos', apellido));
  }

  TextButton botonTelefono() {
    return TextButton(
        onPressed: () async {
          final name = await openDialog(cambiarDatos, 2, TextInputType.phone);
          if (name == null || name.isEmpty) return;
          setState(() => campolleno = name);
        },
        child: otrosDatos('Numero de telefono', telefonoOculto));
  }

  TextButton botonEmail() {
    return TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('No es posible editar esta información, consulte TyC')));
        }, //cambiarDatos(controllerCampo.text),
        child: otrosDatos('Email', emailOculto));
  }

  TextButton botonContrasena() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/contrasena');
        },
        child: otrosDatos('Contraseña', ''));
  }

  Row visibilidadCuenta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '   Cuenta visible',
          style: TextStyle(
              color: colorTextSuperior,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.14159),
          child: GFToggle(
            onChanged: (val) {},
            value: true,
            enabledThumbColor: Colors.white,
            enabledTrackColor: colorPrincipal,
            type: GFToggleType.ios,
          ),
        )
      ],
    );
  }

  Row datosPersonales(String tipo, name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tipo,
              style: const TextStyle(
                color: colorTextSuperior,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(color: colorTextInferior, fontSize: 16),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ],
    );
  }

  Row otrosDatos(String tipo, dato) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  $tipo',
          style: const TextStyle(color: colorTextSuperior, fontSize: 20),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dato,
              style: const TextStyle(color: colorTextInferior, fontSize: 16),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ],
    );
  }

  TextButton volverBoton_() {
    return TextButton(
      onPressed: volverInicio_(),
      child: const Icon(
        Icons.arrow_back,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  volverInicio_() {
    return () {
      //No modificar, esto directamente manda a la anterior ventana
      Navigator.pop(
        context,
      );
    };
  }

  void cambiarDatos(int variablCambiar) async {
    if (variablCambiar == 0) {
      nombre = controllerCampo.text;
      //para contactanos UwU
      FirebaseAuth.instance.currentUser?.updateDisplayName(nombre);
    } else if (variablCambiar == 1) {
      apellido = controllerCampo.text;
    } else if (variablCambiar == 2) {
      telefono = controllerCampo.text;
    } else if (variablCambiar == 3) {
      email = controllerCampo.text;
    } else if (variablCambiar == 4) {
      foto = uploades;
    }
    if (FirebaseAuth.instance.currentUser != null) {
      await actualizarDatosTrabajador(FirebaseAuth.instance.currentUser?.uid,
          apellido, email, foto, nombre, telefono, fechaCrea);
      controllerCampo.text = '';
    }
  }

  Future<String?> openDialog(Function toExecute, int cambiarVariable, TextInputType tipoTeclado) =>
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Actualizar datos',
            style: TextStyle(fontSize: 10),
          ),
          content: TextField(
            keyboardType: tipoTeclado,
              controller: controllerCampo,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Ingrese los datos')),
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
                child: const Text("Actualizar",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () {
                  toExecute(cambiarVariable);
                  Navigator.of(context).pop(controllerCampo.text);
                },
              ),
            ),
          ],
        ),
      );
}
