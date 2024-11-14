import 'package:chazaunapp/view/menu_inicial_chazero_vista.dart';
import 'package:chazaunapp/view/verificar_correo_vista.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:chazaunapp/Services/services_registrochazero.dart';

class RegistroChazeroVista extends StatefulWidget {
  const RegistroChazeroVista({super.key});

  @override
  State<RegistroChazeroVista> createState() => _RegistroChazeroVistaState();
}

class _RegistroChazeroVistaState extends State<RegistroChazeroVista> {
  // controladores de todos los campos de texto
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();
  final contrasenaConfirmacionController = TextEditingController();
  final primerNombreController = TextEditingController();
  final segundoNombreController = TextEditingController();
  final primerApellidoController = TextEditingController();
  final segundoApellidoController = TextEditingController();
  final telefonoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? emailValidator_;
  String? contrasenaValidator_;
  String? contrasenaConfirmacionValidator_;
  String? telefonoValidator_;
  String? primerNombreValidator_;
  String? segundoNombreValidator_;
  String? primerApellidoValidator_;
  String? segundoApellidoValidator_;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.addListener(emailValidator);
    contrasenaController.addListener(contrasenaValidator);
    contrasenaConfirmacionController
        .addListener(contrasenaConfirmacionValidator);
    primerNombreController.addListener(primerNombreValidator);
    segundoNombreController.addListener(segundoNombreValidator);
    primerApellidoController.addListener(primerApellidoValidator);
    segundoApellidoController.addListener(segundoApellidoValidator);
    telefonoController.addListener(telefonoValidator);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: colorBackground,
        body: SingleChildScrollView(
            child: Container(
          color: colorBackground,
          child: Column(
            children: [
              Stack(
                children: [
                  // Contenedor con texto y fondo
                  barraSuperior_(),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              emailInput(),
              contrasenaInput(),
              contrasenaConfirmacionInput(),
              nombres(),
              apellidos(),
              telefonoInput(),
              //aca debe ir el de confirmar
              const SizedBox(height: 40),
              registroButtom_()
            ],
          ),
        )),
      ),
    );
  }

  SizedBox barraSuperior_() {
    return SizedBox(
      height: 186.0,
      child: Container(
        decoration: const BoxDecoration(
          color:
              colorPrincipal, // Establece el color de fondo del contenedor con el texto
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
        ),
        child: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'CHAZERO', // el texto que quieres mostrar
              style: TextStyle(
                  color: Colors.white, // Establece el color del texto
                  fontSize: 64.0, // Establece el tamaño del texto
                  fontFamily: "Inder",
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }

  Container emailInput() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailController,
        validator: (val) {
          return emailValidator_;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorFondoField,
          labelText: "Correo",
          labelStyle: TextStyle(color: Colors.grey.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Container contrasenaInput() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: contrasenaController,
        validator: (val) {
          return contrasenaValidator_;
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: colorFondoField,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: "Contraseña",
            labelStyle: TextStyle(color: Colors.grey.shade700),
            suffixIcon: const Icon(Icons.password)),
      ),
    );
  }

  Container contrasenaConfirmacionInput() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: contrasenaConfirmacionController,
        validator: (val) {
          return contrasenaConfirmacionValidator_;
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: colorFondoField,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: "Confirmar Contraseña",
            labelStyle: TextStyle(color: Colors.grey.shade700),
            suffixIcon: const Icon(Icons.password)),
      ),
    );
  }

  Row nombres() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) {
                return primerNombreValidator_;
              },
              controller: primerNombreController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorFondoField,
                labelText: "Primer Nombre",
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 30, top: 20),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: segundoNombreController,
              validator: (val) {
                return segundoNombreValidator_;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorFondoField,
                labelText: "Segundo Nombre",
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row apellidos() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: primerApellidoController,
              validator: (val) {
                return primerApellidoValidator_;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorFondoField,
                labelText: "Primer Apellido",
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 30, top: 20),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: segundoApellidoController,
              validator: (val) {
                return segundoApellidoValidator_;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorFondoField,
                labelText: "Segundo Apellido",
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container telefonoInput() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: telefonoController,
        validator: (val) {
          return telefonoValidator_;
        },
        keyboardType: TextInputType.text,
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
    );
  }



  ElevatedButton registroButtom_() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: const Size(340, 55),
          // double.infinity is the width and 30 is the height
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {

            // crea un documento de chazero en FireStore Database
            crearChazero(
                emailController.text,
                contrasenaController.text,
                primerNombreController.text,
                segundoNombreController.text,
                primerApellidoController.text,
                segundoApellidoController.text,
                telefonoController.text);

            // Crea un usuario en Firebase Auth y lo logea automaticamente
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text,
                password: contrasenaController.text);
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text,
                password: contrasenaController.text);

            // comentar este if para no hacer la verificacion
            if (context.mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificacionEmail()));
            }

            // quitar este comentario para poder acceder sin la verificacion
            /*if (context.mounted){
              await goMenu();
            }*/
          }
        },
        child: const Text(
          "Registrarme",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ));
  }

  Future<void> emailValidator() async {
    if (await emailExists(emailController.text)) {
      emailValidator_ = "Este correo ya esta en uso";
      _formKey.currentState!.validate();
    } else if (EmailValidator.validate(emailController.text) == false) {
      emailValidator_ = "Este correo es invalido";
      _formKey.currentState!.validate();
    } else {
      emailValidator_ = null;
    }
  }

  void contrasenaValidator() {
    contrasenaConfirmacionValidator();
    /*
    al menos una mayuscula
    al menos una minuscula
    al menos un digito
    al menos un caracter especial (!@#\$&*~)
    minimo 8 caracteres
    (?=.*?[!@#\$&*~]) carac
     */
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (contrasenaController.text.isEmpty) {
      contrasenaValidator_ = "Por favor ingrese su contrasena";
      _formKey.currentState!.validate();
    } else if (!regex.hasMatch(contrasenaController.text)) {
      contrasenaValidator_ = "Ingrese una contrasena valida";
      _formKey.currentState!.validate();
    } else {
      contrasenaValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void contrasenaConfirmacionValidator() {
    if (contrasenaConfirmacionController.text != contrasenaController.text) {
      contrasenaConfirmacionValidator_ = "Por favor confirme su contrasena";
      _formKey.currentState!.validate();
    } else {
      contrasenaConfirmacionValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void telefonoValidator() {
    if (telefonoController.text.isEmpty) {
      telefonoValidator_ = "Por favor ingrese su numero";
      _formKey.currentState!.validate();

    } else if (telefonoController.text.length != 10) {
      telefonoValidator_ = "Ingrese un numero valido";
      _formKey.currentState!.validate();

    } else {
      telefonoValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void primerNombreValidator() {
    RegExp regExp = RegExp(r"^[a-zA-Z]+$");
    if (primerNombreController.text.isEmpty) {
      primerNombreValidator_ = "Ingrese su nombre";
      _formKey.currentState!.validate();

    } else if (!regExp.hasMatch(primerNombreController.text)) {
      primerNombreValidator_ = "Ingrese un nombre valido";
      _formKey.currentState!.validate();

    } else {
      primerNombreValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void segundoNombreValidator() {
    RegExp regExp = RegExp(r"^[a-zA-Z]+$");
    if (!regExp.hasMatch(primerNombreController.text)) {
      segundoNombreValidator_ = "Ingrese un nombre valido";
      _formKey.currentState!.validate();

    } else {
      segundoNombreValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void primerApellidoValidator() {
    RegExp regExp = RegExp(r"^[a-zA-Z]+$");
    if (primerApellidoController.text.isEmpty) {
      primerApellidoValidator_ = "Ingrese su apellido";
      _formKey.currentState!.validate();

    } else if (!regExp.hasMatch(primerApellidoController.text)) {
      primerApellidoValidator_ = "Ingrese un apellido valido";
      _formKey.currentState!.validate();

    } else {
      primerApellidoValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  void segundoApellidoValidator() {
    RegExp regExp = RegExp(r"^[a-zA-Z]+$");
    if (segundoApellidoController.text.isEmpty) {
      segundoApellidoValidator_ = "Ingrese su apellido";
      _formKey.currentState!.validate();

    } else if (!regExp.hasMatch(segundoApellidoController.text)) {
      segundoApellidoValidator_ = "Ingrese un apellido valido";
      _formKey.currentState!.validate();

    } else {
      segundoApellidoValidator_ = null;
      _formKey.currentState!.validate();

    }
  }

  goMenu() async {
    //Vuelve al inicio y borra lo anterior(login, registro y trabajador) para que no se pueda regresar al registro una vez ingresado,
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MenuChazeroVista(),
      ),
      //Esta funcion es para decidir hasta donde hacer pop, ej: ModalRoute.withName('/'));, como está ahí borra todoo
      (_) => false,
    );
  }
}
