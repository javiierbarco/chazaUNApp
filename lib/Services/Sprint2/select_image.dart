import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<XFile?> getImage() async{
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage (File image) async {
  //consigue el nombre de la img
  final String nameFile = image.path.split('/').last;
  //direccion a donde va a mandar las imagenes
  Reference ref = storage.ref().child("ImagesAvatars").child(nameFile);
  //lo que va a subir
  final UploadTask uploadTask = ref.putFile(image);
  
//Monitorear que paso y la url
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();

  // ignore: avoid_print
  print(url);
  return url;
}