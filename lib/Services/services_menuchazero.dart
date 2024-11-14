import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getChazasporChazero(String idChazero) async {
  List chazas = [];
  CollectionReference collectionReferenceChazas = db.collection('Chaza');
  QuerySnapshot querychazas = await collectionReferenceChazas
      .where('ID_Chazero', isEqualTo: idChazero)
      .get();
  for (var id in querychazas.docs) {
    chazas.add(id.data());
  }
  Future.delayed(const Duration(milliseconds: 800));

  return chazas;
}
