
class Chaza {
  late String nombre;
  late String ubicacion;
  late String tipo;
  late String pagoHora;
  late String descripcion;
  late String imagen;

  Chaza(
      {required this.nombre,
      required this.ubicacion,
      required this.tipo,
      required this.pagoHora,
      required this.descripcion,
      required this.imagen});
}

List<Chaza> chazaList = [
  // Chaza(
  //     nombre: 'Sexchaza',
  //     ubicacion: 'Sociologia',
  //     tipo: 'varios',
  //     pagoHora: '40k',
  //     descripcion: 'Vaya chaza',
  //     imagen: 'assets/imagenes/SexChaza.png'),
  // Chaza(
  //     nombre: 'RubikChaza',
  //     ubicacion: 'Entrada 30',
  //     tipo: 'varios',
  //     pagoHora: '40k',
  //     descripcion: 'Lleve su cubo Rubik',
  //     imagen: 'assets/imagenes/RubikChaza.png')
];
