import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionReferenceTrabajador = db.collection("Trabajador");

// copia exacta del menu de candidatos lol
Future<List> getPersonalActivoPorChaza(String idChaza) async {
  List trabajadores = []; //Lista con los IDS de trabajador de cada postulacion
  List horarios = []; //IDs de horarios por postulacion
  List datosTrabajadorHorario = []; //Datos de trabajador y horario
  List resultadosTotales = []; //La matriz 3D que devuelve la consulta
  CollectionReference collectionReferencePostulaciones =
      db.collection('RelacionTrabajadores');
  QuerySnapshot querypostulaciones = await collectionReferencePostulaciones
      .where('IDChaza', isEqualTo: idChaza)
      .where('Estado', isEqualTo: true)
      .get();
  for (var doc in querypostulaciones.docs) {
    dynamic trabajador = doc.get('IDTrabajador');
    trabajadores
        .add(trabajador); //Mete en una lista los ids de todos los postulados
    dynamic horario = doc.get('IDHorario');
    horarios.add(horario); //Mete en una lista los ids de todos los horarios
  }
  for (int i = 0; i < trabajadores.length; i++) {
    DocumentSnapshot<Map<String, dynamic>> infotrabajador = await db
        .collection('Trabajador')
        .doc(trabajadores[i].toString().trim())
        .get();
    var data = infotrabajador.data();
    data?.addAll({'idHorario': horarios[i]});
    datosTrabajadorHorario.add(data); // Mete en la lista los datos de cada id
    DocumentSnapshot<Map<String, dynamic>> infohorario =
        await db.collection('Horario').doc(horarios[i].toString().trim()).get();
    datosTrabajadorHorario
        .add(trabajadores[i].toString()); // añade el uid a la lista

    datosTrabajadorHorario.add(infohorario
        .data()); //Mete en la misma lista los detalles de cada horario
    resultadosTotales.add(
        datosTrabajadorHorario); //Mete pareja trabajador-horario en la lista final
    datosTrabajadorHorario = []; //Reinicia la lista
  }
  Future.delayed(const Duration(milliseconds: 800));
  return resultadosTotales;
}

List<bool> trabajaDiasActivo(List todos) {
  List<bool> trabaja = [];
  trabaja.add(todos[2]['Dias']['Lunes'][0] != "");
  trabaja.add(todos[2]['Dias']['Martes'][0] != "");
  trabaja.add(todos[2]['Dias']['Miercoles'][0] != "");
  trabaja.add(todos[2]['Dias']['Jueves'][0] != "");
  trabaja.add(todos[2]['Dias']['Viernes'][0] != "");
  trabaja.add(todos[2]['Dias']['Sabado'][0] != "");
  return trabaja;
}
