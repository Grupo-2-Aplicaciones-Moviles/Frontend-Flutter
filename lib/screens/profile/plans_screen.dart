import 'package:flutter/material.dart';

import '../../core/theme.dart';

class _Plan {
  final String id;
  final String name;
  final String description;
  final double price;
  final double pricePerMinute;
  final int discount;
  final int freeMinutes;
  final List<String> benefits;
  final bool popular;

  const _Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.pricePerMinute,
    required this.discount,
    required this.freeMinutes,
    required this.benefits,
    this.popular = false,
  });
}

const _plans = [
  _Plan(
    id: 'normal',
    name: 'Plan Normal',
    description: 'Ideal para usuarios ocasionales que buscan una opción económica',
    price: 3.99,
    pricePerMinute: 0.6,
    discount: 10,
    freeMinutes: 30,
    benefits: [
      'Acceso a scooters estándar',
      '10% de descuento en cada viaje',
      'Soporte básico al cliente',
      '30 minutos gratis al mes',
    ],
  ),
  _Plan(
    id: 'student',
    name: 'Plan Estudiante',
    description: 'Perfecto para estudiantes que necesitan movilidad frecuente',
    price: 5.99,
    pricePerMinute: 0.4,
    discount: 20,
    freeMinutes: 60,
    popular: true,
    benefits: [
      'Acceso a scooters premium',
      '20% de descuento en cada viaje',
      'Soporte prioritario al cliente',
      'Viajes ilimitados los fines de semana',
      '60 minutos gratis al mes',
    ],
  ),
  _Plan(
    id: 'business',
    name: 'Plan Business',
    description: 'Solución completa para profesionales y empresas',
    price: 9.99,
    pricePerMinute: 0.3,
    discount: 30,
    freeMinutes: 120,
    benefits: [
      'Acceso a todos los vehículos',
      '30% de descuento en cada viaje',
      'Soporte prioritario 24/7',
      'Viajes ilimitados',
      '120 minutos gratis al mes',
      'Reportes mensuales',
      'Facturación centralizada',
    ],
  ),
];

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  void _subscribe(BuildContext context, _Plan plan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle,
            color: WeRideColors.successGreen, size: 56),
        title: Text('¡Suscrito al ${plan.name}!'),
        content: Text(
            'Se cargará S/ ${plan.price.toStringAsFixed(2)} mensualmente. '
            'Ya tienes ${plan.freeMinutes} minutos gratis este mes.'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planes de suscripción')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Elige tu plan ideal',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Cancela cuando quieras. Sin compromisos.',
              style: TextStyle(color: WeRideColors.mediumGray)),
          const SizedBox(height: 20),
          ..._plans.map((plan) => _PlanCard(
                plan: plan,
                onSubscribe: () => _subscribe(context, plan),
              )),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final VoidCallback onSubscribe;
  const _PlanCard({required this.plan, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: plan.popular
            ? Border.all(color: WeRideColors.energyGreen, width: 1.5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (plan.popular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: WeRideColors.energyGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Popular',
                        style: TextStyle(
                            color: WeRideColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(plan.description,
                style: const TextStyle(
                    color: WeRideColors.mediumGray, fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('S/ ${plan.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: WeRideColors.energyGreen)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4, left: 4),
                  child: Text('/mes',
                      style: TextStyle(color: WeRideColors.mediumGray)),
                ),
                const Spacer(),
                Text('S/ ${plan.pricePerMinute}/min',
                    style: const TextStyle(
                        color: WeRideColors.mediumGray, fontSize: 13)),
              ],
            ),
            const Divider(height: 24, color: Color(0xFF2A2A2A)),
            ...plan.benefits.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check,
                          color: WeRideColors.energyGreen, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(b,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: plan.popular
                  ? ElevatedButton(
                      onPressed: onSubscribe,
                      child: const Text('Suscribirme'))
                  : OutlinedButton(
                      onPressed: onSubscribe,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: WeRideColors.energyGreen,
                        side: const BorderSide(
                            color: WeRideColors.energyGreen),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Suscribirme')),
            ),
          ],
        ),
      ),
    );
  }
}
