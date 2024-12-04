import 'package:flutter/material.dart';
import 'RoomDetailsScreen.dart'; // Importamos la pantalla de detalles

class AllRoomsScreen extends StatelessWidget {
  const AllRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> rooms = [
      {
        'image': 'assets/images/room1.jpg',
        'title': 'Habitación Deluxe',
        'price': '\$120 por noche',
        'description': 'La Habitación Deluxe cuenta con vistas impresionantes y todas las comodidades modernas para garantizar una estancia lujosa y cómoda.',
      },
      {
        'image': 'assets/images/room2.jpg',
        'title': 'Suite con Vista al Mar',
        'price': '\$200 por noche',
        'description': 'Disfruta de la vista al mar desde esta suite equipada con una sala de estar privada, balcón y bañera de hidromasaje.',
      },
      {
        'image': 'assets/images/room3.jpg',
        'title': 'Habitación Familiar',
        'price': '\$150 por noche',
        'description': 'Ideal para familias, esta habitación ofrece espacio adicional, camas dobles y entretenimiento para los niños.',
      },
      {
        'image': 'assets/images/room1.jpg',
        'title': 'Habitación Económica',
        'price': '\$80 por noche',
        'description': 'Perfecta para presupuestos ajustados, esta habitación combina comodidad y ahorro sin comprometer la calidad.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas las Habitaciones'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return GestureDetector(
            onTap: () {
              // Navegar a la pantalla de detalles con datos específicos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomDetailsScreen(
                    imageUrl: room['image']!,
                    title: room['title']!,
                    price: room['price']!,
                    description: room['description']!,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                children: [
                  // Imagen de la habitación
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(8.0)),
                    child: Image.asset(
                      room['image']!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            room['price']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrangeAccent[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
