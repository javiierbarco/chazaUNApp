import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getinfo(uid, cid) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference coleccionTrabajador = db.collection('Trabajador');
  CollectionReference coleccionHorario = db.collection('Horario');
  //Para encontrar el horario
  DocumentSnapshot trabajadorSnapshot =
      await coleccionTrabajador.doc(uid).get();
  DocumentSnapshot horarioSnapshot = await coleccionHorario.doc(cid).get();
  var datosHorario = horarioSnapshot.data() as Map<String, dynamic>;
  //guarda directamente los dias y las horas,
  //LAS HORAS SON UNA LISTA DINAMICA
  datosHorario = datosHorario['Dias'] as Map<String, dynamic>;
  var datosTrabajador = trabajadorSnapshot.data() as Map<String, dynamic>;
  //los añade a los datos del trabajador con los demas datos
  datosTrabajador.addAll(datosHorario);
  return datosTrabajador;
}

rechazar(uid, cid, {bool contratacion = false, bool success = true}) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference coleccionPostulacion = db.collection('Postulaciones');
  DateTime fechaHoy = DateTime.now();
  String idChaza = "";
  String campo;
  if (contratacion) {
    campo = 'Contratado';
  } else {
    campo = 'Rechazado';
  }
  await coleccionPostulacion
      .where('IDHorario', isEqualTo: cid)
      .get()
      .then((value) => {
            idChaza =
                (value.docs.first.data() as Map<String, dynamic>)['IDChaza'],
            coleccionPostulacion
                .doc(value.docs.first.id)
                .update({campo: success, 'FechaUltimaActualizacion': fechaHoy})
          });
  return idChaza;
}

contratar(uid, idHorarioTrabajador) async {
  //borra de postulados
  String cid = await rechazar(uid, idHorarioTrabajador, contratacion: true);
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference coleccionRelacion = db.collection('RelacionTrabajadores');
  CollectionReference coleccionHorario = db.collection('Horario');
  CollectionReference coleccionChazas = db.collection('Chaza');
  var horario = (await coleccionHorario.doc(idHorarioTrabajador).get())
      .get('Dias') as Map<String, dynamic>;
  var snapshotChaza = await coleccionChazas.doc(cid).get();
  String idHorario = snapshotChaza.get('horario');
  //guarda en relacion trabajador

  print(horario);
  bool yaExiste = false;
  var horarioChaza = (await coleccionHorario.doc(idHorario).get()).get('Dias')
      as Map<String, dynamic>;
  Map<String, dynamic> dias = {};
  for (var key in horarioChaza.keys) {
    var map = horarioChaza[key] as Map<String, dynamic>;
    var temp = horario[key];
    for (var i in temp) {
      //actualiza cada día
      if (i == '') {
        continue;
      }
      map.update(
        i,
        (value) {
          if (value != '') {
            print(value);
            throw Exception('LLENO');
          }
          return uid;
        },
      );
    }
    //almacena cada día
    dias.addAll({key: map});
    // ignore: avoid_print
  }
  DateTime fechaHoy = DateTime.now();
  //manda a la bd
  await coleccionHorario
      .doc(idHorario)
      .update({'Dias': dias, 'FechaUltimaActualizacion': fechaHoy});
  String idHorarioExistente = "";
  var existe = await coleccionRelacion
      .where('IDTrabajador', isEqualTo: uid)
      .where('IDChaza', isEqualTo: cid)
      .where('Estado', isEqualTo: true)
      .get();
  if (existe.size != 0) {
    yaExiste = true;
    idHorarioExistente = await existe.docs.first.get('IDHorario') as String;
    var horarioExistente =
        (await coleccionHorario.doc(idHorarioExistente).get()).get('Dias')
            as Map<String, dynamic>;
    for (var key in horario.keys) {
      List list1 = horarioExistente[key];
      List list2 = horario[key];
      var newList = List.from(list1)..addAll(list2);
      List listaSinDuplicados = newList.toSet().toList();
      listaSinDuplicados.remove('');
      listaSinDuplicados.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      if (listaSinDuplicados.isEmpty) {
        listaSinDuplicados.add('');
      }
      horario[key] = listaSinDuplicados;
    }
  }
  //merge
  if (!yaExiste) {
    final data = {
      "IDTrabajador": uid,
      "IDChaza": cid,
      "IDHorario": idHorarioTrabajador,
      "Estado": true,
      "FechaCreacion": fechaHoy,
      "FechaUltimaActualizacion": fechaHoy,
    };
    return await coleccionRelacion.add(data);
  } else {
    coleccionHorario
        .doc(idHorarioExistente)
        .update({'Dias': horario, 'FechaUltimaActualizacion': fechaHoy});
  }
}
