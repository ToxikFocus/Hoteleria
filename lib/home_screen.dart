import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'AllRoomsScreen.dart';
import 'AvailableRoomsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
        title: const Text('Hotel PWA'),
        backgroundColor: Colors.blueGrey[900],
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
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              child: const Text('Reservar Ahora'),
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
            const ServicesSection(),
            const RoomsSection(),
            const BottomActionButtons(),
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

  const HeaderSection({
    super.key,
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/hotel_banner.jpg'),
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
              const Text(
                'Bienvenido a Hotel PWA',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Busca disponibilidad basada en fechas y número de huéspedes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16.0),
              DateSelector(
                selectedDateRange: selectedDateRange,
                onDateRangeSelected: onDateRangeSelected,
              ),
              const SizedBox(height: 16.0),
              GuestsSelector(
                numberOfGuests: numberOfGuests,
                onGuestsChanged: onGuestsChanged,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedDateRange == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor selecciona un rango de fechas.'),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableRoomsScreen(
                        selectedDateRange: selectedDateRange!,
                        numberOfGuests: numberOfGuests,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Buscar Habitaciones Disponibles'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DateSelector extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final Function(DateTimeRange) onDateRangeSelected;

  const DateSelector({
    super.key,
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
          lastDate: DateTime.now().add(const Duration(days: 365)),
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
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
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
            const SizedBox(width: 8.0),
            Text(
              selectedDateRange == null
                  ? 'Seleccionar Fechas'
                  : 'Desde: ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - Hasta: ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
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

  const GuestsSelector({
    super.key,
    required this.numberOfGuests,
    required this.onGuestsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
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
          const Text(
            'Cantidad de Huéspedes',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          DropdownButton<int>(
            value: numberOfGuests,
            onChanged: (value) {
              if (value != null) onGuestsChanged(value);
            },
            items: List.generate(10, (index) => index + 1)
                .map(
                  (e) => DropdownMenuItem<int>(
                value: e,
                child: Text('$e'),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nuestros Servicios',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
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

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueGrey[900]),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
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
  const RoomsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Habitaciones Destacadas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
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
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepOrangeAccent[400],
                  ),
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
  const BottomActionButtons({super.key});

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
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Contáctenos'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllRoomsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ver Habitaciones'),
          ),
        ],
      ),
    );
  }
}

