import 'package:flutter/material.dart';

class PaymentMethodsView extends StatelessWidget{
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metodos de pago"),
      ),
      body: const Center(
        child: Text("pantallas de metodos de pago"),
      ),
    );
  }

  
}