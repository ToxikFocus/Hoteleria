import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AvailableRoomsScreen.dart';
import 'login_screen.dart';
import 'ServicesSection.dart';
import 'RoomsSection.dart';
import 'AditionalServicesSection.dart';
import 'FooterSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange; // Rango de fechas seleccionado
  int numberOfGuests = 1; // Número de huéspedes
  Map<String, dynamic>? user; // Usuario autenticado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Hotel Paraiso'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          TextButton(
            onPressed: () async {
              final loggedInUser = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );

              if (loggedInUser != null) {
                setState(() {
                  user = loggedInUser;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bienvenido ${user!['first_name']}'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: Text(user == null ? 'Iniciar Sesión' : 'Cerrar Sesión'),
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
              onSearchRooms: () {
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Debes iniciar sesión para continuar')),
                  );
                  return;
                }

                if (selectedDateRange == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor selecciona un rango de fechas.')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvailableRoomsScreen(
                      selectedDateRange: selectedDateRange!,
                      numberOfGuests: numberOfGuests,
                      user: user!,
                    ),
                  ),
                );
              },
              selectedDateRange: selectedDateRange,
              numberOfGuests: numberOfGuests,
            ),
            const ServicesSection(),
            const AdditionalServicesSection(),
            const RoomsSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Function(DateTimeRange) onDateRangeSelected;
  final Function(int) onGuestsChanged;
  final VoidCallback onSearchRooms; // Callback para el botón
  final DateTimeRange? selectedDateRange;
  final int numberOfGuests;

  const HeaderSection({
    super.key,
    required this.onDateRangeSelected,
    required this.onGuestsChanged,
    required this.onSearchRooms, // Callback para el botón
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
                'Bienvenido a Hotel Paraiso',
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
              // Selector de Fechas
              DateSelector(
                selectedDateRange: selectedDateRange,
                onDateRangeSelected: onDateRangeSelected,
              ),
              const SizedBox(height: 16.0),
              // Selector de Huéspedes
              GuestsSelector(
                numberOfGuests: numberOfGuests,
                onGuestsChanged: onGuestsChanged,
              ),
              const SizedBox(height: 16.0),
              // Botón de Buscar Habitaciones
              ElevatedButton(
                onPressed: onSearchRooms,
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
          const Text('Cantidad de Huéspedes', style: TextStyle(fontSize: 16, color: Colors.black87)),
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

class BottomActionButtons extends StatelessWidget {
  final VoidCallback onSearchRooms;

  const BottomActionButtons({
    super.key,
    required this.onSearchRooms,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: onSearchRooms,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Buscar Habitaciones'),
          ),
        ],
      ),
    );
  }
}
