import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  final AppStateData appState;
  const CartPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    if (appState.cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('Seu carrinho está vazio',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Explore nossos produtos e adicione ao carrinho',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: appState.cart.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final id = appState.cart.keys.elementAt(index);
              final qty = appState.cart[id]!;
              final p = appState.productById(id);
              if (p == null) return const SizedBox.shrink();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.07),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: p.image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  p.image,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(p.thumbnail,
                                        style: const TextStyle(
                                            fontSize: 36)),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(p.thumbnail,
                                    style: const TextStyle(fontSize: 36)),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(
                              'R\$ ${p.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove,
                                              size: 14),
                                          onPressed: () =>
                                              appState.updateQty(
                                                  id, -1, context),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text('$qty',
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: IconButton(
                                          icon: const Icon(Icons.add,
                                              size: 14),
                                          onPressed: () =>
                                              appState.updateQty(
                                                  id, 1, context),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Total: R\$ ${(p.price * qty).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              )
            ],
          ),
          child: Column(
            children: [
              _summaryRow('Subtotal',
                  'R\$ ${appState.subtotal.toStringAsFixed(2)}'),
              _summaryRow(
                'Frete',
                appState.shipping == 0
                    ? 'Grátis 🎉'
                    : 'R\$ ${appState.shipping.toStringAsFixed(2)}',
                valueColor:
                    appState.shipping == 0 ? Colors.green : null,
              ),
              _summaryRow('Impostos (8%)',
                  'R\$ ${appState.taxes.toStringAsFixed(2)}'),
              const Divider(),
              _summaryRow(
                'Total',
                'R\$ ${appState.grandTotal.toStringAsFixed(2)}',
                bold: true,
                valueColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: appState.clearCart,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Esvaziar'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutPage(appState: appState),
                        ),
                      ),
                      child: const Text('Finalizar Compra'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : null,
                  color: valueColor,
                  fontSize: bold ? 16 : null)),
        ],
      ),
    );
  }
}
