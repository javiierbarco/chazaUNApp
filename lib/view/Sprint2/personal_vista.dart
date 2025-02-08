import 'package:chazaunapp/view/Sprint2/ver_mas_activos.dart';
import 'package:chazaunapp/view/Sprint2/ver_mas_postulados.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

import '../../Services/Sprint2/services_mehu_personalcandiadtos_chazero.dart';
import '../../Services/Sprint2/services_menu_personalactivo_chazero.dart';

class PersonalVista extends StatefulWidget {
  const PersonalVista({super.key});

  @override
  State<PersonalVista> createState() => _PersonalVistaState();
}

class _PersonalVistaState extends State<PersonalVista> {
  String chazaActual = "";

  @override
  Widget build(BuildContext context) {
    chazaActual = ModalRoute.of(context)?.settings.arguments as String;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Activos",
                ),
                Tab(text: "Candidatos")
              ],
              unselectedLabelColor: Colors.black87,
              unselectedLabelStyle:
                  TextStyle(fontSize: 24.0, fontFamily: "Inder"),
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 24.0, fontFamily: "Inder"),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 3),
                  insets: EdgeInsets.only(bottom: 5)),
              indicatorSize: TabBarIndicatorSize.label,
            ),
            title: const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text("Personal"),
            ),
            titleTextStyle:
                const TextStyle(color: Colors.white, fontSize: 60.0),
            toolbarHeight: screenHeight * 0.165,
            centerTitle: true,
            backgroundColor: colorPrincipal,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.only(bottom: 60),
              icon: const Icon(Icons.arrow_back),
              iconSize: 40,
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getPersonalActivoPorChaza(chazaActual),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            infoPostulacion_(
                                snapshot.data![index][1],
                                snapshot.data![index][0]['nombres'],
                                snapshot.data![index][0]['foto'],
                                trabajaDiasActivo(snapshot.data![index]),
                                0,
                                snapshot.data![index][0]['idHorario'])
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
              FutureBuilder(
                future: getPostulacionesPorChaza(chazaActual),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              infoPostulacion_(
                                  snapshot.data![index][1], // uid
                                  snapshot.data![index][0]['nombres'],
                                  snapshot.data![index][0]['foto'],
                                  trabajaDiasPostulado(snapshot.data![index]),
                                  1,
                                  snapshot.data![index][0]['idHorario'])
                            ],
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
            ],
          ),
        ));
  }

  Padding infoPostulacion_(String uid, String nombres, String foto,
      List<bool> dias, int tipo, String idHorario) {
    return Padding(
      padding: const EdgeInsets.only(left: 27, right: 27),
      child: Card(
          child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                nombres,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Inder", fontSize: 23),
              ),
              ClipRRect(
                // Contenedor para que la imagen tenga borde redondeado
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: NetworkImage(foto),
                  //Parametro del enlace de la imagen de la chaza
                  height: 68,
                  // Tamaño
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              diaIcono(dias[0], 'L'),
              diaIcono(dias[1], 'M'),
              diaIcono(dias[2], 'M'),
              diaIcono(dias[3], 'J'),
              diaIcono(dias[4], 'V'),
              diaIcono(dias[5], 'S')
            ],
          ),
          botonVermas(
            context,
            uid,
            tipo,
            idHorario,
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.black,
          )
        ],
      )),
    );
  }

  ElevatedButton botonVermas(
      BuildContext context, String uid, int tipo, String idHorario) {
    //Ya anda bien

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: Size(screenWidth * 0.3, screenHeight * 0.045),
          // double.infinity is the width and 30 is the height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: () {
          //al presionar hace
          /*Navigator.pushNamed(
            context,
            'lib\view\Sprint2\ver_mas_postulados.dart',
            arguments:
            chazaActual
            );
*/

          if (tipo == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
              return VerMasActivos(uid, chazaActual, idHorario);
            }));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
              return VerMasPostulados(uid, idHorario, chazaActual);
            }));
          }
        },
        child: const Text(
          "Ver mas",
          style:
              TextStyle(color: Colors.black, fontSize: 23, fontFamily: "Inder"),
        ));
  }

  Container diaIcono(bool trabaja, String letra) {
    Color colorDia;
    if (trabaja) {
      colorDia = colorChazero.withOpacity(0.4);
    } else {
      colorDia = Colors.grey.shade50;
    }
    return Container(
      width: 33,
      height: 33,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorDia, // Color del círculo
      ),
      child: Center(
        child: Text(
          letra, // Letra adentro del círculo
          style: const TextStyle(
            color: Colors.black, // Color de la letra
            fontSize: 17,
            fontFamily: "Inder",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
