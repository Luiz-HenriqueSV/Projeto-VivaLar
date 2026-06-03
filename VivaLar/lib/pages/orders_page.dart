import 'package:flutter/material.dart';
import '../models/app_state.dart';

class OrdersPage extends StatelessWidget {
  final AppStateData appState;
  const OrdersPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final hasOrder = appState.orderNumber != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: hasOrder
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.check_circle,
                          color: Colors.green),
                    ),
                    title: Text(appState.orderNumber!,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text(
                        'Pedido confirmado • Entrega em 5-10 dias'),
                    trailing: const Chip(label: Text('Confirmado')),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Você ainda não fez nenhum pedido',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Seus pedidos aparecerão aqui',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
    );
  }
}
