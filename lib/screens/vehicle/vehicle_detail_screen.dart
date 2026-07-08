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
    final service = context.read<VehicleProvider>().vehicleService;
    _future = service.getVehicleById(widget.vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del vehículo')),
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
          return _VehicleDetailBody(vehicle: snapshot.data!);
        },
      ),
    );
  }
}

class _VehicleDetailBody extends StatelessWidget {
  final Vehicle vehicle;
  const _VehicleDetailBody({required this.vehicle});

  IconData get _typeIcon => switch (vehicle.type.toLowerCase()) {
        'bike' => Icons.pedal_bike,
        'motorcycle' => Icons.two_wheeler,
        _ => Icons.electric_scooter,
      };

  double get _estimatedCost30 => vehicle.pricePerMinute * 30;

  void _goToReservation(BuildContext context, {required bool scheduled}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            ReservationScreen(vehicle: vehicle, scheduled: scheduled)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Imagen / ícono del vehículo
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: WeRideColors.energyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(_typeIcon,
                    size: 88, color: WeRideColors.energyGreen),
              ),
              const SizedBox(height: 16),

              // Nombre + tipo + rating
              Text(vehicle.displayName,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(AppConstants.typeDisplayName(vehicle.type),
                  style: const TextStyle(color: WeRideColors.mediumGray)),
              if (vehicle.rating != null) ...[
                const SizedBox(height: 6),
                _RatingStars(rating: vehicle.rating!),
              ],
              const SizedBox(height: 16),

              // Métricas rápidas: Batería / Rango / Vel. Máx
              Row(
                children: [
                  Expanded(
                      child: _MetricCard(
                          icon: Icons.battery_full,
                          label: 'Batería',
                          value: '${vehicle.batteryPercent}%')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _MetricCard(
                          icon: Icons.route,
                          label: 'Rango',
                          value: '${vehicle.range} km')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _MetricCard(
                          icon: Icons.speed,
                          label: 'Velocidad Máx',
                          value: '${vehicle.maxSpeed} km/h')),
                ],
              ),
              const SizedBox(height: 24),

              // Especificaciones (lista clave-valor como en el app Android)
              const Text('Especificaciones',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _SpecRow(label: 'Año', value: '${vehicle.year}'),
              _SpecRow(label: 'Peso', value: '${vehicle.weight} kg'),
              _SpecRow(label: 'Placa', value: vehicle.licensePlate),
              _SpecRow(label: 'Color', value: vehicle.color),
              if (vehicle.totalKilometers != null)
                _SpecRow(
                    label: 'Kilometraje',
                    value:
                        '${vehicle.totalKilometers!.toStringAsFixed(1)} km'),
              const SizedBox(height: 16),

              // Ubicación
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on,
                      color: WeRideColors.energyGreen),
                  title: const Text('Ubicación',
                      style: TextStyle(
                          color: WeRideColors.mediumGray, fontSize: 12)),
                  subtitle: Text(vehicle.location,
                      style: const TextStyle(
                          color: WeRideColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),

              // Precio por minuto + costo estimado (30 min)
              Card(
                color: WeRideColors.energyGreen.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Precio por minuto',
                              style: TextStyle(
                                  color: WeRideColors.mediumGray,
                                  fontSize: 12)),
                          Text(
                              'S/ ${vehicle.pricePerMinute.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: WeRideColors.energyGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Costo estimado (30 min)',
                              style: TextStyle(
                                  color: WeRideColors.mediumGray,
                                  fontSize: 12)),
                          Text('S/ ${_estimatedCost30.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: WeRideColors.energyGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (vehicle.features != null &&
                  vehicle.features!.isNotEmpty) ...[
                const SizedBox(height: 16),
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
              const SizedBox(height: 8),
            ],
          ),
        ),

        // Botones: Reservar ahora / Programar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: vehicle.isAvailable
                        ? () => _goToReservation(context, scheduled: false)
                        : null,
                    child: Text(vehicle.isAvailable
                        ? 'Reservar ahora'
                        : 'No disponible'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: vehicle.isAvailable
                        ? () => _goToReservation(context, scheduled: true)
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: WeRideColors.white,
                      side:
                          const BorderSide(color: WeRideColors.mediumGray),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Programar'),
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

class _RatingStars extends StatelessWidget {
  final double rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = rating >= i + 1;
          final half = !filled && rating > i;
          return Icon(
            filled
                ? Icons.star
                : half
                    ? Icons.star_half
                    : Icons.star_border,
            color: WeRideColors.starYellow,
            size: 20,
          );
        }),
        const SizedBox(width: 6),
        Text(rating.toStringAsFixed(1),
            style: const TextStyle(
                color: WeRideColors.mediumGray, fontSize: 14)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: WeRideColors.energyGreen, size: 22),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: WeRideColors.mediumGray, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: WeRideColors.energyGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: WeRideColors.mediumGray)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
