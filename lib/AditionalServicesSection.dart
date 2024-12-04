import 'package:flutter/material.dart';

class AdditionalServicesSection extends StatelessWidget {
  const AdditionalServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> additionalServices = [
      {
        'icon': Icons.wifi,
        'title': 'Wi-Fi Gratuito',
        'description': 'Conéctate en cualquier lugar del hotel con nuestro Wi-Fi de alta velocidad.',
      },
      {
        'icon': Icons.breakfast_dining,
        'title': 'Desayuno Continental',
        'description': 'Disfruta de un delicioso desayuno buffet cada mañana.',
      },
      {
        'icon': Icons.local_parking,
        'title': 'Estacionamiento',
        'description': 'Amplio estacionamiento privado disponible para todos nuestros huéspedes.',
      },
      {
        'icon': Icons.credit_card,
        'title': 'Acceso con Tarjeta',
        'description': 'Habitaciones seguras con acceso mediante tarjeta magnética.',
      },
      {
        'icon': Icons.cleaning_services,
        'title': 'Servicio de Limpieza',
        'description': 'Habitaciones impecables con servicio de limpieza diario.',
      },
      {
        'icon': Icons.security,
        'title': 'Seguridad 24/7',
        'description': 'Cámaras de seguridad y personal disponible las 24 horas del día.',
      },
      {
        'icon': Icons.pool,
        'title': 'Jacuzzi Privado',
        'description': 'Relájate en nuestro jacuzzi privado disponible bajo reserva.',
      },
      {
        'icon': Icons.pets,
        'title': 'Admite Mascotas',
        'description': 'Trae a tu mejor amigo contigo, somos un hotel pet-friendly.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Servicios Adicionales',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Dos columnas
              mainAxisSpacing: 16, // Espaciado vertical
              crossAxisSpacing: 16, // Espaciado horizontal
              childAspectRatio: 2.5, // Proporción para descripción detallada
            ),
            itemCount: additionalServices.length,
            itemBuilder: (context, index) {
              final service = additionalServices[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        service['icon'] as IconData,
                        size: 40,
                        color: Colors.blueGrey[900],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              service['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service['description'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
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