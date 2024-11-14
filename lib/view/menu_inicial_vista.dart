import 'package:flutter/material.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:chazaunapp/Services/services_menu_inicial.dart';
import 'package:chazaunapp/view/menu_inicia_cards/fill_image_card.dart';

class MenuInicialVistaView extends StatefulWidget {
  const MenuInicialVistaView({super.key});

  @override
  State<MenuInicialVistaView> createState() => _MenuInicialVistaView();
}

class _MenuInicialVistaView extends State<MenuInicialVistaView> {
  int _currentIndex = 0;
  String idChazero = "D5KI1DaVGA8e9toA0lCq";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: colorBackground,
          child: Column(
            children: [
              Stack(
                children: [
                  // Contenedor con texto y fondo
                  SizedBox(
                    height: 186.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color:
                            colorPrincipal, // Establece el color de fondo del contenedor con el texto
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                        ),
                      ),
                      child: const Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Usuario', // el texto que quieres mostrar
                            style: TextStyle(
                                color: Colors
                                    .white, // Establece el color del texto
                                fontSize: 55.0, // Establece el tamaño del texto
                                fontFamily: "Inder",
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  chefBottom_(),
                  cubiertosBottom_(),
                  masBottom_(),
                ],
              ),
              const SizedBox(
                width: 55,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Chazas', // el texto que quieres mostrar
                      style: TextStyle(
                          color: Colors.black, // Establece el color del texto
                          fontSize: 30.0, // Establece el tamaño del texto
                          fontFamily: "Inder",
                          fontWeight: FontWeight.normal),
                    )),
              ]),
              SizedBox(

                height: 500,
                width: 410, // Tamaño fijo
                child: FutureBuilder(
                  future: getChazas(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      //Si la consulta devuelve algo o espera
                      return ListView.separated(
                        //Hace una lista de todas las filas que había en la matriz chazas
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: snapshot.data?.length ??
                            0, // casi como un for que itera las veces de las filas de la matriz
                        itemBuilder: (text, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 250,
                                width: 300,
                                child: card(
                                    // hace una card infochaza con los detalles de cada fila, osea cada chaza
                                    snapshot.data?[index]['nombre'],
                                    snapshot.data?[index]['ubicacion'],
                                    snapshot.data?[index]['puntuacion'],
                                    snapshot.data?[index]['paga'],
                                    snapshot.data?[index]['imagen']),
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ], //Espacio entre las cards
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 30);
                        },
                      );
                    } else {
                      return const Center(
                        child:
                            CircularProgressIndicator(), // Si la bd se tarda o no da nada
                      );
                    }
                  }),
                ),

              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Inicio'), //Icono home
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Ajustes')
        ],
        backgroundColor: Colors.white,
        selectedItemColor: colorPrincipal,
        unselectedItemColor: const Color(0xff909090),
        unselectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        selectedLabelStyle: const TextStyle(fontFamily: "Inder"),
        iconSize: 34,
      ),
    );
  }

  chefBottom_() {
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
                //Coidgo extra para funcionar boton
                splashColor: Colors.black26,
                onTap: _enProgreso(context),
                child: Image.asset(
                  'assets/imagenes/chef.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ))));
  }

  cubiertosBottom_() {
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
                //Coidgo extra para funcionar boton
                splashColor: Colors.black26,
                onTap: _enProgreso(context),
                child: Image.asset(
                  'assets/imagenes/snack.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ))));
  }

  masBottom_() {
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
                //Coidgo extra para funcionar boton
                splashColor: Colors.black26,
                onTap: _enProgreso(context),
                child: Image.asset(
                  'assets/imagenes/mas.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ))));
  }

  ElevatedButton chazaBottom() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: const Size(
              120, 39), // double.infinity is the width and 30 is the height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: _enProgreso(context),
        child: const Text(
          "Entrar",
          style:
              TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Inder"),
        ));
  }

  // ListView chazas(String nombre, String ubicacion, String puntuacion,
  //     String pago, String imagen) {
  //   return ListView.separated(
  //     separatorBuilder: (BuildContext context, int index) {
  //       return const SizedBox(height: 30);
  //     },
  //     shrinkWrap: true,
  //     scrollDirection: Axis.vertical,
  //     itemCount: chazaList.length,
  //     itemBuilder: (ontext, index) {
  //       return Column(
  //         children: [
  //           SizedBox(
  //             height: 200,
  //             child: card(
  //                 // hace una card infochaza con los detalles de cada fila, osea cada chaza
  //                 nombre,
  //                 ubicacion,
  //                 puntuacion,
  //                 pago,
  //                 imagen),
  //           ),
  //           const SizedBox(
  //             height: 15,
  //           )
  //         ], //Espacio entre las cards
  //       );
  //     },
  //   );
  // }

  Card card(String nombre, String ubicacion, String puntuacion, String pago,
      String imagen) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FillImageCard(
            width: 300,
            heightImage: 140,
            imageProvider: NetworkImage(imagen),
            tags: [_tag('Ingresar', () {})],
            title: _title(nombre),
            description: _content(ubicacion, pago),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  BottomNavigationBar barraChazero() {
    //La barra de opciones inferior
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Inicio'), //Icono home
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: 'Ajustes')
      ],
      backgroundColor: Colors.white,
      selectedItemColor: colorPrincipal,
      unselectedItemColor: const Color(0xff909090),
      unselectedLabelStyle: const TextStyle(fontFamily: "Inder"),
      selectedLabelStyle: const TextStyle(fontFamily: "Inder"),
      iconSize:
          34, //Detalles del color del item seleccionado y la fuente de lo labels
    );
  }

  Widget _title(nombre) {
    return Text(
      nombre,
      style: const TextStyle(
          fontFamily: "Inder",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black),
    );
  }

  Widget _content(ubicacion, pago) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.location_on_rounded,
                    color: Color(0xff919191), size: 16.0),
                Text(
                  ubicacion,
                  style: const TextStyle(
                      fontFamily: "Inder",
                      color: Colors.black
                  ),
                ),
              ]),
          Text(
            "$pago / Hora",
            style: const TextStyle(
                color: colorTrabajador,
                fontSize: 13.0,
                fontFamily: "Inder",
                fontWeight: FontWeight.normal),
          ),
        ]);
  }

  // footer por si se ponia imagen de usuario abajo o boton de compartir

  // Widget _footer({Color? color}) {
  //   return Row(
  //     children: [
  //       CircleAvatar(
  //         backgroundImage: AssetImage(
  //           'assets/avatar.png',
  //         ),
  //         radius: 12,
  //       ),
  //       const SizedBox(
  //         width: 4,
  //       ),
  //       Expanded(
  //           child: Text(
  //         'Super user',
  //         style: TextStyle(color: color),
  //       )),
  //       IconButton(onPressed: () {}, icon: Icon(Icons.share))
  //     ],
  //   );
  // }

  Widget _tag(String tag, VoidCallback onPressed) {
    return InkWell(
      onTap: _enProgreso(context),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: colorChazero),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          tag,
          style: const TextStyle(
              fontFamily: "Inder",
              color: Colors.white
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _enProgreso(context);
  }

  Function() _enProgreso(BuildContext context) {
    return () {
      Navigator.pushNamed(context, '/progreso');
    };
  }
}
