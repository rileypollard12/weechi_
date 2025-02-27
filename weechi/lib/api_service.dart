import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/vehicle.dart';

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
      return _token!;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Vehicle>> fetchVehicles() async {
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
}