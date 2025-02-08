import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<dynamic>> traerInfoGeneralTrabajo(String? uid) async {
  List<dynamic> info = [];
  try {
    // Obtén una referencia a la colección y documento específicos
    CollectionReference collectionRef = db.collection('Trabajador');
    DocumentSnapshot docSnapshot = await collectionRef.doc(uid).get();

    if (docSnapshot.exists) {
      // Si el documento existe, agrega los campos a la lista
      info.add(docSnapshot.get('apellidos'));
      info.add(docSnapshot.get('correo'));
      info.add(docSnapshot.get('foto'));
      info.add(docSnapshot.get('nombres'));
      info.add(docSnapshot.get('telefono'));
      info.add(docSnapshot.get('FechaCreacion'));
      info.add(docSnapshot.get('FechaUltimaActualizacion'));
    } else {}
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener el documento: $e');
  }
  return info;
}

Future<void> actualizarDatosTrabajador(
    String? uid, apellidos, correoActual, foto, nombres, telefono, Timestamp fechaCrea) async {
    DateTime fechaActual = DateTime.now();
    Timestamp fechaHoy = Timestamp.fromDate(fechaActual);
  await db.collection('Trabajador').doc(uid).set({
    'apellidos': apellidos,
    'correo': correoActual,
    'foto': foto,
    'nombres': nombres,
    'telefono': telefono,
    'FechaCreacion':fechaCrea,
    'FechaUltimaActualizacion': fechaHoy
  });
}
