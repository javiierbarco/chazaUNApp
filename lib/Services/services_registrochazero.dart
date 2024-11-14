import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionReferenceEmail = db.collection('Chazero');

Future<bool> emailExists(String email) async {
  //nos trae todos los documentos
  //recorremos los documentos
  // ignore: avoid_function_literals_in_foreach_calls

  final emailsExisting = await collectionReferenceEmail.where("correo", isEqualTo: email).get().then(
          (querySnapshot){
        if (querySnapshot.docs.isNotEmpty){
          return true;
        }
        return false;
      }
  );

  if (emailsExisting) {
    return true;
  } else {
    return false;
  }
}

void crearChazero(String correo, String contrasena, String primerNombre,
  String segundoNombre, String primerApellido, String segundoApellido,
    String numero){

  final data = {"correo": correo, "contraseña": contrasena,
    "primer_nombre": primerNombre, "segundo_nombre": segundoNombre,
    "primer_apellido": primerApellido, "segundo_apellido": segundoApellido,
    "numero": numero};

  collectionReferenceEmail.add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}"));
}