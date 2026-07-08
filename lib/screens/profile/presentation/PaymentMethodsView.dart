import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de pago'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Configura el método con el que deseas pagar tus reservas o recargar tu cuenta.',
            style: TextStyle(
              fontSize: 15,
              color: WeRideColors.mediumGray,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20),
          _PaymentMethodCard(
            icon: Icons.credit_card,
            title: 'Tarjeta',
            description:
                'Paga con tarjeta de débito o crédito de forma rápida y segura.',
            details: 'Visa · Mastercard · American Express',
            accentColor: WeRideColors.energyGreen,
          ),
          SizedBox(height: 12),
          _PaymentMethodCard(
            icon: Icons.qr_code_2,
            title: 'QR',
            description:
                'Escanea un código QR para completar el pago desde tu app bancaria.',
            details: 'Pago instantáneo',
            accentColor: WeRideColors.infoBlue,
          ),
          SizedBox(height: 12),
          _PaymentMethodCard(
            icon: Icons.payments_outlined,
            title: 'Efectivo',
            description:
                'Realiza el pago en efectivo cuando esté disponible en tu zona.',
            details: 'Sujeto a disponibilidad',
            accentColor: WeRideColors.warningOrange,
          ),
        ],
      ),
    );
  }
}


class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String details;
  final Color accentColor;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.details,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: WeRideColors.mediumGray,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}