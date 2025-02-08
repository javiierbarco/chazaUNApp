// ignore_for_file: non_constant_identifier_names

import 'package:chazaunapp/view/Sprint3/calendario_chaza_vista.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

import '../../Services/Sprint3/infoChaza_services.dart';

class InfoChazaVista extends StatefulWidget {
  const InfoChazaVista({super.key});

  @override
  State<InfoChazaVista> createState() => _InfoChazaVistaState();
}

class _InfoChazaVistaState extends State<InfoChazaVista> {
  String chaza = "";

  @override
  Widget build(BuildContext context) {
    chaza = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: colorBackground,
      body: Column(children: [
        barraConfiguracion_(),
        const SizedBox(
          height: 15,
        ),
        FutureBuilder(
            future: getChaza(chaza),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return informacion_(
                  snapshot.data?['nombre'],
                  snapshot.data?['descripcion'],
                  snapshot.data?['paga'],
                  snapshot.data?['ubicacion'],
                  snapshot.data?['puntuacion'],
                  snapshot.data?['imagen'],
                  snapshot.data?['horario'],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }))
      ]),
    );
  }

  Stack barraConfiguracion_() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Stack(children: [
      Container(
        color: colorPrincipal,
        height: screenHeight * 0.11,
        width: screenWidth,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(children: [
            volverBoton_(),
            const Text(
              "Informacion de la chaza",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )
          ]),
        ),
      ),
    ]);
  }

  Padding informacion_(String nombre, String descripcion, String pago,
      String ubicacion, String puntuacion, String imagen, String idHorario) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Padding(
      padding: const  EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            // Contenedor para que la imagen tenga borde redondeado
            borderRadius: BorderRadius.circular(30.0),
            child: Image(
              image: NetworkImage(imagen),
              //Parametro del enlace de la imagen de la chaza
              height: screenHeight * 0.38,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.015,
          ),
          nombreyPago(nombre, pago),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          rowUbicacion_(ubicacion),
          const  Divider(thickness: 1.3),
          rowPuntuacion_(puntuacion),
          const  Divider(thickness: 1.3),
          const  SizedBox(
            height: 1.8,
          ),
          _descripcion(descripcion),
          SizedBox(height: screenHeight * 0.02),
          horarioBoton_(nombre, idHorario),
          SizedBox(height: screenHeight * 0.015),
          postularseBoton_()
        ],
      ),
    );
  }

  Row nombreyPago(String nombre, String pago) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Text(
            nombre,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 31.0,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal,
            ),
            maxLines: null, // Permite un número ilimitado de líneas
            overflow: TextOverflow.visible
          ),
        ),
        Row(
          children: [
            Text(
              pago,
              style: const TextStyle(
                color: colorTrabajador,
                fontSize: 32.0,
                fontFamily: "Inder",
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.013,
            ),
            const Text(
              "/Hora",
              style: TextStyle(
                  color: Color(0xff444444),
                  fontSize: 18.0,
                  fontFamily: "Inder",
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ],
    );
  }


  Row rowUbicacion_(String ubicacion) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    //row para juntar el icono y el texto
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.02),
        const Icon(Icons.location_on_rounded,
            color: Color(0xff919191), size: 17.0),
        Text(
          ubicacion,
          style: const TextStyle(
              color: Color(0xff919191),
              fontSize: 15.5,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Row rowPuntuacion_(String puntuacion) {
    //row para juntar el icono y el texto
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.02),
        const Icon(
          Icons.star,
          color: colorChazero,
          size: 26.0,
        ),
        Text(
          puntuacion,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 19.0,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Column _descripcion(String descripcion) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: screenWidth * 0.02),
            const Text(
              'Descripcion',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontFamily: "Inder",
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
        Text(
          descripcion,
          maxLines: null,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontFamily: "Inder"),
        )
      ],
    );
  }

  ElevatedButton horarioBoton_(String nombre, String idHorario) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
        onPressed: irHorario(
          context,
          nombre,
          idHorario,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrincipal,
          minimumSize: Size(screenWidth * 0.85, screenHeight * 0.063),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: const Text(
          "Ver horario de la chaza",
          style:
              TextStyle(color: Colors.white, fontSize: 22, fontFamily: "Inder"),
        ));
  }

  ElevatedButton postularseBoton_() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
        onPressed: _Postularse(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrincipal,
          minimumSize: Size(screenWidth * 0.85, screenHeight * 0.064),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: const Text(
          "Aplicar al puesto",
          style:
              TextStyle(color: Colors.white, fontSize: 22, fontFamily: "Inder"),
        ));
  }

  TextButton volverBoton_() {
    return TextButton(
      onPressed: volverInicio_(),
      child: const Icon(
        Icons.arrow_back,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Function() irHorario(BuildContext context, String nombre, String idHorario) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HorarioChazaVista(
                  nombreChaza: nombre, idHorario: idHorario)));
    };
  }

  Function() _Postularse(BuildContext context){
    return () {
      Navigator.pushNamed(context, '/menu/trabajador/chaza/postulacion', arguments: chaza);
    };
  }

  volverInicio_() {
    return () {
      //No modificar, esto directamente manda a la anterior ventana
      Navigator.pop(
        context,
      );
    };
  }
}
