import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getEmail() async{
  List email = [];
  CollectionReference collectionReferenceEmail = db.collection('Chazero');
  //nos trae todos los documentos
  QuerySnapshot querySnapshotEmail = await collectionReferenceEmail.get();

  //recorremos los documentos
  // ignore: avoid_function_literals_in_foreach_calls
  querySnapshotEmail.docs.forEach((doc) {
    email.add(doc.data());
    
  });
  return email; 

}

