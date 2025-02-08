import 'dart:io';

import 'package:chazaunapp/Services/Sprint2/registro_chaza.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Services/Sprint2/select_image.dart';
import '../colors.dart';

class RegistrarChaza extends StatefulWidget {
  const RegistrarChaza({super.key});

  @override
  State<RegistrarChaza> createState() => _RegistrarChazaState();
}

class _RegistrarChazaState extends State<RegistrarChaza> {
  List<Map<String, dynamic>> listTiposChaza = [
    {'name': 'Cocina', 'value': 0},
    {'name': 'Prefabricado', 'value': 1},
    {'name': 'Otros', 'value': 2},
  ];
  String foto =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png';
  String uploades = '';
  File? imageToUpload;
  late int valorElegido = 0;
  final nombreChzaController = TextEditingController();
  final ubicacionChzaController = TextEditingController();
  final sueldoChzaController = TextEditingController();
  final tipoChzaController = TextEditingController();
  final descrpcionChzaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Container(
          color: colorBackground,
          child: Column(children: [
            barraSuperior_(),
            const SizedBox(
              height: 15,
            ),
            cambiarImagen(),
            const SizedBox(
              height: 20,
            ),
            modeloDatos('Nombre de la chaza', nombreChzaController),
            const SizedBox(
              height: 15,
            ),
            modeloDatos('Ubicación', ubicacionChzaController),
            const SizedBox(
              height: 15,
            ),
            modeloDatos('Sueldo', sueldoChzaController),
            const SizedBox(
              height: 15,
            ),
            Container(
                margin: const EdgeInsets.only(top: 0.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: tipoChaza()),
            const SizedBox(
              height: 15,
            ),
            modeloDatos('Descripción', descrpcionChzaController),
            const SizedBox(
              height: 15,
            ),
            registrarBoton_()
          ]),
        ),
      ),
    );
  }

  ElevatedButton registrarBoton_() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: const Size(
              180, 50), // double.infinity is the width and 30 is the height
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: accionRegistrar,
        child: const Text(
          "Registrar",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }

  DropdownButtonFormField<int> tipoChaza() {
    int selectedValue =
        listTiposChaza[0]['value']; // Valor seleccionado inicialmente

    return DropdownButtonFormField<int>(
      value: selectedValue,
      items: listTiposChaza.map((map) {
        return DropdownMenuItem<int>(
          value: map['value'],
          child: Text(map['name']),
        );
      }).toList(),
      onChanged: (int? value) {
        // Actualizar el valor seleccionado
        if (value != null) {
          selectedValue = value;
          valorElegido = value;
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorFondoField,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: colorFondoField, // Cambia el color del borde aquí
            width: 2.0, // Cambia el ancho del borde si es necesario
          ),
        ),
        labelText: 'Tipo de Chaza',
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontFamily: "Inder",
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  modeloDatos(String tipo, TextEditingController controllerBoton) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: controllerBoton,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorFondoField,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(
              color: colorFondoField, // Cambia el color del borde aquí
              width: 2.0, // Cambia el ancho del borde si es necesario
            ),
          ),
          labelText: tipo,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontFamily: "Inder",
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  ElevatedButton cambiarImagen() {
    return ElevatedButton(
      onPressed: () async {
        final imagen = await getImage();
        if (imagen?.path == null) {
          return;
        }
        foto = await uploadImageChaza(File(imagen!.path));
        setState(() {
          imageToUpload = File(imagen.path);
        });
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: imagenBotonStyle(),
    );
  }

  Stack imagenBotonStyle() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            foto,
            fit: BoxFit.cover,
            width: 160,
            height: 130,
          ),
        ),
        const Positioned(
          top: 5,
          left: 0,
          width: 160,
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.add_a_photo,
                size: 45,
                color: colorChazero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox barraSuperior_() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height * 0.25;
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
              'Registrar \n Chaza', // el texto que quieres mostrar
              textAlign: TextAlign.center,
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

  accionRegistrar() async {
    // Verificar que todos los campos estén llenos
    if (nombreChzaController.text.isEmpty ||
        ubicacionChzaController.text.isEmpty ||
        sueldoChzaController.text.isEmpty ||
        descrpcionChzaController.text.isEmpty ||
        (foto ==
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png')) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Campos incompletos'),
            content: const Text(
                'Por favor, completa todos los campos. Incluida la foto'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return; // Detener la ejecución si hay campos vacíos
    }

    // Continuar con la acción de registrar si todos los campos están llenos
    if (FirebaseAuth.instance.currentUser != null) {
      await registrarChaza(
        FirebaseAuth.instance.currentUser?.uid,
        descrpcionChzaController.text,
        foto,
        nombreChzaController.text,
        sueldoChzaController.text,
        '4,5',
        ubicacionChzaController.text,
        valorElegido,
      );

      // Mostrar el AlertDialog después de completar el envío de datos
      mostrarErroe();
    }
  }

  void mostrarErroe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Registro Exitoso",
            style: TextStyle(fontSize: 35, color: colorPrincipal),
          ),
          content: const Text(
              "Tu chaza se ha añadido a tu cuenta, Talvez debas reiniciar la app para verla en el inicio",
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
