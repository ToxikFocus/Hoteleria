// Archivo: home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange;
  int numberOfGuests = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Hotel PWA'),
        backgroundColor: Colors.blueGrey[900], // Cambiamos a un azul gris oscuro
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                print('Reservar Ahora');
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent[400]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Text('Reservar Ahora'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ServicesSection(),
            RoomsSection(),
            BottomActionButtons(),
          ],
        ),
      ),
    );
  }
}

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
        Container(
          height: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/hotel_banner.jpg'), // Imagen local
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
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
              DateSelector(
                selectedDateRange: selectedDateRange,
                onDateRangeSelected: onDateRangeSelected,
              ),
              SizedBox(height: 16.0),
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
                  print('Buscando habitaciones disponibles para $numberOfGuests personas del ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} al ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                primaryColor: Colors.blueGrey[900],
                scaffoldBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(primary: Colors.blueGrey[900]!),
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
            Icon(Icons.calendar_today, color: Colors.blueGrey[900]),
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
          SizedBox(
            height: 180,
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

// Widget individual para cada tarjeta de servicio
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
      height: 180,
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
            Icon(icon, size: 40, color: Colors.blueGrey[900]),
            SizedBox(height: 12.0),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habitaciones Destacadas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                RoomCard(
                  imageUrl: 'assets/images/room1.jpg',
                  title: 'Habitación Deluxe',
                  price: '\$120 por noche',
                ),
                RoomCard(
                  imageUrl: 'assets/images/room2.jpg',
                  title: 'Suite con Vista al Mar',
                  price: '\$200 por noche',
                ),
                RoomCard(
                  imageUrl: 'assets/images/room3.jpg',
                  title: 'Habitación Familiar',
                  price: '\$150 por noche',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const RoomCard({
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  price,
                  style: TextStyle(fontSize: 16, color: Colors.deepOrangeAccent[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Contáctenos'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Ver Todas las Habitaciones');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Ver Habitaciones'),
          ),
        ],
      ),
    );
  }
}
