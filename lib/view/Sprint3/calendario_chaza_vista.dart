import 'dart:math';

import 'package:chazaunapp/Services/Sprint3/horarios_chaza_services.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HorarioChazaVista extends StatefulWidget {
  final String nombreChaza;
  final String idHorario;
  const HorarioChazaVista(
      {required this.nombreChaza, required this.idHorario, super.key});

  @override
  State<HorarioChazaVista> createState() => _HorarioChazaVistaState();
}

class _HorarioChazaVistaState extends State<HorarioChazaVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        barraSuperior_(widget.nombreChaza),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 10, right: 24),
          child: Text(
            'A continuación verás el horario actual de la chaza, evita seleccionar horarios que ya esten ocupados en tu postulación.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.justify,
          ),
        ),
        FutureBuilder(
            future: getHorario(widget.idHorario),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return Expanded(
                    child: FutureBuilder(
                        future: _getDataSource(data!),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            return SfCalendar(
                                viewNavigationMode: ViewNavigationMode.none,
                                view: CalendarView.workWeek,
                                firstDayOfWeek: 1,
                                timeSlotViewSettings:
                                    const TimeSlotViewSettings(
                                        startHour: 8,
                                        endHour: 20,
                                        nonWorkingDays: <int>[DateTime.sunday]),
                                dataSource: MeetingDataSource(snapshot2.data!));
                          } else {
                            return const Text('Cargando...');
                          }
                        }));
              } else {
                return const Text('Cargando...');
              }
            }),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: volverButtom(),
        )
      ],
    ));
  }

  SizedBox barraSuperior_(String nombreChaza) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height * 0.25;
    return SizedBox(
      height: screenHeight,
      child: Container(
        decoration: const BoxDecoration(
          color:
              colorPrincipal, // Establece el color de fondo del contenedor con el texto
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Horarios disponibles', // el texto que quieres mostrar
                  style: TextStyle(
                      color: Colors.white, // Establece el color del texto
                      fontSize: 35.0, // Establece el tamaño del texto
                      fontFamily: "Inder",
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  nombreChaza, // el texto que quieres mostrar
                  style: const TextStyle(
                      color: colorTrabajador, // Establece el color del texto
                      fontSize: 40.0, // Establece el tamaño del texto
                      fontFamily: "Open sans",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Meeting>> _getDataSource(Map<dynamic, dynamic> dias) async {
    List<Meeting> meetings = <Meeting>[];
    DateTime fechaGeneral = DateTime.now();
    int hours2;
    //Aca se recorre el mapa de los horarios de la chaza
    //para ir en orden
    List<String> keys = [
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
    //diaIngles es solo porque flutter/dart/la dependencia trabaja con los dias pero solo si estan en ingles
    Map<String, String> dias2 = {
      'Lunes': 'Monday',
      'Martes': 'Tuesday',
      'Miercoles': 'Wednesday',
      'Jueves': 'Thursday',
      'Viernes': 'Friday',
      'Sabado': 'Saturday',
      'Domingo': 'Sunday',
    };
    for (var key in dias.keys) {
      //key es el dia en el que estamos actualmente
      var horasMap = dias[key];
      //horasMap es el map del dia ejm todo el map del lunes
      bool buscando = false;
      for (String horaKey in keys) {
        //horaKey es el valor dentro del dia ejemplo es 1400 del lunes, solo es 1400
        var valor = horasMap[horaKey];
        // valor es el uid del postulado para esa fecha
        if (valor == '') {
          continue;
        }
        String? diaIngles = '';
        diaIngles = dias2[key];
        var input = '$diaIngles $horaKey';
        List<String> parts = input.split(' ');
        String dayName = parts[0];
        String time = parts[1];
        DateTime now = DateTime.now();
        int daysToAdd = _getDaysToAdd(dayName, now.weekday);
        int minutes;

        //Esta seccion de abajo es solo para dividir bien las horas
        if (time.length == 3) {
          hours2 = int.parse(time.substring(0, 1));
          minutes = int.parse(time.substring(1, 3));
        } else {
          hours2 = int.parse(time.substring(0, 2));
          minutes = int.parse(time.substring(2, 4));
        }

        //Aca se establece la hora de inicio de la reunion es decir el esta semana a las {dias que indicque el map}
        String nombre = await getNombreTrabajador(valor);
        DateTime fecha = DateTime(
            now.year, now.month, now.day + daysToAdd, hours2, minutes, 0);

        //buscando significa que hay hora de inicio pero no sabemos el final
        if (!buscando) {
          //funciona diferente por ser base 60 xd
          if (horaKey.endsWith('30')) {
            if (valor != horasMap["${hours2 + 1}00"]) {
              //si no esta en la siguiente media hora se crea el meeting de solo 1 cuadro
              var color = generarColorRandom();
              meetings.add(Meeting(nombre, fecha,
                  fecha.add(const Duration(minutes: 30)), color, false));
            } else {
              //si esta la hora de inicio se guarda y buscamos la final
              fechaGeneral = fecha;
              buscando = true;
            }
          } else {
            //lo mismo de arriba pero ajustado a horas del tipo xx:00
            if (valor != horasMap["${hours2}30"]) {
              var color = generarColorRandom();
              meetings.add(Meeting(nombre, fecha,
                  fecha.add(const Duration(minutes: 30)), color, false));
            } else {
              fechaGeneral = fecha;
              buscando = true;
            }
          }
        } else {
          //funciona diferente por ser base 60 xd
          if (horaKey.endsWith('30')) {
            if (valor != horasMap["${hours2 + 1}00"]) {
              //si ya no esta en la proxima media hora se guarda la reunion con la hora inicial y se reinicia el bool
              //no se necesita reiniciar fechaGeneral porque primero tiene que pasar por la parte de arriba y cambiara automaticamente
              var color = generarColorRandom();
              meetings.add(Meeting(nombre, fechaGeneral,
                  fecha.add(const Duration(minutes: 30)), color, false));
              buscando = false;
            } //no hay else porque sin fecha de finalización no se puede hacer nada
          } else {
            //lo mismo pero para horas de tipo xx:00
            if (valor != horasMap["${hours2}30"]) {
              var color = generarColorRandom();
              meetings.add(Meeting(nombre, fechaGeneral,
                  fecha.add(const Duration(minutes: 30)), color, false));
              buscando = false;
            }
          }
        }
      }
    }
    return meetings;
  }

  Color generarColorRandom() {
    Random random = Random();
    int r = random.nextInt(
        256); // Genera un valor de 0 a 255 para el componente de rojo (red)
    int g = random.nextInt(
        256); // Genera un valor de 0 a 255 para el componente de verde (green)
    int b = random.nextInt(
        256); // Genera un valor de 0 a 255 para el componente de azul (blue)
    return Color.fromARGB(
        255, r, g, b); // Devuelve un color con los valores generados
  }

  ElevatedButton volverButtom() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrincipal,
          minimumSize: const Size(
              340, 55), // double.infinity is the width and 30 is the height
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          "Volver",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ));
  }
}

int _getDaysToAdd(String dayName, int currentDayOfWeek) {
  int targetDayOfWeek = _getDayOfWeekNumber(dayName.toLowerCase());
  int daysToAdd = targetDayOfWeek - currentDayOfWeek;
  return daysToAdd;
}

int _getDayOfWeekNumber(String dayName) {
  switch (dayName) {
    case 'monday':
      return DateTime.monday;
    case 'tuesday':
      return DateTime.tuesday;
    case 'wednesday':
      return DateTime.wednesday;
    case 'thursday':
      return DateTime.thursday;
    case 'friday':
      return DateTime.friday;
    case 'saturday':
      return DateTime.saturday;
    case 'sunday':
      return DateTime.sunday;
    default:
      return 0;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
