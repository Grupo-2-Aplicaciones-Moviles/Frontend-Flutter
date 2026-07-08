import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';

class WalletTransaction {
  final String description;
  final double amount; // positivo = ingreso, negativo = gasto
  final DateTime date;
  const WalletTransaction(
      {required this.description, required this.amount, required this.date});
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 25.50;
  final List<WalletTransaction> _transactions = [
    WalletTransaction(
        description: 'Viaje - Xiaomi Mi Pro 2',
        amount: -4.50,
        date: DateTime.now().subtract(const Duration(days: 1))),
    WalletTransaction(
        description: 'Recarga',
        amount: 30.00,
        date: DateTime.now().subtract(const Duration(days: 3))),
  ];

  void _showAddFunds() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agregar fondos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Selecciona un monto:',
                style: TextStyle(color: WeRideColors.mediumGray)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [10, 20, 30, 50, 100].map((amount) {
                return ActionChip(
                  label: Text('S/ $amount'),
                  backgroundColor: const Color(0xFF262626),
                  labelStyle: const TextStyle(color: WeRideColors.white),
                  onPressed: () {
                    setState(() {
                      _balance += amount;
                      _transactions.insert(
                          0,
                          WalletTransaction(
                              description: 'Recarga',
                              amount: amount.toDouble(),
                              date: DateTime.now()));
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Se agregaron S/ $amount a tu billetera'),
                        backgroundColor: WeRideColors.successGreen));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Mi billetera')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Tarjeta de saldo
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  WeRideColors.energyGreen.withOpacity(0.25),
                  WeRideColors.energyGreen.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: WeRideColors.energyGreen.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponible',
                    style: TextStyle(color: WeRideColors.mediumGray)),
                const SizedBox(height: 6),
                Text('S/ ${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: WeRideColors.energyGreen)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showAddFunds,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar fondos'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Historial de transacciones',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('Sin transacciones\nAgrega fondos para comenzar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: WeRideColors.mediumGray)),
              ),
            )
          else
            ..._transactions.map((t) {
              final isIncome = t.amount > 0;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isIncome
                            ? WeRideColors.successGreen
                            : WeRideColors.errorRed)
                        .withOpacity(0.15),
                    child: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isIncome
                            ? WeRideColors.successGreen
                            : WeRideColors.errorRed,
                        size: 20),
                  ),
                  title: Text(t.description),
                  subtitle: Text(dateFmt.format(t.date),
                      style: const TextStyle(
                          color: WeRideColors.mediumGray, fontSize: 12)),
                  trailing: Text(
                    '${isIncome ? '+' : ''}S/ ${t.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isIncome
                            ? WeRideColors.successGreen
                            : WeRideColors.errorRed),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
