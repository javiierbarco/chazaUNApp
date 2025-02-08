import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getHorario(String idHorario) async {
  var horario = (await FirebaseFirestore.instance
          .collection('Horario')
          .doc(idHorario)
          .get())
      .get('Dias') as Map<String, dynamic>;
  return horario;
}

FirebaseFirestore db = FirebaseFirestore.instance;

Future<String> getNombreTrabajador(String? uid) async {
  List<dynamic> info = [];
  try {
    // Obtén una referencia a la colección y documento específicos
    CollectionReference collectionRef = db.collection('Trabajador');
    DocumentSnapshot docSnapshot = await collectionRef.doc(uid).get();

    if (docSnapshot.exists) {
      info.add(docSnapshot.get('nombres'));
      info.add(docSnapshot.get('apellidos'));
    } else {}
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener el documento: $e');
  }
  String nombre = info[0];
  return nombre;
}
