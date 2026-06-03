import 'package:flutter/material.dart';
import '../models/app_state.dart';

class CheckoutPage extends StatefulWidget {
  final AppStateData appState;
  const CheckoutPage({super.key, required this.appState});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  String _paymentMethod = 'pix';
  int _step = 0;

  AppStateData get app => widget.appState;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cpfCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Compra')),
      body: app.orderNumber != null
          ? _buildSuccessScreen()
          : Stepper(
              currentStep: _step,
              onStepContinue: () {
                if (_step < 2) {
                  setState(() => _step++);
                } else {
                  _submitOrder();
                }
              },
              onStepCancel:
                  _step > 0 ? () => setState(() => _step--) : null,
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                          _step == 2 ? 'Confirmar Pedido' : 'Continuar'),
                    ),
                    if (_step > 0) ...[
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Voltar'),
                      ),
                    ],
                  ],
                ),
              ),
              steps: [
                Step(
                  title: const Text('Endereço de Entrega'),
                  isActive: _step >= 0,
                  state: _step > 0 ? StepState.complete : StepState.indexed,
                  content: Column(
                    children: [
                      TextField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Endereço completo',
                          hintText: 'Rua, número, bairro, cidade - UF',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _cpfCtrl,
                        decoration: const InputDecoration(
                          labelText: 'CPF',
                          hintText: '000.000.000-00',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Forma de Pagamento'),
                  isActive: _step >= 1,
                  state: _step > 1 ? StepState.complete : StepState.indexed,
                  content: Column(
                    children: [
                      _paymentOption(
                          'pix', '💠 PIX', 'Aprovação imediata'),
                      _paymentOption('credit', '💳 Cartão de Crédito',
                          'Até 10x sem juros'),
                      _paymentOption('boleto', '📄 Boleto Bancário',
                          'Vence em 3 dias'),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Resumo do Pedido'),
                  isActive: _step >= 2,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...app.cart.entries.map((e) {
                        final p = app.productById(e.key);
                        if (p == null) return const SizedBox.shrink();
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              if (p.image.isNotEmpty)
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.asset(
                                      p.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Text(p.thumbnail,
                                            style: const TextStyle(
                                                fontSize: 20)),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Text('${p.thumbnail} ',
                                    style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(p.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              Text('x${e.value}  '),
                              Text(
                                'R\$ ${(p.price * e.value).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      _checkoutSummaryRow('Subtotal', app.subtotal),
                      _checkoutSummaryRow('Frete', app.shipping),
                      _checkoutSummaryRow('Impostos', app.taxes),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(
                            'R\$ ${app.grandTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _paymentOption(String value, String title, String subtitle) {
    return RadioListTile<String>(
      value: value,
      groupValue: _paymentMethod,
      onChanged: (v) => setState(() => _paymentMethod = v!),
      title:
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _checkoutSummaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value == 0 ? 'Grátis' : 'R\$ ${value.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  void _submitOrder() {
    if (app.placeOrder(context, _addressCtrl.text)) {
      setState(() {});
    }
  }

  Widget _buildSuccessScreen() {
    final primary = Theme.of(context).colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: Colors.green, size: 60),
            ),
            const SizedBox(height: 24),
            const Text('Pedido Realizado!',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Obrigado pela sua compra!',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  const Text('Número do Pedido',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  SelectableText(
                    app.orderNumber!,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Você receberá atualizações por e-mail.\nEntrega estimada: 5 a 10 dias úteis.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  app.clearCart();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                child: const Text('Continuar Comprando'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
