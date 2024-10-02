// Archivo: home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Paquete para formatear fechas

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange; // Rango de fechas seleccionadas
  int numberOfGuests = 1; // Cantidad de huéspedes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo de la pantalla
      appBar: AppBar(
        title: Text('Hotel PWA'),
        backgroundColor: Colors.blue[800]!, // Color de fondo del AppBar
        elevation: 0, // Eliminar sombra
        actions: [
          ElevatedButton(
            onPressed: () {
              print('Reservar Ahora');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600]!,
              elevation: 0,
            ),
            child: Text('Reservar Ahora'),
          ),
          SizedBox(width: 8.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de encabezado con selector de fechas y cantidad de personas
            HeaderSection(
              onDateRangeSelected: (range) {
                setState(() {
                  selectedDateRange = range;
                });
              },
              onGuestsChanged: (guests) {
                setState(() {
                  numberOfGuests = guests;
                });
              },
              selectedDateRange: selectedDateRange,
              numberOfGuests: numberOfGuests,
            ),

            // Sección de servicios del hotel
            ServicesSection(), // Definición de widget ServicesSection

            // Sección de habitaciones destacadas
            RoomsSection(), // Definición de widget RoomsSection

            // Sección de acciones finales como "Contáctenos" y "Ver Habitaciones"
            BottomActionButtons(), // Definición de widget BottomActionButtons
          ],
        ),
      ),
    );
  }
}

// Sección de encabezado con selector de fechas y huéspedes
class HeaderSection extends StatelessWidget {
  final Function(DateTimeRange) onDateRangeSelected;
  final Function(int) onGuestsChanged;
  final DateTimeRange? selectedDateRange;
  final int numberOfGuests;

  HeaderSection({
    required this.onDateRangeSelected,
    required this.onGuestsChanged,
    this.selectedDateRange,
    required this.numberOfGuests,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo para el encabezado
        Container(
          height: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://example.com/hotel_banner.jpg'), // URL de imagen del banner
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Sombra oscura para el texto de bienvenida
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.3), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        // Texto de bienvenida y seleccionador de fechas y huéspedes
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido a Hotel PWA',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Busca disponibilidad basada en fechas y número de huéspedes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 16.0),
              // Selector de fechas
              DateSelector(
                selectedDateRange: selectedDateRange,
                onDateRangeSelected: onDateRangeSelected,
              ),
              SizedBox(height: 16.0),
              // Selector de cantidad de personas
              GuestsSelector(
                numberOfGuests: numberOfGuests,
                onGuestsChanged: onGuestsChanged,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedDateRange == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor selecciona un rango de fechas.')),
                    );
                    return;
                  }
                  // Implementar lógica para verificar disponibilidad
                  print('Buscando habitaciones disponibles para $numberOfGuests personas del ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} al ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600]!,
                ),
                child: Text('Buscar Habitaciones Disponibles'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget para el selector de fechas
class DateSelector extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final Function(DateTimeRange) onDateRangeSelected;

  DateSelector({
    required this.selectedDateRange,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTimeRange? range = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blue[800]!, // Cambio: Aseguramos que el color no sea nulo
                scaffoldBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(primary: Colors.blue[800]!),
              ),
              child: child!,
            );
          },
        );
        if (range != null) {
          onDateRangeSelected(range);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.calendar_today, color: Colors.blue[800]!),
            SizedBox(width: 8.0),
            Text(
              selectedDateRange == null
                  ? 'Seleccionar Fechas'
                  : 'Desde: ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - Hasta: ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para seleccionar la cantidad de huéspedes
class GuestsSelector extends StatelessWidget {
  final int numberOfGuests;
  final Function(int) onGuestsChanged;

  GuestsSelector({
    required this.numberOfGuests,
    required this.onGuestsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Cantidad de Huéspedes', style: TextStyle(fontSize: 16, color: Colors.black87)),
          DropdownButton<int>(
            value: numberOfGuests,
            onChanged: (value) {
              if (value != null) onGuestsChanged(value);
            },
            items: List.generate(10, (index) => index + 1)
                .map((e) => DropdownMenuItem<int>(
              value: e,
              child: Text('$e'),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Definición del widget para la sección de servicios del hotel
class ServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nuestros Servicios',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // Crear un carrusel horizontal de servicios
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ServiceCard(
                  icon: Icons.pool,
                  title: 'Piscina',
                  description: 'Relájate y disfruta en nuestra piscina moderna.',
                ),
                ServiceCard(
                  icon: Icons.restaurant,
                  title: 'Restaurante',
                  description: 'Platillos gourmet para todos los gustos.',
                ),
                ServiceCard(
                  icon: Icons.spa,
                  title: 'Spa',
                  description: 'Experiencia de relajación total con nuestro spa.',
                ),
                ServiceCard(
                  icon: Icons.local_bar,
                  title: 'Bar',
                  description: 'Degusta cocteles y bebidas exclusivas.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Definición del widget para la sección de habitaciones destacadas
class RoomsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Text(
        'Habitaciones Destacadas',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Definición del widget para la sección inferior con botones de acción
class BottomActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              print('Contáctenos');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]!),
            child: Text('Contáctenos'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Ver Todas las Habitaciones');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[600]!),
            child: Text('Ver Habitaciones'),
          ),
        ],
      ),
    );
  }
}

// Definición del widget individual para las tarjetas de servicio
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue[800]!),
            SizedBox(height: 12.0),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
