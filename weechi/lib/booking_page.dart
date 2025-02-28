import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/vehicle.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final Vehicle vehicle;

  const BookingPage({super.key, required this.vehicle});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _purposeController = TextEditingController();
  bool _isVehicleAvailable = true; // Track vehicle availability
  String _availabilityMessage = ''; // Display availability message

  @override
  void initState() {
    super.initState();
    print('BookingPage received vehicle ID: ${widget.vehicle.id}');
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timeOfDay != null) {
        setState(() {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
          _checkAvailability(); // Check availability after setting start date
        });
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timeOfDay != null) {
        setState(() {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
          _checkAvailability(); // Check availability after setting end date
        });
      }
    }
  }

  Future<void> _checkAvailability() async {
    if (_startDate == null || _endDate == null) {
      setState(() {
        _isVehicleAvailable = true;
        _availabilityMessage = 'Please select start and end dates.';
      });
      return;
    }

    try {
      // Format the dates to ISO 8601 format
      String formattedStartDate = _startDate!.toIso8601String();
      String formattedEndDate = _endDate!.toIso8601String();

      // Prepare the availability data
      Map<String, dynamic> availabilityData = {
        'vehicle_id': widget.vehicle.id, // Corrected line
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
      };

      // Call the API service to check availability
      bool isAvailable = await ApiService().checkVehicleAvailability(availabilityData);

      setState(() {
        _isVehicleAvailable = isAvailable;
        _availabilityMessage = isAvailable
            ? 'Vehicle is available for the selected dates.'
            : 'Vehicle is not available for the selected dates.';
      });
    } catch (e) {
      setState(() {
        _isVehicleAvailable = false;
        _availabilityMessage = 'Failed to check availability: $e';
      });
    }
  }

  Future<void> _bookVehicle() async {
    if (!_isVehicleAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle is not available for the selected dates.')),
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates.')),
      );
      return;
    }

    if (_purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a purpose for the booking.')),
      );
      return;
    }

    try {
      // Format the dates to ISO 8601 format
      String formattedStartDate = _startDate!.toIso8601String();
      String formattedEndDate = _endDate!.toIso8601String();

      // Prepare the booking data
      Map<String, dynamic> bookingData = {
        'vehicle': widget.vehicle.id,
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
        'purpose': _purposeController.text,
      };

      // Call the API service to create the booking
      await ApiService().createVehicleBooking(bookingData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle booked successfully!')),
      );

      // Navigate back to the vehicles page
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book vehicle: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${widget.vehicle.year} ${widget.vehicle.make} ${widget.vehicle.model}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_startDate == null
                  ? 'Select Start Date/Time'
                  : 'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(_startDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectStartDate(context),
            ),
            ListTile(
              title: Text(_endDate == null
                  ? 'Select End Date/Time'
                  : 'End: ${DateFormat('yyyy-MM-dd – kk:mm').format(_endDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectEndDate(context),
            ),
            TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose of Booking',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _availabilityMessage,
              style: TextStyle(
                color: _isVehicleAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVehicleAvailable ? _bookVehicle : null, // Disable button if not available
              child: const Text('Book Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}