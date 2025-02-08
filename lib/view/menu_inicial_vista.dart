import 'package:chazaunapp/Services/services_menu_inicial.dart';
// import 'package:chazaunapp/view/Sprint3/calendario_chaza_vista.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:chazaunapp/view/menu_inicia_cards/fill_image_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Sprint2/configuracion_trabajador_vista.dart';
import 'Sprint2/info_cuenta_trabajador.dart';

class MenuInicialVistaView extends StatefulWidget {
  const MenuInicialVistaView({super.key});

  @override
  State<MenuInicialVistaView> createState() => _MenuInicialVistaView();
}

String? userId = FirebaseAuth.instance.currentUser?.uid.toString().trim();

int _currentIndex = 0; // Índice del ítem seleccionado actualmente
int filtroTipo =
    3; // Valor inicial que representa el filtro inicial (0 = todos los tipos)

class _MenuInicialVistaView extends State<MenuInicialVistaView> {
  // Función para cambiar el índice y navegar a la pantalla correspondiente
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoCuentaTrabajador()),
        );
      } else if (_currentIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ConfiguracionTrabajoVista()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //para no tener que iniciar sesion cada vez que se oprima atras quite el Pop
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
                        color: colorPrincipal,
                        // Establece el color de fondo del contenedor con el texto
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
                  todosBottom_()
                ],
              ),
              const SizedBox(
                width: 55,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              mostrarChazas()
            ],
          ),
        ),
      ),
      // En el cuerpo de tu widget, en el método build, debajo del BottomNavigationBar:
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        // Función que se ejecuta al hacer clic en un ítem
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
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

  Widget mostrarChazas() {
    return SizedBox(
      height: 500,
      width: 410,
      child: FutureBuilder(
        future: getChazas(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List? chazasFiltradas = snapshot.data;

            if (filtroTipo == 3) {
              // Retornar todas las chazas sin filtrar
              chazasFiltradas = snapshot.data;
            }
            if (filtroTipo == 0) {
              // Filtrar las chazas según el tipo seleccionado
              chazasFiltradas = chazasFiltradas
                  ?.where((chaza) => chaza['tipo'] == filtroTipo)
                  .toList();
            }
            if (filtroTipo == 1) {
              // Filtrar las chazas según el tipo seleccionado
              chazasFiltradas = chazasFiltradas
                  ?.where((chaza) => chaza['tipo'] == filtroTipo)
                  .toList();
            }
            if (filtroTipo == 2) {
              // Filtrar las chazas según el tipo seleccionado
              chazasFiltradas = chazasFiltradas
                  ?.where((chaza) => chaza['tipo'] == filtroTipo)
                  .toList();
            }

            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: chazasFiltradas!.length,
              itemBuilder: (text, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 250,
                      width: 300,
                      child: card(
                        chazasFiltradas?[index]['nombre'],
                        chazasFiltradas?[index]['ubicacion'],
                        chazasFiltradas?[index]['puntuacion'],
                        chazasFiltradas?[index]['paga'],
                        chazasFiltradas?[index]['imagen'],
                        chazasFiltradas?[index]['id'],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 30);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
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
                onTap: () {
                  setState(() {
                    filtroTipo = 0; // Cambiar el filtro a tipo 2 (cubiertos)
                  });
                },
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
          splashColor: Colors.black26,
          onTap: () {
            setState(() {
              filtroTipo = 1; // Cambiar el filtro a tipo 2 (cubiertos)
            });
          },
          child: Image.asset(
            'assets/imagenes/snack.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  masBottom_() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          splashColor: Colors.black26,
          onTap: () {
            setState(() {
              filtroTipo = 2; // Cambiar el filtro a tipo 3 (más)
            });
          },
          child: Image.asset(
            'assets/imagenes/mas.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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

  todosBottom_() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          splashColor: Colors.black26,
          onTap: () {
            setState(() {
              filtroTipo = 3; // Sin filtro
            });
          },
          child: Image.asset(
            'assets/imagenes/todos.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Card card(String nombre, String ubicacion, String puntuacion, String pago,
      String imagen, String id) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FillImageCard(
            width: 300,
            heightImage: 140,
            imageProvider: NetworkImage(imagen),
            tags: [_tag(id, 'Ingresar', () {})],
            title: _title(nombre),
            description: _content(ubicacion, pago),
          ),
          const SizedBox(width: 12),
        ],
      ),
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
                  style:
                      const TextStyle(fontFamily: "Inder", color: Colors.black),
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

  Widget _tag(String id, String tag, VoidCallback onPressed) {
    return InkWell(
      onTap: pantallaInfoChaza(id),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: colorChazero),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          tag,
          style: const TextStyle(fontFamily: "Inder", color: Colors.white),
        ),
      ),
    );
  }

  Function() _enProgreso(BuildContext context) {
    return () {
      Navigator.pushNamed(context, '/menu/configuracionTrabajo');
    };
  }

  pantallaInfoChaza(String id) {
    return () {
      Navigator.pushNamed(context, '/menu/chazas/informacion', arguments: id);
    };
  }
}
