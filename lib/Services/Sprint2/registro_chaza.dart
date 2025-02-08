import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> registrarChaza(String? uid, String descripcion, imagen, nombre,
    paga, puntuacion, ubicacion, int tipo) async {
  String horario = await crearDocumentoYObtenerNumero();
  DateTime fecha =DateTime.now();
  await db.collection('Chaza').add({
    'ID_Chazero': uid,
    'descripcion': descripcion,
    'horario': horario,
    'imagen': imagen,
    'nombre': nombre,
    'paga': paga,
    'puntuacion': puntuacion,
    'tipo': tipo,
    'ubicacion': ubicacion,
    'FechaCreacion':fecha
  });
}
Future<String> crearDocumentoYObtenerNumero() async {
  // Crear un nuevo documento en la colección
  var horas = {
  '800': '',
  '830': '',
  '900': '',
  '930': '',
    '1000': '',
    '1030': '',
    '1100': '',
    '1130': '',
    '1200': '',
    '1230': '',
    '1300': '',
    '1330': '',
    '1400': '',
    '1430': '',
    '1500': '',
    '1530': '',
    '1600': '',
    '1630': '',
    '1700': '',
    '1730': '',
    '1800': '',
    '1830': '',
    '1900': '',
    '1930': ''
  };

  // ignore: non_constant_identifier_names
  var Dias = {
    'Lunes': horas,
    'Martes': horas,
    'Miercoles': horas,
    'Jueves': horas,
    'Viernes': horas,
    'Sabado': horas,
  };



  final DocumentReference docRef = await db.collection('Horario').add({'Dias':Dias, 'Tipo':0});

  // Obtener el número de documento asignado
  final String numeroDocumento = docRef.id;

  return numeroDocumento;
}


final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImageChaza(File image) async {
  //consigue el nombre de la img
  final String nameFile = image.path.split('/').last;
  //direccion a donde va a mandar las imagenes
  Reference ref = storage.ref().child("ImagesChazas").child(nameFile);
  //lo que va a subir
  final UploadTask uploadTask = ref.putFile(image);

//Monitorear que paso y la url
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();

  // ignore: avoid_print
  print(url);
  return url;
}
