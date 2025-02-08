import 'package:chazaunapp/en_progreso.dart';
import 'package:chazaunapp/view/Sprint2/configuracion_trabajador_vista.dart';
import 'package:chazaunapp/view/Sprint2/configuracion_vista.dart';
import 'package:chazaunapp/view/Sprint2/contactanos_vista.dart';
import 'package:chazaunapp/view/Sprint2/info_cuenta.dart';
import 'package:chazaunapp/view/Sprint2/info_cuenta_trabajador.dart';
import 'package:chazaunapp/view/Sprint2/perfil_chazero_vista.dart';
import 'package:chazaunapp/view/Sprint2/perfil_trabajador_vista.dart';
import 'package:chazaunapp/view/Sprint2/personal_vista.dart';
import 'package:chazaunapp/view/Sprint2/registro_chaza_vista.dart';
import 'package:chazaunapp/view/Sprint3/calendario_chaza_vista.dart';
import 'package:chazaunapp/view/Sprint3/horarios_chaza_chazero.dart';
import 'package:chazaunapp/view/Sprint3/postulados_chaza.dart';
import 'package:chazaunapp/view/Sprint3/info_chaza_vista.dart';
// ignore: unused_import
import 'package:chazaunapp/view/inicio.dart';
import 'package:chazaunapp/view/menu_inicial_chazero_vista.dart';
import 'package:chazaunapp/view/menu_inicial_vista.dart';
import 'package:chazaunapp/view/recuperar_contrasena_vista.dart';
import 'package:chazaunapp/view/registro_chazero.dart';
import 'package:chazaunapp/view/registro_trabajador.dart';
import 'package:chazaunapp/view/selector_vista.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChazaUNApp',
      initialRoute: '/',
      routes: {
        '/': (context) => const PaginaInicio(),
        '/contrasena': (context) => const ContrasenaVista(),
        '/registro/selector': (context) => const SelectorVista(),
        '/registro/trabajador': (context) => const RegistroTrabajadorView(),
        '/registro/chazero': (context) => const RegistroChazeroVista(),
        '/menu/chazero': (context) => const MenuChazeroVista(""),
        '/menu/chazero/horario': (context) =>
            const HorarioChazaChazeroVista(nombreChaza: "", idHorario: ""),
        '/menu/chazero/personal': (context) => const PersonalVista(),
        '/menu/chazero/registrar/chaza': (context) => const RegistrarChaza(),
        '/menu/trabajador': (context) => const MenuInicialVistaView(),
        '/menu/trabajador/perfil': (context) => const PerfilTrabajadorVista(),
        '/menu/trabajador/chaza/horario': (context) => const HorarioChazaVista(
              nombreChaza: '',
              idHorario: '',
            ),
        '/menu/trabajador/chaza/postulacion': (context) => const PostuladosChaza(idChaza: '',),

        '/menu/chazero/perfil': (context) => const PerfilChazeroVista(),
        '/menu/configuracion': (context) => const ConfiguracionVista(),
        '/menu/configuracionTrabajo': (context) =>
            const ConfiguracionTrabajoVista(),
        '/progreso': (context) => const EnProgreso(),
        '/menu/configuracion/contactanos': (context) => const ContactanosView(),
        '/menu/configuracion/infoPersonalChazero': (context) =>
            const InfoCuenta(),
        '/menu/configuracion/infoPersonalTrabajador': (context) =>
            const InfoCuentaTrabajador(),

        '/menu/chazas/informacion': (context) => const  InfoChazaVista()

      },
    );
  }
}
