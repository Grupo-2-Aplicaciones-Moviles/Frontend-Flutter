import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../providers/providers.dart';

class RatingTripScreen extends StatefulWidget {
  final double kilometers;
  final Duration duration;
  final double cost;
  final int? bookingId;

  const RatingTripScreen({
    super.key,
    required this.kilometers,
    required this.duration,
    required this.cost,
    this.bookingId,
  });

  @override
  State<RatingTripScreen> createState() => _RatingTripScreenState();
}

class _RatingTripScreenState extends State<RatingTripScreen> {
  int _stars = 0;
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submitRating() {
    final comment = _commentCtrl.text.trim();
    // Enviar calificación al backend o manejar localmente
    // Marcar reserva como 'realizado' localmente si se pasó bookingId
    if (widget.bookingId != null) {
      context.read<BookingProvider>().markBookingAsRealizado(widget.bookingId!);
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gracias'),
        content: Text('Has calificado con $_stars estrellas.\n\nComentario: ${comment.isEmpty ? '—' : comment}'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  void _skip() {
    // Si se omite, también marcar la reserva como 'realizado' localmente
    if (widget.bookingId != null) {
      context.read<BookingProvider>().markBookingAsRealizado(widget.bookingId!);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final hours = minutes ~/ 60;
    final remMin = minutes % 60;
    if (hours > 0) return '${hours}h ${remMin}m';
    return '${remMin} min';
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#0.0');
    return Scaffold(
      appBar: AppBar(title: const Text('Viaje completado')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumen del viaje', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Km recorridos', style: TextStyle(color: WeRideColors.mediumGray)),
                          const SizedBox(height: 6),
                          Text('${numberFormat.format(widget.kilometers)} km', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Duración', style: TextStyle(color: WeRideColors.mediumGray)),
                          const SizedBox(height: 6),
                          Text(_formatDuration(widget.duration), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Costo', style: TextStyle(color: WeRideColors.mediumGray)),
                          const SizedBox(height: 6),
                          Text('S/ ${numberFormat.format(widget.cost)}', style: const TextStyle(fontWeight: FontWeight.bold, color: WeRideColors.energyGreen)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('¿Cómo fue tu experiencia?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final index = i + 1;
              final filled = index <= _stars;
              return IconButton(
                onPressed: () => setState(() => _stars = index),
                icon: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: filled ? WeRideColors.starYellow : WeRideColors.mediumGray,
                  size: 36,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(hintText: 'Escribe un comentario (opcional)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _stars == 0 ? null : _submitRating,
            child: const Text('Enviar calificación'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _skip,
            style: TextButton.styleFrom(foregroundColor: WeRideColors.mediumGray),
            child: const Text('Omitir'),
          ),
        ],
      ),
    );
  }
}

