import 'package:flutter/material.dart';

import '../../core/theme.dart';

// ===========================================================================
// MÉTODOS DE PAGO
// ===========================================================================

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<(IconData, String, String)> _methods = [
    (Icons.credit_card, 'Visa •••• 4589', 'Vence 08/27'),
    (Icons.phone_android, 'Yape', '+51 9** *** 167'),
  ];

  void _addMethod() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Agregar método de pago',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          for (final option in [
            (Icons.credit_card, 'Tarjeta de crédito/débito'),
            (Icons.phone_android, 'Yape'),
            (Icons.phone_iphone, 'Plin'),
          ])
            ListTile(
              leading: Icon(option.$1, color: WeRideColors.energyGreen),
              title: Text(option.$2),
              onTap: () {
                Navigator.pop(ctx);
                setState(() =>
                    _methods.add((option.$1, option.$2, 'Agregado (demo)')));
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Métodos de pago')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: WeRideColors.energyGreen,
        foregroundColor: WeRideColors.black,
        onPressed: _addMethod,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (int i = 0; i < _methods.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(_methods[i].$1,
                    color: WeRideColors.energyGreen),
                title: Text(_methods[i].$2),
                subtitle: Text(_methods[i].$3,
                    style: const TextStyle(
                        color: WeRideColors.mediumGray, fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: WeRideColors.errorRed),
                  onPressed: () => setState(() => _methods.removeAt(i)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CONFIGURACIÓN (espejo de SettingsScreen.kt)
// ===========================================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _pushNotifications = true;
  bool _emailMarketing = false;
  bool _location = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('General'),
          SwitchListTile(
            value: _darkMode,
            activeColor: WeRideColors.energyGreen,
            title: const Text('Modo oscuro'),
            subtitle: const Text('Activar tema oscuro',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          const ListTile(
            title: Text('Idioma'),
            subtitle: Text('Español (Perú)',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            trailing: Text('Español',
                style: TextStyle(color: WeRideColors.energyGreen)),
          ),
          const ListTile(
            title: Text('Moneda'),
            subtitle: Text('Soles peruanos',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            trailing:
                Text('PEN', style: TextStyle(color: WeRideColors.energyGreen)),
          ),
          const _SectionHeader('Notificaciones'),
          SwitchListTile(
            value: _pushNotifications,
            activeColor: WeRideColors.energyGreen,
            title: const Text('Notificaciones push'),
            subtitle: const Text('Recibir alertas de viajes',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          SwitchListTile(
            value: _emailMarketing,
            activeColor: WeRideColors.energyGreen,
            title: const Text('Marketing por email'),
            subtitle: const Text('Ofertas y promociones',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            onChanged: (v) => setState(() => _emailMarketing = v),
          ),
          const _SectionHeader('Privacidad'),
          SwitchListTile(
            value: _location,
            activeColor: WeRideColors.energyGreen,
            title: const Text('Ubicación'),
            subtitle: const Text('Permitir acceso a ubicación',
                style: TextStyle(color: WeRideColors.mediumGray, fontSize: 12)),
            onChanged: (v) => setState(() => _location = v),
          ),
          const ListTile(
            leading: Icon(Icons.description_outlined,
                color: WeRideColors.mediumGray),
            title: Text('Términos y condiciones'),
            trailing:
                Icon(Icons.chevron_right, color: WeRideColors.mediumGray),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined,
                color: WeRideColors.mediumGray),
            title: Text('Política de privacidad'),
            trailing:
                Icon(Icons.chevron_right, color: WeRideColors.mediumGray),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(title,
          style: const TextStyle(
              color: WeRideColors.energyGreen,
              fontWeight: FontWeight.bold,
              fontSize: 13)),
    );
  }
}

// ===========================================================================
// AYUDA (Centro de ayuda + contacto)
// ===========================================================================

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      '¿Cómo reservo un vehículo?',
      'Desde el Home, selecciona un vehículo disponible, revisa sus detalles y presiona "Reservar ahora" o "Programar" para agendar una fecha futura.'
    ),
    (
      '¿Cómo se calcula el costo del viaje?',
      'El costo se calcula multiplicando el precio por minuto del vehículo por la duración de tu reserva. Los planes de suscripción aplican descuentos adicionales.'
    ),
    (
      '¿Puedo cancelar una reserva?',
      'Sí. En la sección "Mis viajes" puedes cancelar cualquier reserva que aún no haya iniciado, sin penalidad.'
    ),
    (
      '¿Qué métodos de pago aceptan?',
      'Aceptamos billetera WeRide, tarjetas de crédito/débito, Yape y Plin.'
    ),
    (
      '¿Qué hago si el vehículo presenta una falla?',
      'Repórtalo desde la app o escríbenos a soporte@weride.pe. Nuestro equipo lo atenderá y no se te cobrará el viaje afectado.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Centro de ayuda')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Preguntas frecuentes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ..._faqs.map((faq) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  title: Text(faq.$1, style: const TextStyle(fontSize: 14)),
                  iconColor: WeRideColors.energyGreen,
                  collapsedIconColor: WeRideColors.mediumGray,
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(faq.$2,
                        style: const TextStyle(
                            color: WeRideColors.mediumGray, fontSize: 13)),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.email, color: WeRideColors.energyGreen),
              title: const Text('Contactar soporte'),
              subtitle: const Text('soporte@weride.pe',
                  style: TextStyle(color: WeRideColors.mediumGray)),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Escríbenos a soporte@weride.pe'))),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// ACERCA DE WERIDE
// ===========================================================================

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de WeRide')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Icon(Icons.electric_scooter,
                size: 72, color: WeRideColors.energyGreen),
          ),
          const SizedBox(height: 12),
          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: WeRideColors.white),
                children: [
                  TextSpan(text: 'We'),
                  TextSpan(
                      text: 'Ride',
                      style: TextStyle(color: WeRideColors.energyGreen)),
                ],
              ),
            ),
          ),
          const Center(
            child: Text('Versión 1.0.0 (Flutter)',
                style: TextStyle(color: WeRideColors.mediumGray)),
          ),
          const SizedBox(height: 24),
          const Text(
            'WeRide es una plataforma de micromovilidad eléctrica que permite '
            'reservar scooters, bicicletas y motocicletas eléctricas de manera '
            'rápida, segura y sostenible en Lima, Perú.',
            textAlign: TextAlign.center,
            style: TextStyle(color: WeRideColors.mediumGray, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Desarrollado por WeTech',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Grupo 2 — Aplicaciones Móviles\nUPC · 2026',
                      style: TextStyle(
                          color: WeRideColors.mediumGray, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
