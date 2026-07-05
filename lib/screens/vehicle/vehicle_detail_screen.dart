import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '../reservation/reservation_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late Future<Vehicle> _future;

  @override
  void initState() {
    super.initState();
    // Reutiliza el service ya inyectado en el VehicleProvider
    final service = context.read<VehicleProvider>().vehicleService;
    _future = service.getVehicleById(widget.vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del vehículo')),
      body: FutureBuilder<Vehicle>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: WeRideColors.energyGreen));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: WeRideColors.mediumGray)),
            );
          }
          final v = snapshot.data!;
          return _VehicleDetailBody(vehicle: v);
        },
      ),
    );
  }
}

class _VehicleDetailBody extends StatelessWidget {
  final Vehicle vehicle;
  const _VehicleDetailBody({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: WeRideColors.energyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  switch (vehicle.type.toLowerCase()) {
                    'bike' => Icons.pedal_bike,
                    'motorcycle' => Icons.two_wheeler,
                    _ => Icons.electric_scooter,
                  },
                  size: 96,
                  color: WeRideColors.energyGreen,
                ),
              ),
              const SizedBox(height: 20),
              Text(vehicle.displayName,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '${AppConstants.typeDisplayName(vehicle.type)} · ${vehicle.year} · ${vehicle.color}',
                style: const TextStyle(color: WeRideColors.mediumGray),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.4,
                children: [
                  _SpecTile(
                      icon: Icons.battery_full,
                      label: 'Batería',
                      value: '${vehicle.batteryPercent}%'),
                  _SpecTile(
                      icon: Icons.speed,
                      label: 'Vel. máx',
                      value: '${vehicle.maxSpeed} km/h'),
                  _SpecTile(
                      icon: Icons.route,
                      label: 'Autonomía',
                      value: '${vehicle.range} km'),
                  _SpecTile(
                      icon: Icons.scale,
                      label: 'Peso',
                      value: '${vehicle.weight} kg'),
                  _SpecTile(
                      icon: Icons.location_on,
                      label: 'Ubicación',
                      value: vehicle.location),
                  _SpecTile(
                      icon: Icons.confirmation_number,
                      label: 'Placa',
                      value: vehicle.licensePlate),
                ],
              ),
              if (vehicle.features != null &&
                  vehicle.features!.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Características',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vehicle.features!
                      .map((f) => Chip(
                            label: Text(f),
                            backgroundColor: const Color(0xFF1E1E1E),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'S/ ${vehicle.pricePerMinute.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: WeRideColors.energyGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('por minuto',
                        style: TextStyle(
                            color: WeRideColors.mediumGray, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: vehicle.isAvailable
                        ? () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                ReservationScreen(vehicle: vehicle)))
                        : null,
                    child: Text(vehicle.isAvailable
                        ? 'Reservar'
                        : 'No disponible'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SpecTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: WeRideColors.energyGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: WeRideColors.mediumGray, fontSize: 11)),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
