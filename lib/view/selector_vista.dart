import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

class SelectorVista extends StatefulWidget {
  const SelectorVista({super.key});
  @override
  State<SelectorVista> createState() => _SelectorVistaState();
}

class _SelectorVistaState extends State<SelectorVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Stack(
              children: [
                Text(
                  'Registrarse como:',
                  style: TextStyle(
                      color: colorPrincipal, fontSize: 26, fontFamily: "Inder"),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            trabajadorButton(context),
            const SizedBox(
              height: 88,
            ),
            chazeroButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton trabajadorButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorTrabajador,
        minimumSize: Size(
            screenWidth * 0.77,
            screenHeight *
                0.066), // double.infinity is the width and 30 is the height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      onPressed: registrarseTrabajador(context),
      child: const Text(
        "TRABAJADOR",
        style: TextStyle(
            color: colorBackground, fontSize: 24, fontFamily: "Inder"),
      ),
    );
  }

  ElevatedButton chazeroButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorChazero,
        minimumSize: Size(
            screenWidth * 0.77,
            screenHeight *
                0.066), // double.infinity is the width and 30 is the height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      onPressed: registrarseChazero(context),
      child: const Text(
        "CHAZERO",
        style: TextStyle(
            color: colorBackground, fontSize: 24, fontFamily: "Inder"),
      ),
    );
  }

  Function() registrarseTrabajador(BuildContext context) {
    return () {
      Navigator.pushNamed(context, '/registro/trabajador');
    };
  }

  Function() registrarseChazero(BuildContext context) {
    return () {
      Navigator.pushNamed(context, '/registro/chazero');
    };
  }
}
