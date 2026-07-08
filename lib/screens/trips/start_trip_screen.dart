import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import 'rating_trip_screen.dart';
import 'problem_report_screen.dart';

class StartTripScreen extends StatefulWidget {
  final Booking booking;

  const StartTripScreen({super.key, required this.booking});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // En una implementación real aquí podrías llamar al backend para poner status=active
  }

  void _finishTrip() async {
    final duration = DateTime.now().difference(_startTime);
    final kilometers = widget.booking.distance ?? 0.0;
    final cost = widget.booking.finalCost ?? widget.booking.totalCost ?? 0.0;

    // Navegar a la pantalla de calificación y pasar bookingId para que se marque como realizado al enviar/omitir
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RatingTripScreen(
        kilometers: kilometers,
        duration: duration,
        cost: cost,
        bookingId: widget.booking.bookingId,
      ),
    ));
  }

  void _reportProblem() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const ProblemReportScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Viaje en curso')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reserva #${widget.booking.bookingId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Vehículo #${widget.booking.vehicleId}', style: const TextStyle(color: WeRideColors.mediumGray)),
            const SizedBox(height: 20),
            const Text('Duración del viaje', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Empezó: ${_startTime.toLocal()}'),
            const SizedBox(height: 20),
            Expanded(child: Container()),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _reportProblem,
                  icon: const Icon(Icons.report_problem_outlined),
                  label: const Text('Reportar problema'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finishTrip,
                    child: const Text('Finalizar viaje'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


