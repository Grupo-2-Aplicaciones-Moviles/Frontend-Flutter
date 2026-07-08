import 'package:flutter/material.dart';

import '../../core/theme.dart';

class ProblemReportScreen extends StatefulWidget {
  const ProblemReportScreen({super.key});

  @override
  State<ProblemReportScreen> createState() => _ProblemReportScreenState();
}

class _ProblemReportScreenState extends State<ProblemReportScreen> {
  final TextEditingController _detailsCtrl = TextEditingController();
  String? _selectedReason;

  final List<String> _reasons = [
    'Falla mecánica',
    'Batería',
    'Accidente',
    'Aplicación',
    'Bloqueo',
  ];

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  void _attachPhoto() {
    // Placeholder: integrar image_picker o similar si se desea más adelante.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Adjuntar foto (no implementado en este demo)'),
    ));
  }

  void _sendReport() {
    final reason = _selectedReason ?? 'No especificado';
    final details = _detailsCtrl.text.trim();
    // Aquí enviarías al backend el reporte.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reporte enviado'),
        content: Text('Motivo: $reason\n\nDetalles: ${details.isEmpty ? '—' : details}'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar problema')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '¿Encontraste algún problema?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _reasons.map((r) {
              final selected = r == _selectedReason;
              return ChoiceChip(
                label: Text(r),
                selected: selected,
                selectedColor: WeRideColors.energyGreen,
                backgroundColor: const Color(0xFF1E1E1E),
                labelStyle: TextStyle(
                    color: selected ? WeRideColors.black : WeRideColors.white),
                onSelected: (_) => setState(() => _selectedReason = selected ? null : r),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Información adicional',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _detailsCtrl,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Describe lo ocurrido...'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _attachPhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Adjuntar foto'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 48),
                  foregroundColor: WeRideColors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendReport,
                  child: const Text('Enviar reporte'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

