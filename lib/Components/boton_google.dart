import 'package:chazaunapp/Services/gauth_service.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:chazaunapp/view/inicio.dart';
import 'package:flutter/material.dart';

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
        onTap: () => GAuthService().ingresarGoogle(false, "", context),
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PaginaInicio(),
      ),
      //Esta funcion es para decidir hasta donde hacer pop, ej: ModalRoute.withName('/'));, como está ahí borra todoo
      (_) => false,
    );
  }
}
