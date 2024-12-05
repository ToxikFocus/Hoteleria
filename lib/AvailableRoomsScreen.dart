import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AvailableRoomsScreen extends StatefulWidget {
  final DateTimeRange selectedDateRange;
  final int numberOfGuests;
  final Map<String, dynamic> user;

  const AvailableRoomsScreen({
    super.key,
    required this.selectedDateRange,
    required this.numberOfGuests,
    required this.user,
  });

  @override
  _AvailableRoomsScreenState createState() => _AvailableRoomsScreenState();
}

class _AvailableRoomsScreenState extends State<AvailableRoomsScreen> {
  List<Map<String, dynamic>> availableRooms = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableRooms();
  }

  Future<void> _fetchAvailableRooms() async {
    final url = Uri.parse(
        'http://127.0.0.1/Hoteleria/search_rooms.php?guests=${widget.numberOfGuests}&check_in=${widget.selectedDateRange.start.toIso8601String()}&check_out=${widget.selectedDateRange.end.toIso8601String()}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          availableRooms = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las habitaciones: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectarse al servidor: $e')),
      );
    }
  }

  Future<void> _reserveRoom(Map<String, dynamic> room) async {
    final url = Uri.parse('http://127.0.0.1/Hoteleria/reserve_room.php');

    final body = json.encode({
      'guest_id': widget.user['id'],
      'room_id': room['id'],
      'check_in_date': widget.selectedDateRange.start.toIso8601String(),
      'check_out_date': widget.selectedDateRange.end.toIso8601String(),
      'number_of_guests': widget.numberOfGuests,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva realizada exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al reservar: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectarse al servidor: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitaciones Disponibles'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: availableRooms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: availableRooms.length,
        itemBuilder: (context, index) {
          final room = availableRooms[index];

          // Configurar las imágenes locales según el tipo de habitación
          final Map<String, String> localImages = {
            'Suite': 'assets/images/room1.jpg',
            'Doble': 'assets/images/room2.jpg',
            'Familiar': 'assets/images/room3.jpg',
            'Individual': 'assets/images/room4.png',
          };

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Usar imágenes locales
                Image.asset(
                  localImages[room['room_type']] ?? 'assets/images/room1.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['room_type'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${room['price']} por noche',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _reserveRoom(room),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                        child: const Text('Reservar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
