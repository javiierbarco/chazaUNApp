import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getChazas() async {
  List chazas = [];
  CollectionReference collectionReferenceChazas = db.collection('Chaza');
  QuerySnapshot querychazas = await collectionReferenceChazas.get();
  for (var chaza in querychazas.docs) {
    Map<String, dynamic> chazaData =
        chaza.data() as Map<String, dynamic>; // Datos del documento
    chazaData['id'] = chaza.id; // Agregar el ID del documento a los datos

    chazas.add(chazaData);
  }
  Future.delayed(const Duration(milliseconds: 800));

  return chazas;
}
