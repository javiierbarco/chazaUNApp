// ignore_for_file: avoid_print

import 'package:chazaunapp/Services/Sprint2/ver_mas_activos_services.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

class VerMasActivos extends StatefulWidget {
  final String uid;
  final String cid;
  final String idHorario;
  const VerMasActivos(this.uid, this.cid, this.idHorario, {super.key});

  @override
  State<VerMasActivos> createState() => _VerMasActivosState();
}

class _VerMasActivosState extends State<VerMasActivos> {
  List<String> horasSemana = [];

  int click = 0;

  @override
  Widget build(BuildContext context) {
    goMenu(cid) {
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, '/menu/chazero/personal',
          arguments: cid);
    }

    String uid = widget.uid;
    String cid = widget.cid;
    String idHorario = widget.idHorario;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal",
          style: TextStyle(
              color: Colors.white, // Establece el color del texto
              fontSize: 30.0, // Establece el tamaño del texto
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
        backgroundColor: colorPrincipal,
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: avatar(uid)),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Text('Nombres:         ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(child: nombre(uid)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Apellidos:         ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(child: apellido(uid)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Teléfono:          ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(child: telefono(uid)),
                ],
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              linea(),
              const SizedBox(
                height: 5,
              ),
              const Center(
                child: Text(
                  'Horario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              linea(),
              const SizedBox(
                height: 10,
              ),
              buildDiasSemana(idHorario),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(colorChazero),
                      ),
                      child: const Text('Volver'),
                    ),
                  ),
                  const SizedBox(
                      width:
                          16), // Agrega un espacio horizontal entre los botones
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("fun");
                        if (idHorario.isNotEmpty) {
                          print("funciona?");
                          await actualizarEstadoRelacionTrabajadores(uid, cid);
                          await buscarHorarioPorIdTrabajador(uid, cid);
                          goMenu(
                            cid,
                          );
                          // Navega a PersonalVista después de eliminar los documentos
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Despedir'),
                    ),
                  ),
                ],
              ),
            ])),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Inicio'), //Icono home
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Ajustes')
        ],
        backgroundColor: Colors.white,
        selectedItemColor: colorPrincipal,
        unselectedItemColor: const Color(0xff909090),
        unselectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        selectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        iconSize: 34,
      ),
    );
  }
}

Widget avatar(String uid) {
  return FutureBuilder<String?>(
    future: getFotoUrlFromFirestore(
        uid), // Reemplaza 'ID_DEL_USUARIO' con el ID real
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se obtiene la URL de la foto desde Firebase
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Muestra un mensaje de error si ocurre un error al obtener la URL de la foto
        print(
            'Error al obtener la URL de la foto desde Firebase: ${snapshot.error}');
        return const Text('Error al obtener la foto');
      } else {
        // Obtiene la URL de la foto desde Firebase
        final fotoUrl = snapshot.data;
        print('URL de la foto recibida desde Firebase: $fotoUrl');
        return SizedBox(
          width: 150,
          height: 150,
          child: CircleAvatar(
            backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
          ),
        );
      }
    },
  );
}

Widget linea() {
  return const Divider(
    color: Colors.grey,
    height:
        20, // Ajusta el espacio vertical entre la línea y los campos de texto
    thickness: 1, // Ajusta el grosor de la línea
    indent: 16, // Ajusta la distancia horizontal desde el borde izquierdo
    endIndent: 16, // Ajusta la distancia horizontal desde el borde derecho
  );
}

Widget nombre(String uid) {
  return FutureBuilder<String>(
    future: getNombreFromFirestore(
        uid), // Reemplaza 'ID_DEL_USUARIO' con el ID real
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se obtiene el nombre desde Firebase
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Muestra un mensaje de error si ocurre un error al obtener el nombre
        return const Text('Error al obtener el nombre');
      } else {
        // Muestra el nombre obtenido desde Firebase
        return Text(
          snapshot.data ?? 'Nombre no encontrado',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: "Inder",
            fontWeight: FontWeight.normal,
          ),
        );
      }
    },
  );
}

Widget apellido(String uid) {
  return FutureBuilder<String>(
    future: getApellidosFromFirestore(
        uid), // Reemplaza 'ID_DEL_USUARIO' con el ID real
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se obtienen los apellidos desde Firebase
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Muestra un mensaje de error si ocurre un error al obtener los apellidos
        print(
            'Error al obtener los apellidos desde Firebase: ${snapshot.error}');
        return const Text('Error al obtener los apellidos');
      } else {
        // Muestra los apellidos obtenidos desde Firebase
        final apellidos = snapshot.data ?? 'Apellidos no encontrados';
        print('Apellidos recibidos desde Firebase: $apellidos');
        return Text(
          apellidos,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: "Inder",
            fontWeight: FontWeight.normal,
          ),
        );
      }
    },
  );
}

Widget telefono(String uid) {
  return FutureBuilder<String>(
    future: getTelefonoFromFirestore(
        uid), // Reemplaza 'ID_DEL_USUARIO' con el ID real
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se obtiene el teléfono desde Firebase
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Muestra un mensaje de error si ocurre un error al obtener el teléfono
        print('Error al obtener el teléfono desde Firebase: ${snapshot.error}');
        return const Text('Error al obtener el teléfono');
      } else {
        // Muestra el teléfono obtenido desde Firebase
        final telefono = snapshot.data ?? 'Teléfono no encontrado';
        print('Teléfono recibido desde Firebase: $telefono');
        return Text(
          telefono,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: "Inder",
            fontWeight: FontWeight.normal,
          ),
        );
      }
    },
  );
}

Widget buildDiasSemana(String idHorario) {
  return FutureBuilder<List<List<String>>>(
    future: fetchHoras(idHorario),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        print('Error al obtener las horas desde Firebase: ${snapshot.error}');
        return const Text('Error al obtener las horas');
      } else {
        final horasSemana = snapshot.data ?? [];
        print('horasSemana: $horasSemana');
        return buildColumnDiasSemana(horasSemana);
      }
    },
  );
}

Column buildColumnDiasSemana(List<List<String>> horasSemana) {
  List<Widget> columnChildren = [];

  // Lunes
  String diaLunes = 'Lunes:       ';
  List<String> horasLunes = horasSemana[0];
  columnChildren.add(buildDia(diaLunes, horasLunes));
  columnChildren.add(const SizedBox(height: 16));

  // Martes
  String diaMartes = 'Martes:     ';
  List<String> horasMartes = horasSemana[1];
  columnChildren.add(buildDia(diaMartes, horasMartes));
  columnChildren.add(const SizedBox(height: 16));

  // Miércoles
  String diaMiercoles = 'Miércoles:';
  List<String> horasMiercoles = horasSemana[2];
  columnChildren.add(buildDia(diaMiercoles, horasMiercoles));
  columnChildren.add(const SizedBox(height: 16));

  // Jueves
  String diaJueves = 'Jueves:     ';
  List<String> horasJueves = horasSemana[3];
  columnChildren.add(buildDia(diaJueves, horasJueves));
  columnChildren.add(const SizedBox(height: 16));

  // Viernes
  String diaViernes = 'Viernes:    ';
  List<String> horasViernes = horasSemana[4];
  columnChildren.add(buildDia(diaViernes, horasViernes));
  columnChildren.add(const SizedBox(height: 16));

  // Sábado
  String diaSabado = 'Sábado:    ';
  List<String> horasSabado = horasSemana[5];
  columnChildren.add(buildDia(diaSabado, horasSabado));
  columnChildren.add(const SizedBox(height: 16));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: columnChildren,
  );
}

Widget buildDia(String nombreDia, List<String> horas) {
  String palabras = mostrarHorario(horas);
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text(
          nombreDia,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            palabras,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

String mostrarHorario(List<String> lista) {
  String horarios = "";
  int hora = 0;
  bool buscando = false;
  for (String i in lista) {
    if (i == "") {
      continue;
    }
    if (i.length == 3) {
      hora = int.parse(i.substring(0, 1));
    } else {
      hora = int.parse(i.substring(0, 2));
    }
    //buscando significa que hay hora de inicio pero no final
    if (!buscando) {
      //horas tipo xx:30
      if (i.endsWith('30')) {
        if (!lista.contains("${hora + 1}00")) {
          //si no hay mas de un bloque seguido agrega solo ese bloque
          horarios = "$horarios $hora:30-${hora + 1}:00";
        } else {
          //si hay bloques seguidos añade la hora de inicio y busca el final
          horarios = "$horarios $hora:30-";
          buscando = true;
        }
      } else {
        //lo mismo para horas tipo xx:00
        if (!lista.contains("${hora}30")) {
          horarios = "$horarios $hora:00-$hora:30";
        } else {
          horarios = "$horarios $hora:00-";
          buscando = true;
        }
      }
    } else {
      //horas tipo xx:30
      if (i.endsWith('30')) {
        if (!lista.contains("${hora + 1}00")) {
          //si ya no hay mas agrega la hora final y deja de buscar
          horarios = "$horarios${hora + 1}:00";
          buscando = false;
        }
      } else {
        //lo mismo para horas tipo xx:00
        if (!lista.contains("${hora}30")) {
          horarios = "$horarios$hora:30";
          buscando = false;
        }
      }
    }
  }
  return horarios;
}
