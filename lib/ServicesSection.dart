import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'image': 'assets/images/pool.jpg',
        'title': 'Piscina',
        'description': 'Nuestra moderna piscina al aire libre es perfecta para relajarse bajo el sol o disfrutar de un chapuzón refrescante.',
      },
      {
        'image': 'assets/images/restaurant.jpg',
        'title': 'Restaurante',
        'description': 'Ofrecemos platillos gourmet para todos los gustos, preparados por chefs de renombre.',
      },
      {
        'image': 'assets/images/spa.jpg',
        'title': 'Spa',
        'description': 'Relájate con tratamientos exclusivos de spa, incluyendo masajes, faciales y mucho más.',
      },
      {
        'image': 'assets/images/bar.jpg',
        'title': 'Bar',
        'description': 'Disfruta de cócteles exclusivos y una amplia selección de bebidas en un ambiente sofisticado.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nuestros Servicios',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: services.map((service) {
              return Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            service['image'] as String,
                            height: 400,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['description'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
