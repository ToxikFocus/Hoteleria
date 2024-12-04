import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'RoomDetailsScreen.dart';

class AvailableRoomsScreen extends StatefulWidget {
  final DateTimeRange selectedDateRange;
  final int numberOfGuests;
  final Map<String, dynamic> user; // Información del usuario autenticado

  const AvailableRoomsScreen({
    super.key,
    required this.selectedDateRange,
    required this.numberOfGuests,
    required this.user, // Recibir al usuario como parámetro
  });

  @override
  _AvailableRoomsScreenState createState() => _AvailableRoomsScreenState();
}

class _AvailableRoomsScreenState extends State<AvailableRoomsScreen> {
  late Future<List<Map<String, dynamic>>> _availableRooms;

  @override
  void initState() {
    super.initState();
    _availableRooms = fetchAvailableRooms();
  }

  Future<List<Map<String, dynamic>>> fetchAvailableRooms() async {
    final String apiUrl = "http://127.0.0.1/Hoteleria/search_rooms.php";

    final response = await http.get(
      Uri.parse(
        "$apiUrl?guests=${widget.numberOfGuests}&check_in=${widget.selectedDateRange.start.toIso8601String().split('T')[0]}&check_out=${widget.selectedDateRange.end.toIso8601String().split('T')[0]}",
      ),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar habitaciones disponibles');
    }
  }

  Future<void> makeReservation({
    required int guestId,
    required int roomId,
    required String checkIn,
    required String checkOut,
    required int numberOfGuests,
    required double totalPrice,
  }) async {
    final String apiUrl = "http://<tu-direccion-ip>/Hoteleria/make_reservation.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'guest_id': guestId.toString(),
        'room_id': roomId.toString(),
        'check_in': checkIn,
        'check_out': checkOut,
        'number_of_guests': numberOfGuests.toString(),
        'total_price': totalPrice.toString(),
      },
    );

    final data = json.decode(response.body);
    if (data['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageMapping = {
      'Suite': 'assets/images/room1.jpg',
      'Doble': 'assets/images/room2.jpg',
      'Familiar': 'assets/images/room3.jpg',
      'Individual': 'assets/images/room2.jpg',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitaciones Disponibles'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _availableRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay habitaciones disponibles para estos criterios.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final imageUrl = imageMapping[room['room_type']] ??
                    'assets/images/hotel_banner.jpg';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(8.0)),
                            child: Image.asset(
                              imageUrl,
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
                                    room['room_type'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    '\$${room['price']} por noche',
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
                      ElevatedButton(
                        onPressed: () {
                          final totalPrice = double.parse(room['price']) *
                              widget.selectedDateRange.duration.inDays;

                          // Verifica que el usuario esté autenticado antes de proceder
                          if (widget.user['id'] != null) {
                            makeReservation(
                              guestId: widget.user['id'], // Usa el ID del usuario autenticado
                              roomId: room['id'],
                              checkIn: widget.selectedDateRange.start.toIso8601String().split('T')[0],
                              checkOut: widget.selectedDateRange.end.toIso8601String().split('T')[0],
                              numberOfGuests: widget.numberOfGuests,
                              totalPrice: totalPrice,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error: Usuario no autenticado')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Reservar'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
