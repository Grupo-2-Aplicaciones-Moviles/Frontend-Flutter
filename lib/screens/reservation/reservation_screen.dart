import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';

class ReservationScreen extends StatefulWidget {
  final Vehicle vehicle;
  const ReservationScreen({super.key, required this.vehicle});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _startDate = DateTime.now().add(const Duration(minutes: 15));
  int _durationMinutes = 30;
  String _paymentMethod = AppConstants.paymentWallet;

  DateTime get _endDate =>
      _startDate.add(Duration(minutes: _durationMinutes));

  double get _estimatedCost =>
      widget.vehicle.pricePerMinute * _durationMinutes;

  Future<void> _pickStartDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startDate),
    );
    if (time == null) return;
    setState(() {
      _startDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _confirm() async {
    final auth = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();

    if (auth.userId == null) return;

    final request = CreateBookingRequest(
      userId: auth.userId!,
      vehicleId: int.tryParse(widget.vehicle.id) ?? 0,
      startDate: _startDate.toIso8601String(),
      endDate: _endDate.toIso8601String(),
      paymentMethod: _paymentMethod,
      status: 'CONFIRMED',
    );

    final booking = await bookingProvider.createBooking(request);
    if (!mounted) return;

    if (booking != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.check_circle,
              color: WeRideColors.successGreen, size: 56),
          title: const Text('¡Reserva confirmada!'),
          content: Text(
              'Tu ${AppConstants.typeDisplayName(widget.vehicle.type).toLowerCase()} '
              '${widget.vehicle.displayName} te espera.\n\n'
              'Reserva #${booking.bookingId}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pop();
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(bookingProvider.error ?? 'No se pudo crear la reserva'),
        backgroundColor: WeRideColors.errorRed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final dateFmt = DateFormat('dd/MM/yyyy · hh:mm a');

    return Scaffold(
      appBar: AppBar(title: const Text('Reservar')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.electric_scooter,
                  color: WeRideColors.energyGreen),
              title: Text(widget.vehicle.displayName),
              subtitle: Text(
                  'S/ ${widget.vehicle.pricePerMinute.toStringAsFixed(2)} /min'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Inicio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today,
                  color: WeRideColors.energyGreen),
              title: Text(dateFmt.format(_startDate)),
              trailing: const Icon(Icons.edit, size: 18),
              onTap: _pickStartDateTime,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Duración',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [15, 30, 60, 120].map((m) {
              final selected = _durationMinutes == m;
              return ChoiceChip(
                label: Text(m < 60 ? '$m min' : '${m ~/ 60} h'),
                selected: selected,
                selectedColor: WeRideColors.energyGreen,
                labelStyle: TextStyle(
                    color:
                        selected ? WeRideColors.black : WeRideColors.white),
                onSelected: (_) => setState(() => _durationMinutes = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Método de pago',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...[
            (AppConstants.paymentWallet, 'Billetera WeRide',
                Icons.account_balance_wallet),
            (AppConstants.paymentCard, 'Tarjeta', Icons.credit_card),
            (AppConstants.paymentYape, 'Yape', Icons.phone_android),
            (AppConstants.paymentPlin, 'Plin', Icons.phone_iphone),
          ].map((p) {
            final (value, label, icon) = p;
            return RadioListTile<String>(
              value: value,
              groupValue: _paymentMethod,
              activeColor: WeRideColors.energyGreen,
              title: Text(label),
              secondary: Icon(icon, color: WeRideColors.mediumGray),
              onChanged: (v) => setState(() => _paymentMethod = v!),
            );
          }),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Costo estimado',
                      style: TextStyle(color: WeRideColors.mediumGray)),
                  Text('S/ ${_estimatedCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: WeRideColors.energyGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: bookingProvider.isLoading ? null : _confirm,
            child: bookingProvider.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: WeRideColors.black))
                : const Text('Confirmar reserva'),
          ),
        ],
      ),
    );
  }
}
