import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

class EnProgreso extends StatefulWidget {
  const EnProgreso({super.key});

  @override
  State<EnProgreso> createState() => _EnProgresoState();
}

class _EnProgresoState extends State<EnProgreso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 320),
              const Icon(
                Icons.design_services_outlined,
                size: 80,
                color: colorPrincipal,
              ),
              const Center(
                child: Text(
                  '    Estamos trabajando en esta\n              funcionalidad',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              const SizedBox(height: 20),
              inicioSesionButtom_()
            ],
          ),
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
        onPressed: verificar_,
        child: const Text(
          "Volver",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ));
  }

  verificar_() {
    Navigator.pop(context);
  }
}
