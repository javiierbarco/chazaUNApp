import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getChazas() async {
  List chazas = [];
  CollectionReference collectionReferenceChazas = db.collection('Chaza');
  QuerySnapshot querychazas = await collectionReferenceChazas.get();
  for (var id in querychazas.docs) {
    chazas.add(id.data());
  }
  Future.delayed(const Duration(milliseconds: 800));

  return chazas;
}
