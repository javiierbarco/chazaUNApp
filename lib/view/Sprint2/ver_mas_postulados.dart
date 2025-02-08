import 'package:chazaunapp/Components/error_prompt.dart';
import 'package:chazaunapp/Services/Sprint2/ver_mas_postulados_services.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

class VerMasPostulados extends StatelessWidget {
  final String uid;
  final String idHorario; //chaza id
  final String cid;
  const VerMasPostulados(this.uid, this.idHorario, this.cid, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (AppBar(
          title: const Text(
            "Personal",
            style: TextStyle(
                color: Colors.white, // Establece el color del texto
                fontSize: 30.0, // Establece el tamaño del texto
                fontFamily: "Inder",
                fontWeight: FontWeight.normal),
          ),
          backgroundColor: colorPrincipal,
        )),
        body: FutureBuilder(
            future: getinfo(uid, idHorario),
            builder: ((context, snapshot) {
              goMenu(String texto) {
                mostrarMensaje(context, texto);
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/menu/chazero/personal',
                    arguments: cid);
              }

              if (snapshot.hasData) {
                return (SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Center(
                            child: CircleAvatar(
                                backgroundColor: colorFondoField,
                                radius: 75,
                                backgroundImage:
                                    NetworkImage(snapshot.data?['foto'])),
                          ),
                          const Spacer(),
                          const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 20,
                            endIndent: 0,
                            color: colorFondoField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Nombres:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 100.0),
                                Expanded(
                                    child: Text(snapshot.data?['nombres'])),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Apellidos:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 100.0),
                                Expanded(
                                    child: Text(snapshot.data?['apellidos'])),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  ' Teléfono:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 103.0),
                                Expanded(
                                    child: Text(snapshot.data?['telefono'])),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 20,
                            thickness: 2,
                            indent: 20,
                            endIndent: 0,
                            color: colorFondoField,
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Horarios disponibles:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Lunes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 107.0),
                              Expanded(
                                  child: Text(
                                      mostrarHorario(snapshot.data!['Lunes']))),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Martes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 100.0),
                              Expanded(
                                  child: Text(mostrarHorario(
                                      snapshot.data!['Martes']))),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Miercoles',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 82.0),
                              Expanded(
                                  child: Text(mostrarHorario(
                                      snapshot.data!['Miercoles']))),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Jueves',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 101.0),
                              Expanded(
                                  child: Text(mostrarHorario(
                                      snapshot.data!['Jueves']))),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Viernes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 98.0),
                              Expanded(
                                  child: Text(mostrarHorario(
                                      snapshot.data!['Viernes']))),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  'Sábado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 98.0),
                              Expanded(
                                  child: Text(mostrarHorario(
                                      snapshot.data!['Sabado']))),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await contratar(uid, idHorario);
                                    // Lógica cuando se presiona el botón "Contratar"
                                    String nombre = snapshot.data?['nombres'];
                                    String mensajeboton =
                                        ' ha sido contratad@, Talvez debas reiniciar la chaza para ver los cambios';
                                    String textorechazado =
                                        nombre + mensajeboton;
                                    goMenu(textorechazado);
                                  } on Exception catch (_) {
                                    rechazar(uid, idHorario,
                                        contratacion: true, success: false);
                                    errorPrompt(
                                        context,
                                        'Conflictos en el horario',
                                        'Resuelvalos para poder contratar');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Contratar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Lógica cuando se presiona el botón "Rechazar"
                                  await rechazar(uid, idHorario);
                                  String nombre = snapshot.data?['nombres'];
                                  String mensajeboton = ' ha sido rechazad@';
                                  String textoaceptado = nombre + mensajeboton;
                                  goMenu(textoaceptado);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Rechazar'),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ])));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })));
  }

  void mostrarMensaje(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  String mostrarHorario(List<dynamic> lista) {
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
}
