import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

enviarDatos(String pregunta) async {
  final user = FirebaseAuth.instance.currentUser?.displayName;
  final Email email = Email(
    body: pregunta,
    subject: 'pregunta de $user',
    recipients: ['brrodriguezd@unal.edu.co'],
    attachmentPaths: [],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}
