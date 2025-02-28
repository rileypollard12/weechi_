import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/vehicle.dart';
import 'models/vehicle_booking.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api'; // Update this to your Django backend URL
  static final ApiService _instance = ApiService._internal();
  String? _token;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<void> setToken(String token) async {
    _token = token;
    print('Token set: $_token'); // ADD THIS LINE
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      _token = responseData['token'];
      print('Token received: $_token'); // ADD THIS LINE
      return _token!;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Vehicle>> fetchVehicles() async {
    print('Fetching vehicles with token: $_token'); // ADD THIS LINE
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<void> createVehicleBooking(Map<String, dynamic> bookingData) async {
    print('Creating booking with token: $_token'); // ADD THIS LINE
    final response = await http.post(
      Uri.parse('$baseUrl/vehicle_booking/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create vehicle booking: ${response.body}');
    }
  }

  Future<List<VehicleBooking>> fetchMyBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicle_booking/my_bookings/'), // Corrected URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((booking) => VehicleBooking.fromJson(booking)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<bool> checkVehicleAvailability(Map<String, dynamic> availabilityData) async {
    print('Availability data being sent: $availabilityData'); // Add this line
    final response = await http.post(
      Uri.parse('$baseUrl/check_availability/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
      body: jsonEncode({
        'vehicle_id': availabilityData['vehicle_id'] is int ? availabilityData['vehicle_id'] : int.parse(availabilityData['vehicle_id'].toString()), // Ensure vehicle_id is an integer
        'start_date': availabilityData['start_date'],
        'end_date': availabilityData['end_date'],
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['available'];
    } else {
      throw Exception('Failed to check vehicle availability: ${response.body}');
    }
  }
}