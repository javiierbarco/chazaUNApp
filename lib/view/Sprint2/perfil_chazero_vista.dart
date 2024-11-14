import 'package:flutter/material.dart';

import '../colors.dart';

class PerfilChazeroVista extends StatefulWidget {
  const PerfilChazeroVista({super.key});

  @override
  State<PerfilChazeroVista> createState() => _PerfilChazeroVistaState();
}

class _PerfilChazeroVistaState extends State<PerfilChazeroVista> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: colorBackground,
      );
  }
}
