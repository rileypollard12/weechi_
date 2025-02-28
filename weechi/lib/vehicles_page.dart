import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/vehicle.dart';
import 'booking_page.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  late Future<List<Vehicle>> futureVehicles;

  @override
  void initState() {
    super.initState();
    futureVehicles = ApiService().fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: Center(
        child: FutureBuilder<List<Vehicle>>(
          future: futureVehicles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Vehicle> vehicles = snapshot.data!;
              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return VehicleCard(vehicle: vehicles[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

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
              '${vehicle.year} ${vehicle.make} ${vehicle.model}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Plate: ${vehicle.plate} - Color: ${vehicle.color}'),
            Text('VIN: ${vehicle.vin}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Vehicle ID being passed: ${vehicle.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(vehicle: vehicle),
                      ),
                    );
                  },
                  child: const Text('Book'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Implement check availability functionality
                  },
                  child: const Text('Check Availability'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
