import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionReferenceEmail = db.collection('Chazero');

Future<bool> emailExists(String email) async {
  final emailsExisting = await collectionReferenceEmail
      .where("correo", isEqualTo: email)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  });

  if (emailsExisting) {
    return true;
  } else {
    return false;
  }
}

void crearChazero(
    String correo,
    String contrasena,
    String primerNombre,
    String segundoNombre,
    String primerApellido,
    String segundoApellido,
    String numero,
    String? uid) {
  DateTime fecha =DateTime.now();
  final data = {
    "correo": correo,
    "contraseña": contrasena,
    "primer_nombre": primerNombre,
    "segundo_nombre": segundoNombre,
    "primer_apellido": primerApellido,
    "segundo_apellido": segundoApellido,
    "numero": numero,
    "FechaCreacion":fecha,
    "FechaUltimaActualizacion":fecha
  };

  // añade el chazero con el uid de fireauth a firestore
  collectionReferenceEmail.doc(uid).set(data);
}
