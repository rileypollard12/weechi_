class Vehicle {
  final String plate;
  final int year;
  final String make;
  final String model;
  final String color;
  final String vin;

  Vehicle({
    required this.plate,
    required this.year,
    required this.make,
    required this.model,
    required this.color,
    required this.vin,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      plate: json['plate'],
      year: json['year'],
      make: json['make'],
      model: json['model'],
      color: json['color'],
      vin: json['vin'],
    );
  }
}