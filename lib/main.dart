import 'package:chazaunapp/en_progreso.dart';
import 'package:chazaunapp/view/Sprint2/configuracion_vista.dart';
import 'package:chazaunapp/view/Sprint2/perfil_chazero_vista.dart';
import 'package:chazaunapp/view/Sprint2/perfil_trabajador_vista.dart';
import 'package:chazaunapp/view/codigo_vista.dart';
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
      title: 'Material App',
      initialRoute: '/', //prueba
      routes: {
        '/': (context) => const PaginaInicio(),
        '/contrasena': (context) => const ContrasenaVista(),
        '/registro/selector': (context) => const SelectorVista(),
        '/registro/trabajador': (context) => const RegistroTrabajadorView(),
        '/registro/chazero': (context) => const RegistroChazeroVista(),
        '/registro/chazero/codigo': (context) => const CodigoVista(),
        '/menu/chazero': (context) => const MenuChazeroVista(),
        '/menu/trabajador': (context) =>  const MenuInicialVistaView(),
        '/menu/trabajador/perfil': (context) => const PerfilTrabajadorVista(),
        '/menu/chazero/perfil': (context) => const PerfilChazeroVista(),
        '/menu/configuracion': (context) => const ConfiguracionVista(),
        '/progreso': (context) => const EnProgreso(),
      },
    );
  }
}
