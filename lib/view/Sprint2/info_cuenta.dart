// ignore: file_names
import 'package:chazaunapp/Services/Sprint2/info_personal_services.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class InfoCuenta extends StatefulWidget {
  const InfoCuenta({super.key});
  @override
  State<InfoCuenta> createState() => _InfoCuentaState();
}

const colorTextSuperior = Color(0xff2C2C2C);
const colorTextInferior = Color(0xffA7A7A7);

class _InfoCuentaState extends State<InfoCuenta> {
  late TextEditingController controllerCampo;
  String campolleno = ' ';
  final s1 = '';
  final s2 = '';
  String nombre = '';
  String contrasena = '';
  String apellido = '';
  String telefono = '';
  String telefonoOculto = '';
  String email = '';
  String emailOculto = '';
  Timestamp fechaCreacion = Timestamp(0, 0);
  Timestamp fechaUltimaActualizacion =  Timestamp(0, 0);
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
        resultado = await traerInfoGeneral(uid);

        setState(() {
          nombre = resultado[4] + ' ' + resultado[6];
          apellido = resultado[3] + ' ' + resultado[5];
          contrasena = resultado[0];
          telefono = resultado[2];
          email = resultado[1];
          fechaCreacion = resultado[7];
          fechaUltimaActualizacion = resultado [8];
          telefonoOculto = telefono.replaceRange(3, 6, '***');
          emailOculto = email.replaceRange(3, 8, '******');
        }); // Actualizar el estado para mostrar los datos en el widget
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener la información personal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
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
    return const CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
        'https://cnnespanol.cnn.com/wp-content/uploads/2016/08/juan-gabriel-pleno.jpg?quality=100&strip=info',
      ),
    );
  }

  Expanded botonCambiar() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: (){},
            child: const Text(
              "Informacion Personal",
              style: TextStyle(fontSize: 20, color: Color(0xff404040)),
            ),
          ),
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
              content: Text('Para cambiar este campo contacta con soporte')));
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
      FirebaseAuth.instance.currentUser?.updateDisplayName(nombre);
    } else if (variablCambiar == 1) {
      apellido = controllerCampo.text;
    } else if (variablCambiar == 2) {
      telefono = controllerCampo.text;
    } else if (variablCambiar == 3) {
      email = controllerCampo.text;
    }
    if (FirebaseAuth.instance.currentUser != null) {
      await actualizarDatos(
          FirebaseAuth.instance.currentUser?.uid,
          email,
          contrasena,
          telefono,
          apellido.split(' ')[0],
          nombre.split(' ')[0],
          apellido.split(' ')[1],
          nombre.split(' ')[1],
          fechaCreacion);
      controllerCampo.text = '';
    }
  }

  Future<String?> openDialog(Function toExecute, int cambiarVariable, TextInputType tipoTeclado) =>
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Actualizar datos',
            style: TextStyle(fontSize: 25),
          ),
          content: TextField(
            keyboardType: tipoTeclado,
              controller: controllerCampo,
              autofocus: true,
              decoration:
                  const InputDecoration(hintText: 'Ingrese los nuevos datos')),
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
