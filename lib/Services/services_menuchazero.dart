import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getChazasporChazero(String idChazero) async {
  List chazas = [];
  CollectionReference collectionReferenceChazas = db.collection('Chaza');
  QuerySnapshot querychazas = await collectionReferenceChazas
      .where('ID_Chazero', isEqualTo: idChazero)
      .get();
  for (var chaza in querychazas.docs) {
    Map<String, dynamic> chazaData = chaza.data() as Map<String, dynamic>; // Datos del documento
    chazaData['id'] = chaza.id; // Agregar el ID del documento a los datos

    chazas.add(chazaData); // Agregar los datos a la lista 'chazas'
  }
  Future.delayed(const Duration(milliseconds: 800));

  return chazas;
}