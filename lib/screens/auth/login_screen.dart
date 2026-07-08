import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/providers.dart';
import '../main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isRegister = false;
  bool _obscure = true;
  bool _acceptedTerms = false;

  Future<void> _openTerms() async {
    final uri = Uri.parse(AppConstants.termsAndConditionsUrl);
    final opened = await launchUrl(uri, mode: LaunchMode.inAppWebView);
    if (!mounted) return;
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo abrir los Términos y Condiciones'),
        backgroundColor: WeRideColors.errorRed,
      ));
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isRegister && !_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Debes aceptar los Términos y Condiciones'),
        backgroundColor: WeRideColors.errorRed,
      ));
      return;
    }
    final auth = context.read<AuthProvider>();
    final ok = _isRegister
        ? await auth.signUp(_userCtrl.text.trim(), _passCtrl.text)
        : await auth.signIn(_userCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShell()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.error ?? 'Error de autenticación'),
        backgroundColor: WeRideColors.errorRed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.electric_scooter,
                      size: 64, color: WeRideColors.energyGreen),
                  const SizedBox(height: 12),
                  Text(
                    _isRegister ? 'Crea tu cuenta' : 'Bienvenido de vuelta',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRegister
                        ? 'Regístrate para empezar a rodar'
                        : 'Inicia sesión para continuar',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: WeRideColors.mediumGray),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _userCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Correo o usuario',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa tu usuario'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Mínimo 6 caracteres'
                        : null,
                  ),
                  if (_isRegister) ...[
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: WeRideColors.energyGreen,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _acceptedTerms = !_acceptedTerms),
                            child: Text.rich(
                              TextSpan(
                                text: 'Acepto los ',
                                style: const TextStyle(
                                    color: WeRideColors.mediumGray),
                                children: [
                                  TextSpan(
                                    text: 'Términos y Condiciones',
                                    style: const TextStyle(
                                      color: WeRideColors.energyGreen,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _openTerms,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: (auth.isLoading ||
                            (_isRegister && !_acceptedTerms))
                        ? null
                        : _submit,
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: WeRideColors.black))
                        : Text(_isRegister ? 'Registrarse' : 'Iniciar sesión'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() {
                      _isRegister = !_isRegister;
                      _acceptedTerms = false;
                    }),
                    child: Text(
                      _isRegister
                          ? '¿Ya tienes cuenta? Inicia sesión'
                          : '¿No tienes cuenta? Regístrate',
                      style:
                          const TextStyle(color: WeRideColors.energyGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
