import 'package:auto_size_text/auto_size_text.dart';
import 'package:chazaunapp/Services/services_menuchazero.dart';
import 'package:chazaunapp/view/Sprint3/horarios_chaza_chazero.dart';
import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

//Pruebita pull request

class MenuChazeroVista extends StatefulWidget {
  final String? id;

  const MenuChazeroVista(this.id, {super.key});

  @override
  State<MenuChazeroVista> createState() => _MenuChazeroVistaState();
}

class _MenuChazeroVistaState extends State<MenuChazeroVista> {
  final TextEditingController _controller = TextEditingController();
  String idChazero = ""; //Id del chazero, cambiar para probar el otro chazero

  @override
  void initState() {
    super.initState();
    _controller.text = widget.id.toString();
    idChazero = widget.id!;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      body: Container(
        color: colorBackground,
        child: Column(
          children: [
            Stack(
              children: [
                barraSuperior_(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: getChazasporChazero(idChazero),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final itemCount = snapshot.data?.length ?? 0;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const ClampingScrollPhysics(), // Deshabilita el desplazamiento excesivo
                      padding: EdgeInsets.zero, // Elimina el espacio de relleno
                      itemCount: itemCount +
                          1, // Incrementar el itemCount en 1 para incluir el botón
                      itemBuilder: (context, index) {
                        if (index < itemCount) {
                          return Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.235,
                                child: infoChaza_(
                                  snapshot.data?[index]['nombre'],
                                  snapshot.data?[index]['ubicacion'],
                                  snapshot.data?[index]['puntuacion'],
                                  snapshot.data?[index]['paga'],
                                  snapshot.data?[index]['imagen'],
                                  snapshot.data?[index]['id'],
                                  snapshot.data?[index]['horario'],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        } else {
                          // Último ítem, mostrar el botón
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              registrarBoton_(),
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton registrarBoton_() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: const Size(
              180, 50), // double.infinity is the width and 30 is the height
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        onPressed: action(),
        child: const Text(
          "Añadir Chaza",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }

  SizedBox barraSuperior_() {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return SizedBox(
        height: screenHeight * 0.25,
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
                'Chazero', // el texto que quieres mostrar
                style: TextStyle(
                  color: colorBackground, // Establece el color del texto
                  fontSize: 60.0, // Establece el tamaño del texto
                  fontFamily: "Inder",
                ),
              ),
            ),
          ),
        ));
  }

  Padding infoChaza_(String nombre, String ubicacion, String puntuacion,
      String pago, String imagen, String id, String idHorario) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        //Una columna que contiene rows y columnas de rows para conseguir el aspecto que habia en el mockup
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: screenHeight * 0.025,
                      width: screenWidth * 0.35,
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: AutoSizeText(
                        nombre, // Nombre de la chaza
                        style: const TextStyle(
                          color: Color(0xff242424),
                          fontSize: 24.0,
                          fontFamily: "Inder",
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines:
                            1, // Define el número máximo de líneas permitidas
                        overflow: TextOverflow
                            .fade, // Define cómo se maneja el desbordamiento del texto
                      ),
                    ),
                    rowUbicacion_(ubicacion),
                    rowPuntuacion_(puntuacion),
                  ],
                ),
                columnFotoYPagoChaza_(imagen, pago),
              ],
            ),
            const Divider(
              color: Colors.black54,
              indent: 15,
              endIndent: 15,

              thickness: 1.5, // ajusta el grosor de la línea
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                botonHorarios(
                  context,
                  idHorario,
                  nombre,
                ),
                botonPersonal(context, id)
              ],
            )
          ],
        ),
      ),
    );
  }

  Row rowUbicacion_(String ubicacion) {
    //row para juntar el icono y el texto
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_rounded,
            color: Color(0xff919191), size: 16.0),
        Text(
          ubicacion,
          style: const TextStyle(
              color: Color(0xff919191),
              fontSize: 14.5,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Row rowPuntuacion_(String puntuacion) {
    //row para juntar el icono y el texto
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.star,
          color: colorChazero,
          size: 15.0,
        ),
        Text(
          puntuacion,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Column columnFotoYPagoChaza_(String imagen, String pago) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          height: 5,
        ),
        ClipRRect(
          // Contenedor para que la imagen tenga borde redondeado
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
            image: NetworkImage(imagen),
            //Parametro del enlace de la imagen de la chaza
            height: screenHeight * 0.068,
            // Tamaño
          ),
        ),
        Text(
          "$pago / Hora",
          style: const TextStyle(
              color: colorTrabajador,
              fontSize: 13.0,
              fontFamily: "Inder",
              fontWeight: FontWeight.normal),
        ),
        const Icon(
          Icons.more_horiz,
          color: Color.fromARGB(255, 143, 143, 143),
          size: 24.0,
        ),
      ],
    );
  }

  ElevatedButton botonHorarios(
      BuildContext context, String idHorario, String nombre) {
    //Au no hace nada porque no tengo seguridad de si esa pantalla está disponible
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: Size(
              screenWidth * 0.3,
              screenHeight *
                  0.045), // double.infinity is the width and 30 is the height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return HorarioChazaChazeroVista(
              nombreChaza: nombre,
              idHorario: idHorario,
            );
          }));
        },
        child: const Text(
          "Horarios",
          style:
              TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Inder"),
        ));
  }

  ElevatedButton botonPersonal(BuildContext context, String id) {
    //Aun no hace nada porque no tengo seguridad de cual es esa pantalla y si está disponible
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorChazero,
          minimumSize: Size(screenWidth * 0.3, screenHeight * 0.045),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: pantallaPersonal(id),
        child: const Text(
          "Personal",
          style:
              TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Inder"),
        ));
  }

/* ya no se usaaaaaaaaa :DDDD
  Function() _enProgreso(BuildContext context) {
    return () {
      Navigator.pushNamed(context, '/progreso');
    };
  }
*/
  pantallaPersonal(String id) {
    return () {
      Navigator.pushNamed(context, '/menu/chazero/personal', arguments: id);
    };
  }

  action() {
    return () {
      Navigator.pushNamed(context, '/menu/chazero/registrar/chaza');
    };
  }
}
