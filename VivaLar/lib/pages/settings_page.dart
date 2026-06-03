import 'package:flutter/material.dart';
import '../models/app_state.dart';

class SettingsPage extends StatefulWidget {
  final AppStateData appState;
  const SettingsPage({super.key, required this.appState});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _emailPromo = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.themeMode == ThemeMode.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          _SettingsSection('Aparência'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo Escuro'),
            subtitle: const Text('Tema escuro para o aplicativo'),
            value: isDark,
            onChanged: (_) {
              widget.appState.toggleTheme();
              setState(() {});
            },
            activeColor: primary,
          ),
          _SettingsSection('Notificações'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notificações Push'),
            subtitle: const Text('Atualizações de pedidos e ofertas'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            activeColor: primary,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text('E-mails Promocionais'),
            subtitle: const Text('Receba ofertas exclusivas por e-mail'),
            value: _emailPromo,
            onChanged: (v) => setState(() => _emailPromo = v),
            activeColor: primary,
          ),
          _SettingsSection('Conta'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Alterar Senha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Excluir Conta',
                style: TextStyle(color: Colors.red)),
            trailing:
                const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  const _SettingsSection(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1),
      ),
    );
  }
}
