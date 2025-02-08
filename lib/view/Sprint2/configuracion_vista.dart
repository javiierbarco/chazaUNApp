import 'package:app_settings/app_settings.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:chazaunapp/view/inicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Services/Sprint2/info_personal_services.dart';

class ConfiguracionVista extends StatefulWidget {
  const ConfiguracionVista({super.key});

  @override
  State<ConfiguracionVista> createState() => _ConfiguracionVistaState();
}

User? usuario = FirebaseAuth.instance.currentUser;

class _ConfiguracionVistaState extends State<ConfiguracionVista> {
  late TextEditingController controllerCampo;
  String nombre = '';
  String apellido = '';
  List<dynamic> resultado = [];
  @override
  void initState() {
    super.initState();
    obtenerInfoPersonal();
  }

  Future<void> obtenerInfoPersonal() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        resultado = await traerInfoGeneral(uid);

        setState(() {
          nombre = resultado[4];
          apellido = resultado[3];
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
      body: Column(children: [
        barraConfiguracion_(),
        const SizedBox(
          height: 15,
        ),
        nombrePersona_(),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Color(0xffAEB4B7),
          thickness: 2,
        ),
        opciones_(Icons.account_box, "Cuenta",
            "Privacidad, Visibilidad, Editar Perfil", cuentaMove_()),
        opciones_(Icons.notifications, "Notificaciones", "Perfil",
            notificacionesMove_()),
        opciones_(
            Icons.help_outline_outlined,
            "Ayuda",
            "Preguntas frecuentes, soporte, \n politica de privacidad",
            ayudaMove_()),
        const SizedBox(
          height: 30,
        ),
        cerrarSesionBoton_()
      ]),
    );
  }

  Stack barraConfiguracion_() {
    return Stack(children: [
      Container(
        color: colorPrincipal,
        height: 85,
        width: 500,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(children: [
            volverBoton_(),
            const Text(
              "Configuración",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )
          ]),
        ),
      ),
    ]);
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

  Row nombrePersona_() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
            width: 65.0,
            height: 65.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: fotoActual()),
        const SizedBox(
          width: 10,
        ),
        nombreTxt_('$nombre $apellido')
      ],
    );
  }

  Text nombreTxt_(String nombre) {
    return Text(
      nombre,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    );
  }

  TextButton opciones_(IconData dibujo, String titulo, String subtitulo,
      void Function() functio) {
    return TextButton(
      onPressed: functio,
      child: Column(
        children: [
          const SizedBox(height: 25),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Icon(
                dibujo,
                color: Colors.black,
                size: 50,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  cuentaMove_() {
    return () {
      Navigator.pushNamed(context, '/menu/configuracion/infoPersonalChazero');
    };
  }

  notificacionesMove_() {
    return () {
      AppSettings.openAppSettings();
    };
  }

  ayudaMove_() {
    return () {
      Navigator.pushNamed(context, '/menu/configuracion/contactanos');
    };
  }

  ElevatedButton cerrarSesionBoton_() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(Colors.red.shade400)),
        onPressed: cerrarSesion_(),
        child: const Text(
          "Cerrar sesión",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }

  cerrarSesion_() {
    return () {
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PaginaInicio(),
        ),
        //Esta funcion es para decidir hasta donde hacer pop, ej: ModalRoute.withName('/'));, como está ahí borra todoo
        (_) => false,
      );
    };
  }

  CircleAvatar fotoActual() {
    return const CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(
        'https://cnnespanol.cnn.com/wp-content/uploads/2016/08/juan-gabriel-pleno.jpg?quality=100&strip=info',
      ),
    );
  }
}
