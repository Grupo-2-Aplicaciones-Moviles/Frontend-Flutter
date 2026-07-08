import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weride_flutter/screens/profile/presentation/PaymentMethodsView.dart';
import 'package:weride_flutter/screens/profile/presentation/PlansScreen.dart';
import 'package:weride_flutter/screens/profile/presentation/WalletScreen.dart';

import '../../core/theme.dart';
import '../../providers/providers.dart';
import '../auth/login_screen.dart';
import 'profile_sections.dart';
import 'wallet_screen.dart';
import 'plans_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir',
                  style: TextStyle(color: WeRideColors.errorRed))),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    await context.read<AuthProvider>().signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor:
                  WeRideColors.energyGreen.withOpacity(0.15),
              child: const Icon(Icons.person,
                  size: 56, color: WeRideColors.energyGreen),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              auth.email ?? 'Usuario WeRide',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'ID: ${auth.userId ?? '-'}',
              style: const TextStyle(
                  color: WeRideColors.mediumGray, fontSize: 13),
            ),
          ),
          const SizedBox(height: 28),
          _SectionCard(items: [
            (
              Icons.account_balance_wallet_outlined,
              'Billetera',
              () => _open(context, const WalletScreen())
            ),
            (
              Icons.card_membership_outlined,
              'Planes',
              () => _open(context, const PlansScreen())
            ),
            (
              Icons.payment_outlined,
              'Métodos de pago',
              () => _open(context, const PaymentMethodsScreen())
            ),
          ]),
          const SizedBox(height: 16),
          _SectionCard(items: [
            (
              Icons.settings_outlined,
              'Configuración',
              () => _open(context, const SettingsScreen())
            ),
            (
              Icons.help_outline,
              'Ayuda',
              () => _open(context, const HelpScreen())
            ),
            (
              Icons.info_outline,
              'Acerca de WeRide',
              () => _open(context, const AboutScreen())
            ),
          ]),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _signOut(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: WeRideColors.errorRed,
              side: const BorderSide(color: WeRideColors.errorRed),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<(IconData, String, VoidCallback)> items;
  const _SectionCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ListTile(
              leading:
                  Icon(items[i].$1, color: WeRideColors.energyGreen),
              title: Text(items[i].$2),
              trailing: const Icon(Icons.chevron_right,
                  color: WeRideColors.mediumGray),
              onTap: items[i].$3,
            ),
            if (i < items.length - 1)
              const Divider(height: 1, color: Color(0xFF2A2A2A)),
          ],
        ],
      ),
    );
  }
}
