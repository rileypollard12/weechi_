class VehicleBooking {
  final int id;
  final int vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final String purpose;

  VehicleBooking({
    required this.id,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.purpose,
  });

  factory VehicleBooking.fromJson(Map<String, dynamic> json) {
    return VehicleBooking(
      id: json['id'],
      vehicle: json['vehicle'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      purpose: json['purpose'],
    );
  }
}