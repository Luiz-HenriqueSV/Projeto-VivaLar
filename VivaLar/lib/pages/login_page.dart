import 'package:flutter/material.dart';
import '../models/app_state.dart';

class LoginPage extends StatefulWidget {
  final AppStateData appState;
  const LoginPage({super.key, required this.appState});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isRegister = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Preencha todos os campos!'),
            backgroundColor: Colors.red),
      );
      return;
    }
    final name = _isRegister && _nameCtrl.text.isNotEmpty
        ? _nameCtrl.text
        : _emailCtrl.text.split('@')[0];
    widget.appState.login(name, _emailCtrl.text);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bem-vindo, $name! 👋'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar:
          AppBar(title: Text(_isRegister ? 'Criar Conta' : 'Entrar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home_outlined, color: primary, size: 48),
            ),
            const SizedBox(height: 16),
            const Text('VivaLar Store',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Móveis para o seu lar',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            if (_isRegister) ...[
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscure = !_obscure),
                ),
              ),
              obscureText: _obscure,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child:
                    Text(_isRegister ? 'Criar Conta' : 'Entrar'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  setState(() => _isRegister = !_isRegister),
              child: Text(_isRegister
                  ? 'Já tem conta? Entrar'
                  : 'Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
