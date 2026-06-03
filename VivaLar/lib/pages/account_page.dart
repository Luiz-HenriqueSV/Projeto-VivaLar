import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'orders_page.dart';
import 'settings_page.dart';
import 'login_page.dart';

class AccountPage extends StatelessWidget {
  final AppStateData appState;
  final void Function(int) onNavigate;

  const AccountPage(
      {super.key, required this.appState, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = appState.loggedInUser != null;
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: primary.withOpacity(0.15),
            child: isLoggedIn
                ? Text(appState.userName[0].toUpperCase(),
                    style: TextStyle(
                        fontSize: 32,
                        color: primary,
                        fontWeight: FontWeight.bold))
                : Icon(Icons.person_outline, size: 40, color: primary),
          ),
          const SizedBox(height: 12),
          Text(
            isLoggedIn
                ? appState.userName
                : 'Faça login para continuar',
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (isLoggedIn)
            Text(appState.userEmail,
                style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          if (!isLoggedIn) ...[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LoginPage(appState: appState)),
              ),
              child: const Text('Entrar na Conta'),
            ),
            const SizedBox(height: 24),
          ],
          _accountTile(context, Icons.shopping_bag_outlined, 'Meus Pedidos',
              'Acompanhe seus pedidos', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrdersPage(appState: appState)),
            );
          }),
          _accountTile(context, Icons.location_on_outlined,
              'Endereços Salvos', 'Gerencie seus endereços', () {}),
          _accountTile(context, Icons.credit_card_outlined,
              'Formas de Pagamento', 'Cartões e métodos salvos', () {}),
          _accountTile(
              context,
              Icons.favorite_outline,
              'Favoritos',
              '${appState.wishlist.length} itens salvos',
              () => onNavigate(1)),
          _accountTile(context, Icons.settings_outlined, 'Configurações',
              'Tema, notificações e mais', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SettingsPage(appState: appState)),
            );
          }),
          _accountTile(context, Icons.help_outline, 'Ajuda e Suporte',
              'Fale conosco', () {}),
          if (isLoggedIn) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair da Conta',
                    style: TextStyle(color: Colors.red)),
                onPressed: appState.logout,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _accountTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle:
            Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
