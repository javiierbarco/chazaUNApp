import 'package:chazaunapp/Controller/registro_controller.dart';
import 'package:chazaunapp/Services/gauth_service.dart';
import 'package:chazaunapp/view/inicio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

//Titulo del banner
const String _title = 'Registro';
//Verificación de los terminos y condiciones
bool isChecked = false;
//TERMINOS Y CONDICIONES
const terminos =
    'https://doc-hosting.flycricket.io/chazaunapp-terms-of-use/61d6b708-bd87-4bb3-8392-cc8b9ab1fe48/terms';
const policy =
    'https://doc-hosting.flycricket.io/chazaunapp-privacy-policy/f674154c-f1f3-4291-a55f-77743561a2b2/privacy';

class RegistroTrabajadorView extends StatefulWidget {
  const RegistroTrabajadorView({super.key});

  @override
  State<RegistroTrabajadorView> createState() => _RegistroTrabajadorState();
}

class _RegistroTrabajadorState extends State<RegistroTrabajadorView> {
  @override
  void initState() {
    super.initState();
    phoneController.addListener(phoneValidator);
  }

  @override
  void dispose() {
    phoneController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          color: colorBackground,
          alignment: Alignment.center,
          child: Column(
            children: [
              const Title(), //Banner azul
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'Necesitamos tu número de teléfono para que te puedan contactar',
                  style: TextStyle(
                      color: Colors.black, // Establece el color del texto
                      fontSize: 20.0, // Establece el tamaño del texto
                      fontFamily: "Inder",
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneController,
                  validator: (val) {
                    return phoneValidator_;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: colorFondoField,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: "Teléfono",
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      suffixIcon: const Icon(Icons.phone)),
                ),
              ),
              const LoginButton(),
              const Center(
                  child: AgreeCheck()), //checkbox de terminos y condiciones
              const Spacer(),
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
      Buttons.GoogleDark,
      text: 'Ingresar con google unal',
      onPressed: () async {
        if (!isChecked) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Por favor acepta nuestros términos y condiciones.'),
            duration: Duration(seconds: 2),
          ));
        } else if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Ingresa tu número de telefono.',
            ),
            duration: Duration(seconds: 2),
          ));
        } else {
          try {
            await GAuthService()
                .ingresarGoogle(true, phoneController.text, context);
            await goMenu();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Hubo un error, intenta más tarde.',
              ),
              backgroundColor: Colors.red,
            ));
          }
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
            Expanded(
                child: RichText(
                    text: TextSpan(children: [
              const TextSpan(
                text: 'Acepto los ', // el texto que quieres mostrar
                style: TextStyle(
                    color: Colors.black, // Establece el color del texto
                    fontSize: 12.0, // Establece el tamaño del texto
                    fontFamily: "Inder",
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                  text: 'términos y condiciones',
                  style: const TextStyle(
                      color: colorPrincipal, // Establece el color del texto
                      fontSize: 12.0, // Establece el tamaño del texto
                      fontFamily: "Inder",
                      fontWeight: FontWeight.normal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      launchUrl(Uri.parse(terminos));
                    }),
              const TextSpan(
                text: ' y nuestra ', // el texto que quieres mostrar
                style: TextStyle(
                    color: Colors.black, // Establece el color del texto
                    fontSize: 12.0, // Establece el tamaño del texto
                    fontFamily: "Inder",
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                  text: 'política de privacidad.',
                  style: const TextStyle(
                      color: colorPrincipal, // Establece el color del texto
                      fontSize: 12.0, // Establece el tamaño del texto
                      fontFamily: "Inder",
                      fontWeight: FontWeight.normal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      launchUrl(Uri.parse(policy));
                    })
            ]))),
          ],
        ));
  }
}
