import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '../vehicle/vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<VehicleProvider>().loadVehicles());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            children: [
              TextSpan(text: 'We', style: TextStyle(color: WeRideColors.white)),
              TextSpan(
                  text: 'Ride',
                  style: TextStyle(color: WeRideColors.energyGreen)),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        color: WeRideColors.energyGreen,
        onRefresh: () => provider.loadVehicles(),
        child: Column(
          children: [
            _FilterChips(
              selected: provider.typeFilter,
              onSelected: provider.setFilter,
            ),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(VehicleProvider provider) {
    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: WeRideColors.energyGreen));
    }
    if (provider.error != null) {
      return _ErrorView(
        message: provider.error!,
        onRetry: provider.loadVehicles,
      );
    }
    final vehicles = provider.filtered;
    if (vehicles.isEmpty) {
      return const Center(
        child: Text('No hay vehículos disponibles',
            style: TextStyle(color: WeRideColors.mediumGray)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicles.length,
      itemBuilder: (context, i) => _VehicleCard(vehicle: vehicles[i]),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;
  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final filters = <(String?, String, IconData)>[
      (null, 'Todos', Icons.grid_view),
      (AppConstants.vehicleScooter, 'Scooters', Icons.electric_scooter),
      (AppConstants.vehicleBike, 'Bicicletas', Icons.pedal_bike),
      (AppConstants.vehicleMotorcycle, 'Motos', Icons.two_wheeler),
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (value, label, icon) = filters[i];
          final isSelected = selected == value;
          return FilterChip(
            avatar: Icon(icon,
                size: 18,
                color: isSelected
                    ? WeRideColors.black
                    : WeRideColors.mediumGray),
            label: Text(label),
            selected: isSelected,
            selectedColor: WeRideColors.energyGreen,
            backgroundColor: const Color(0xFF1E1E1E),
            labelStyle: TextStyle(
                color:
                    isSelected ? WeRideColors.black : WeRideColors.white),
            onSelected: (_) => onSelected(value),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  const _VehicleCard({required this.vehicle});

  IconData get _typeIcon => switch (vehicle.type.toLowerCase()) {
        'bike' => Icons.pedal_bike,
        'motorcycle' => Icons.two_wheeler,
        _ => Icons.electric_scooter,
      };

  Color get _batteryColor => vehicle.batteryPercent > 50
      ? WeRideColors.successGreen
      : vehicle.batteryPercent > 20
          ? WeRideColors.warningOrange
          : WeRideColors.errorRed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(vehicleId: vehicle.id))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: WeRideColors.energyGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_typeIcon,
                    color: WeRideColors.energyGreen, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.displayName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.typeDisplayName(vehicle.type)} · ${vehicle.location}',
                      style: const TextStyle(
                          color: WeRideColors.mediumGray, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.battery_full,
                            size: 16, color: _batteryColor),
                        Text(' ${vehicle.batteryPercent}%',
                            style: TextStyle(
                                color: _batteryColor, fontSize: 13)),
                        const SizedBox(width: 12),
                        const Icon(Icons.speed,
                            size: 16, color: WeRideColors.mediumGray),
                        Text(' ${vehicle.maxSpeed} km/h',
                            style: const TextStyle(
                                color: WeRideColors.mediumGray,
                                fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'S/ ${vehicle.pricePerMinute.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: WeRideColors.energyGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const Text('/min',
                      style: TextStyle(
                          color: WeRideColors.mediumGray, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: vehicle.isAvailable
                          ? WeRideColors.successGreen.withOpacity(0.15)
                          : WeRideColors.errorRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehicle.isAvailable ? 'Disponible' : 'Ocupado',
                      style: TextStyle(
                          fontSize: 11,
                          color: vehicle.isAvailable
                              ? WeRideColors.successGreen
                              : WeRideColors.errorRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off,
                size: 48, color: WeRideColors.mediumGray),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: WeRideColors.mediumGray)),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
