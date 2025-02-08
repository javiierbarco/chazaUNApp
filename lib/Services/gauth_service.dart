import 'dart:convert';
import 'package:chazaunapp/Components/error_prompt.dart';
import 'package:chazaunapp/view/inicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GAuthService {
  // Ingresar con Google (registro o login)
  Future<void> ingresarGoogle(bool registro, String telefono, BuildContext context) async {
    try {
      // Iniciar sesión con Google solo para usuarios con dominio "unal.edu.co"
      final gUser = await GoogleSignIn(hostedDomain: "unal.edu.co").signIn();
      if (gUser == null) {
        errorPrompt(context, "Inicio de sesión cancelado", "No se completó el proceso.");
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      if (registro) {
        await FirebaseAuth.instance.signInWithCredential(credential);
        await registrarTrabajador(gUser, gAuth, telefono, context);
      } else {
        await iniciarSesionTrabajador(gUser, credential, context);
      }
    } catch (e) {
      errorPrompt(context, "Error en autenticación", "Hubo un error: $e");
    }
  }

  // Registro de nuevo trabajador en Firestore
  Future<void> registrarTrabajador(GoogleSignInAccount gUser,
      GoogleSignInAuthentication gAuth, String telefono, BuildContext context) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference coleccion = db.collection('Trabajador');
      DateTime fechaHoy = DateTime.now();
      String email = gUser.email;

      // Verificar si el usuario está autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        errorPrompt(context, "Error", "Usuario no autenticado en Firebase.");
        return;
      }

      // Obtener UID del usuario autenticado
      String uid = user.uid;

      // Obtener datos del token de Google
      Map<String, dynamic>? idMap = parseJwt(gAuth.idToken ?? "");
      if (idMap == null) {
        errorPrompt(context, "Error", "No se pudieron extraer los datos del usuario.");
        return;
      }

      final String firstName = idMap["given_name"] ?? "Desconocido";
      final String lastName = idMap["family_name"] ?? "Desconocido";
      final String? foto = gUser.photoUrl;

      // Verificar si el trabajador ya existe
      DocumentSnapshot trabajadorDoc = await coleccion.doc(uid).get();

      if (!trabajadorDoc.exists) {
        final data = {
          "correo": email,
          "nombres": firstName,
          "apellidos": lastName,
          "estado": true,
          "telefono": telefono,
          "foto": foto,
          "FechaCreacion": fechaHoy,
          "FechaUltimaActualizacion": fechaHoy
        };
        await coleccion.doc(uid).set(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registro exitoso"),
          backgroundColor: Colors.green,
        ));
      } else {
        errorPrompt(context, "Error", "El trabajador ya está registrado.");
      }
    } catch (e) {
      errorPrompt(context, "Error en el registro", "Hubo un problema: $e");
    }
  }

  // Iniciar sesión de un trabajador ya registrado
  Future<void> iniciarSesionTrabajador(GoogleSignInAccount gUser, AuthCredential credential, BuildContext context) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference coleccion = db.collection('Trabajador');
      String email = gUser.email;

      // Verificar si el usuario existe en Firestore
      QuerySnapshot trabajadorQuery = await coleccion.where("correo", isEqualTo: email).get();

      if (trabajadorQuery.docs.isNotEmpty) {
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Inicio de sesión exitoso"),
          backgroundColor: Colors.green,
        ));
      } else {
        errorPrompt(context, 'No se encontró el usuario', 'Por favor regístrese primero.');
      }
    } catch (e) {
      errorPrompt(context, "Error al iniciar sesión", "Hubo un problema: $e");
    }
  }

  // Cerrar sesión
  Future<void> salirDeGoogle(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const PaginaInicio()),
      (_) => false,
    );
  }

  // Obtener nombre de usuario
  String? getNombreCompleto() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  // Obtener email registrado
  String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  // Extraer información del JWT (para obtener nombres y apellidos)
  static Map<String, dynamic>? parseJwt(String token) {
    final List<String> parts = token.split('.');
    if (parts.length != 3) return null;
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    return payloadMap is Map<String, dynamic> ? payloadMap : null;
  }
}
