import 'package:chazaunapp/Services/gauth_service.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

import '../view/menu_inicial_vista.dart';

//Verificación de los terminos y condiciones
bool isChecked = true;

class BotonGoogle extends StatefulWidget {
  const BotonGoogle({
    super.key,
  });
  @override
  State<BotonGoogle> createState() => _BotonGoogle();
}

class _BotonGoogle extends State<BotonGoogle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => GAuthService().ingresarGoogle(),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const SizedBox(
            height: 10,
          ),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Divider(
                  indent: 40,
                  endIndent: 10,
                  color: Colors.grey,
                )),
                Expanded(
                    child: Text(
                  'O continua con Google unal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, // Establece el color del texto
                      fontSize: 14.0, // Establece el tamaño del texto
                      fontFamily: "Inder",
                      fontWeight: FontWeight.normal),
                )),
                Expanded(
                    child: Divider(
                  indent: 10,
                  endIndent: 40,
                  color: Colors.grey,
                ))
              ]),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: colorFondoField),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white),
            child: Image.asset(
              ('assets/imagenes/btn_google_light_normal.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ]));
  }

  //async para esperar el ingreso
  goMenu() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  const MenuInicialVistaView()));
  }
}
