// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getChaza(String documentoId) async {
  DocumentSnapshot documentoSnapshot = await FirebaseFirestore.instance
      .collection('Chaza')
      .doc(documentoId)
      .get();

  if (documentoSnapshot.exists) {
    Map<String, dynamic> datos = documentoSnapshot.data() as Map<String, dynamic>;
    datos['id'] = documentoSnapshot.id;
    return datos;
  } else {
    return null; // El documento no existe
  }
}
