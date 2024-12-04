import 'package:flutter/material.dart';

class RoomsSection extends StatelessWidget {
  const RoomsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      {
        'image': 'assets/images/room1.jpg',
        'title': 'Suite de Lujo',
        'description': 'Habitación espaciosa con vistas al mar, terraza privada y jacuzzi. Perfecta para disfrutar de una estancia inolvidable.',
        'services': ['Wi-Fi gratuito', 'Jacuzzi privado', 'TV de pantalla plana', 'Mini-bar'],
        'price': '\$150 por noche',
      },
      {
        'image': 'assets/images/room2.jpg',
        'title': 'Habitación Doble',
        'description': 'Habitación ideal para parejas o amigos con dos camas individuales y vistas a la ciudad.',
        'services': ['Wi-Fi gratuito', 'Aire acondicionado', 'Baño privado', 'Desayuno incluido'],
        'price': '\$100 por noche',
      },
      {
        'image': 'assets/images/room3.jpg',
        'title': 'Habitación Familiar',
        'description': 'Habitación amplia con dos camas dobles y un sofá cama. Ideal para familias.',
        'services': ['Wi-Fi gratuito', 'Desayuno incluido', 'TV de pantalla plana', 'Espacio para niños'],
        'price': '\$120 por noche',
      },
      {
        'image': 'assets/images/room4.png',
        'title': 'Habitación Individual',
        'description': 'Habitación cómoda y práctica para una persona. Con vistas al jardín.',
        'services': ['Wi-Fi gratuito', 'Aire acondicionado', 'Baño privado'],
        'price': '\$80 por noche',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Habitaciones Destacadas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Dos columnas
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 5 / 2, // Proporción mejorada
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => RoomDetailsModal(room: room),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          room['image'] as String,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room['title'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room['price'] as String,
                              style: TextStyle(fontSize: 14, color: Colors.deepOrange[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RoomDetailsModal extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomDetailsModal({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                room['image'] as String,
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              room['title'] as String,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              room['description'] as String,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              'Servicios Incluidos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...room['services']!.map<Widget>((service) {
              return Row(
                children: [
                  const Icon(Icons.check, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    service,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              );
            }).toList(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
