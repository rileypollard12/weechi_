import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/vehicle_booking.dart'; // Create this model
import 'package:intl/intl.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late Future<List<VehicleBooking>> futureBookings;

  @override
  void initState() {
    super.initState();
    futureBookings = ApiService().fetchMyBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: Center(
        child: FutureBuilder<List<VehicleBooking>>(
          future: futureBookings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<VehicleBooking> bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return BookingCard(booking: bookings[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final VehicleBooking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle ID: ${booking.vehicle}', // Display vehicle details
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Start Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDate)}'),
            Text('End Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endDate)}'),
            Text('Purpose: ${booking.purpose}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement edit booking functionality
                  },
                  child: const Text('Edit Booking'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Implement cancel booking functionality
                  },
                  child: const Text('Cancel Booking'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}