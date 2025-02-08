// ignore: file_names
// ignore: file_names
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> crearPostulacion(Map<String, List<int>> horarioPostulacion,
    String idChaza) async {
  bool contratado = false;
  bool rechazado = false;
  DateTime fecha = DateTime.now();
  String? idTrabajador = FirebaseAuth.instance.currentUser?.uid;

  print(idChaza);

  List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
  ];


  List<String> toString = [];

  List<String> vacio = [""];

  Map<String, List<String>> horarioToString = {};



  for (var value in horarioPostulacion.entries){
    toString = value.value.map((element) => element.toString()).toList();
    horarioToString.putIfAbsent(removeDiacritics(value.key), () => toString);
  }

  for (var day in daysOfWeek){
    if(!horarioToString.containsKey(day)){
      horarioToString[day] = vacio;
    }
  }


  final DocumentReference docRef = await db.collection("Horario").add({"Dias": horarioToString, "Tipo": 1});
  
  db.collection("Postulaciones").add({
    "Contratado": contratado,
    "Rechazado": rechazado,
    "IDChaza": idChaza,
    "IDHorario": docRef.id,
    "IDTrabajador": idTrabajador,
    "FechaCreacion": fecha});

}