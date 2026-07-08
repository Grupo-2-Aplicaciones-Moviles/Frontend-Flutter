import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'start_trip_screen.dart';


import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final auth = context.read<AuthProvider>();
    if (auth.userId != null) {
      await context.read<BookingProvider>().loadUserBookings(auth.userId!);
    }
  }

  Color _statusColor(String status) => switch (status.toLowerCase()) {
        'active' => WeRideColors.energyGreen,
        'confirmed' => WeRideColors.infoBlue,
        'completed' => WeRideColors.successGreen,
        'cancelled' => WeRideColors.errorRed,
        _ => WeRideColors.mediumGray,
      };

  Future<void> _cancel(Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text('¿Cancelar la reserva #${booking.bookingId}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, cancelar',
                  style: TextStyle(color: WeRideColors.errorRed))),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final ok =
        await context.read<BookingProvider>().cancelBooking(booking.bookingId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Reserva cancelada' : 'No se pudo cancelar'),
      backgroundColor:
          ok ? WeRideColors.successGreen : WeRideColors.errorRed,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis viajes')),
      body: RefreshIndicator(
        color: WeRideColors.energyGreen,
        onRefresh: _load,
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(BookingProvider provider) {
    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: WeRideColors.energyGreen));
    }
    if (provider.error != null) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: WeRideColors.mediumGray)),
          ),
        ],
      );
    }
    if (provider.bookings.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Icon(Icons.route, size: 56, color: WeRideColors.mediumGray),
          SizedBox(height: 12),
          Center(
            child: Text('Aún no tienes viajes',
                style: TextStyle(color: WeRideColors.mediumGray)),
          ),
        ],
      );
    }

    final dateFmt = DateFormat('dd/MM/yyyy hh:mm a');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.bookings.length,
      itemBuilder: (context, i) {
        final b = provider.bookings[i];
        final status = b.status.toLowerCase();
        final canCancel = status == 'confirmed' || status == 'draft';
        final canStart = status == 'confirmed';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Reserva #${b.bookingId}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(b.status).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppConstants.statusDisplayName(b.status),
                        style: TextStyle(color: _statusColor(b.status), fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Vehículo #${b.vehicleId}',
                    style: const TextStyle(color: WeRideColors.mediumGray, fontSize: 13)),
                if (b.startDate != null)
                  Text(
                    'Inicio: ${dateFmt.format(DateTime.parse(b.startDate!))}',
                    style: const TextStyle(color: WeRideColors.mediumGray, fontSize: 13),
                  ),
                if (b.finalCost != null || b.totalCost != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Total: S/ ${(b.finalCost ?? b.totalCost)!.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: WeRideColors.energyGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (canCancel || canStart)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (canCancel)
                          TextButton(
                            onPressed: () => _cancel(b),
                            child: const Text('Cancelar',
                                style: TextStyle(color: WeRideColors.errorRed)),
                          ),
                        if (canCancel && canStart) const SizedBox(width: 8),
                        if (canStart)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StartTripScreen(booking: b),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WeRideColors.energyGreen,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Iniciar viaje'),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
