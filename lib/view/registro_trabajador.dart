// view/registro_trabajador.dart
// ignore_for_file: avoid_print

import 'package:chazaunapp/Services/gauth_service.dart';
import 'package:chazaunapp/view/inicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'colors.dart';

//Titulo del banner
const String _title = 'Registro';
//Verificación de los terminos y condiciones
bool isChecked = false;
//Cuenta de google

class RegistroTrabajadorView extends StatefulWidget {
  const RegistroTrabajadorView({super.key});

  @override
  State<RegistroTrabajadorView> createState() => _RegistroTrabajadorState();
}

class _RegistroTrabajadorState extends State<RegistroTrabajadorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: colorBackground,
          alignment: Alignment.center,
          child: const Column(
            children: [
              Title(), //Banner azul
              Flexible(
                  //espacio
                  flex: 1,
                  child: SizedBox(
                    height: 300,
                  )),
              LoginButton(),
              Center(child: AgreeCheck()), //checkbox de terminos y condiciones
            ],
          )),
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});
// Banner azulito bonito xd
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 186.0,
      child: Container(
        decoration: const BoxDecoration(
          color: colorPrincipal,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
          ),
        ),
        child: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _title, // el texto que quieres mostrar
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
}

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});
  @override
  State<LoginButton> createState() => _LoginButton();
}

class _LoginButton extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      text: 'Ingresar con google unal',
      onPressed: () async {
        if (isChecked) {
          try {
            await GAuthService().ingresarGoogle();
            await goMenu();
          } catch (e) {
            print('ingresa con cuenta unal');
          }
        } else {
          print('No ha aceptado');
        }
      },
    );
  }

  //async para esperar el ingreso
  goMenu() async {
    //Vuelve al inicio y borra lo anterior(login, registro y trabajador) para que no se pueda regresar al registro una vez ingresado,
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

//TERMINOS Y CONDICIONES
//https://doc-hosting.flycricket.io/chazaunapp-terms-of-use/61d6b708-bd87-4bb3-8392-cc8b9ab1fe48/terms
//https://doc-hosting.flycricket.io/chazaunapp-privacy-policy/f674154c-f1f3-4291-a55f-77743561a2b2/privacy
class AgreeCheck extends StatefulWidget {
  const AgreeCheck({super.key});

  @override
  State<AgreeCheck> createState() => _Checkbox();
}

class _Checkbox extends State<AgreeCheck> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return colorTrabajador;
      }
      return colorPrincipal;
    }

    return SizedBox(
        width: 250.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                checkColor: colorBackground,
                fillColor: WidgetStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
            const Expanded(
                child: Text(
              'Acepto los términos y condiciones.', // el texto que quieres mostrar
              style: TextStyle(
                  color: Colors.black, // Establece el color del texto
                  fontSize: 12.0, // Establece el tamaño del texto
                  fontFamily: "Inder",
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            )),
          ],
        ));
  }

  menuTrabajador() {
    return () {
      Navigator.pushNamed(context, '/menu/trabajador');
    };
  }
}
