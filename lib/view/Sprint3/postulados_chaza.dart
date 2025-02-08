// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, avoid_print

import 'package:chazaunapp/Services/Sprint3/crearPostulacion.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

import '../menu_inicial_vista.dart';

class PostuladosChaza extends StatefulWidget {
  final String idChaza;
  const PostuladosChaza({required this.idChaza, super.key});

  @override
  _PostuladosChazaState createState() => _PostuladosChazaState();
}

class _PostuladosChazaState extends State<PostuladosChaza> {
  TextEditingController _textFieldController = TextEditingController();
  List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];
  Map<String, List<String>> timeSlots = {};
  Map<String, List<int>> horarioPostulacion = {};
  String chaza = '';

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    chaza = ModalRoute.of(context)?.settings.arguments as String;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Seleccionar horario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: colorPrincipal,
          toolbarHeight: screenHeight * 0.165,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.only(bottom: 60),
            icon: const Icon(Icons.arrow_back),
            iconSize: 40,
          ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    String day = daysOfWeek[index];
                    List<String> slots = timeSlots[day] ?? [];

                    return ExpansionTile(
                      title: Text
                        (day,
                        style: const TextStyle(fontSize: 24),
                      ),
                      iconColor: colorTrabajador,
                      textColor: colorTrabajador,
                      children: [
                        if (slots.isEmpty)
                          ListTile(
                            title: Text('No tienes franjas horarias el $day',
                            style: const TextStyle(fontSize: 16),),
                          ),
                        ...slots.map((slot) => ListTile(
                              title: Text(slot),
                            )),
                        const SizedBox(height: 2.5),
                        Padding(
                          padding: const EdgeInsets.only(right: 170.0),
                          child: TextButton(
                            onPressed: () => _showAddSlotDialog(day),
                            child: const Text(
                              '+ Añadir franja nueva',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorTrabajador
                              ),
                            ),

                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  crearPostulacion(horarioPostulacion, chaza);
                  mostrarDialogo();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  minimumSize: const Size(
                      360, 50), // double.infinity is the width and 30 is the height
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                ),
                child: const Text('Terminar postulación', style: TextStyle(fontSize: 18, fontFamily: "Inder"),),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mostrarDialogo() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Postulación completada",
            style: TextStyle(fontSize: 35, color: colorPrincipal),
          ),
          content: const Text(
              "Te notificaremos si el chazero te acepta o el chazero se contactara directamente contigo",
              style: TextStyle(fontSize: 25)
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrincipal,
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text("Ok",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MenuInicialVistaView(),
                    ),
                        (_) => false,
                  );
                },
              ),
            ),
          ],
        );
      });
}

  Future<void> _showAddSlotDialog(String day) async {
    String startTime = '8:00';
    String endTime = '8:30';
    String selectedHour = '8:00';

    final List<String> hoursList = [
      '8:00',
      '8:30',
      '9:00',
      '9:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '12:30',
      '13:00',
      '13:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
      '17:00',
      '17:30',
      '18:00',
      '18:30',
      '19:00',
      '19:30',
      '20:00',
    ];


    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir franja horaria para el $day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Desde:'),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child:
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton<String>(
                          value: selectedHour,
                          hint: const Text('Seleccionar hora'),
                          onChanged: (String? value) {
                            setState(() {
                              selectedHour = value!;
                              startTime = selectedHour;
                            });
                          },
                          items: hoursList.map((String hour) {
                            return DropdownMenuItem<String>(
                              value: hour,
                              child: Text(hour),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Text('Hasta:'),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child:
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton<String>(
                          value: selectedHour,
                          hint: const Text('Seleccionar hora'),
                          onChanged: (String? value) {
                            setState(() {
                              selectedHour = value!;
                              endTime = selectedHour;

                            });
                          },
                          items: hoursList.map((String hour) {
                            return DropdownMenuItem<String>(
                              value: hour,
                              child: Text(hour),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: colorPrincipal,
                    fontFamily: "Inder"
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final slot = 'Desde $startTime hasta $endTime';
                setState(() {
                  timeSlots.putIfAbsent(day, () => []).add(slot);
                  convertirHorarioALista(startTime, endTime, day);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrincipal,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              ),
              child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Inder"
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void convertirHorarioALista(String horaInicio, String horaFin, String dia){
    
    List<int> horario = [];

    //List horaInicioParsed = parseHour(horaInicio);
   // List horaFinParsed = parseHour(horaFin);

    String horaInicioConvertida = horaInicio.replaceAll(":", "");
    String horaFinConvertida = horaFin.replaceAll(":", "");


    print (horaInicioConvertida);
    print (horaFinConvertida);
    //int soloHoraInicio = horaInicioParsed[0];
    //int soloMinutosInicio = horaInicioParsed[1];

    //int soloHoraFin = horaFinParsed[0];
    //int soloMinutosFin = horaFinParsed[1];

    List<String> horas = [
      "800",
      "830",
      "900",
      "930",
      "1000",
      "1030",
      "1100",
      "1130",
      "1200",
      "1230",
      "1300",
      "1330",
      "1400",
      "1430",
      "1500",
      "1530",
      "1600",
      "1630",
      "1700",
      "1730",
      "1800",
      "1830",
      "1900",
      "1930",
    ];

    for (var hora in horas){
      if (hora == horaInicioConvertida){
        horario.add(int.parse(horaInicioConvertida));
      }
      else if (hora != horaFinConvertida &&
          int.parse(horaInicioConvertida) <= int.parse(hora) &&
          int.parse(hora) <= int.parse(horaFinConvertida)
      ){
        horario.add(int.parse(hora));
      }
    }
    List<int>? temp = [...?horarioPostulacion[dia], ...horario];
    temp.sort();
    horarioPostulacion[dia] = temp;

  }

  List<int> parseHour(String hora){
    List<int> parsedHour = [];

    if (hora.length == 3) {
      parsedHour.add(int.parse(hora.substring(0, 1)));
      parsedHour.add(int.parse(hora.substring(1, 3)));
    } else {
      parsedHour.add(int.parse(hora.substring(0, 2)));
      parsedHour.add(int.parse(hora.substring(2, 4)));
    }

    return parsedHour;
  }
}
