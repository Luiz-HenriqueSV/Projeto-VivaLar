import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RpgMarketApp());
}

class RpgMarketApp extends StatefulWidget {
  const RpgMarketApp({super.key});

  @override
  State<RpgMarketApp> createState() => _RpgMarketAppState();
}

class _RpgMarketAppState extends State<RpgMarketApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  List<Product> products = [];
  final Map<String, int> cart = {};
  String? confirmationNumber;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final String jsonText = await rootBundle.loadString('assets/products.json');
      final List<dynamic> decoded = json.decode(jsonText) as List<dynamic>;
      setState(() {
        products = decoded.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      debugPrint("Erro ao carregar JSON: $e");
    }
  }

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Product? productById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  double get subtotal {
    double total = 0;
    cart.forEach((id, qty) {
      final product = productById(id);
      if (product != null) total += product.price * qty;
    });
    return total;
  }

  double get shipping => subtotal == 0 ? 0 : (subtotal >= 150.00 ? 0 : 19.90);
  double get taxes => subtotal * 0.08;
  double get grandTotal => subtotal + shipping + taxes;

  void addToCart(Product product, BuildContext context) {
    final currentQty = cart[product.id] ?? 0;
    if (currentQty + 1 > product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estoque insuficiente para este item de guilda!')),
      );
      return;
    }
    setState(() => cart[product.id] = currentQty + 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} adicionado ao inventário do carrinho!')),
    );
  }

  void updateQuantity(String id, int delta, BuildContext context) {
    final product = productById(id);
    if (product == null) return;

    final currentQty = cart[id] ?? 0;
    final newQty = currentQty + delta;

    if (newQty <= 0) {
      setState(() => cart.remove(id));
    } else if (newQty > product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantidade máxima em estoque atingida!')),
      );
    } else {
      setState(() => cart[id] = newQty);
    }
  }

  void cancelOrder() {
    setState(() {
      cart.clear();
      confirmationNumber = null;
    });
  }

  bool finishOrder(BuildContext context, String billing, String shippingAddr) {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seu carrinho está vazio, aventureiro!')),
      );
      return false;
    }
    if (billing.trim().isEmpty || shippingAddr.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe os pergaminhos de endereço de cobrança e entrega!')),
      );
      return false;
    }
    final number = 'RPG-${DateTime.now().year}-${100000 + Random().nextInt(900000)}';
    setState(() {
      confirmationNumber = number;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        primary: Colors.purple,
        secondary: Colors.amber,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        primary: Colors.purpleAccent,
        secondary: Colors.amber,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1233),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF120A21),
        foregroundColor: Colors.purpleAccent,
      ),
    );

    return MaterialApp(
      title: 'RPG Market',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: LandingPage(appState: this),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String thumbnail;
  final String shortDescription;
  final String longDescription;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.thumbnail,
    required this.shortDescription,
    required this.longDescription,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      thumbnail: json['thumbnail'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
    );
  }
}

class AppSettingsDrawer extends StatelessWidget {
  final _RpgMarketAppState appState;
  const AppSettingsDrawer({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = appState._themeMode == ThemeMode.dark;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '⚔️ Configurações da Guilda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Ajuste sua interface visual',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Tema Escuro'),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                appState.toggleTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final _RpgMarketAppState appState;
  const LandingPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage(appState: appState)),
            ),
          )
        ],
      ),
      drawer: AppSettingsDrawer(appState: appState),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔮',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              Text(
                'Bem-vindo à Taverna RPG Market!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Aqui você encontra os melhores artefatos, armas lendárias e consumíveis mágicos para suas campanhas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                icon: const Icon(Icons.shield),
                label: const Text('Explorar Arsenal (Produtos)'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductsPage(appState: appState)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Ver Inventário (Carrinho)'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage(appState: appState)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final _RpgMarketAppState appState;
  const ProductsPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsenal de Itens'),
      ),
      body: appState.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: appState.products.length,
              itemBuilder: (context, index) {
                final product = appState.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(product.thumbnail, style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(product.shortDescription, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PO ${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Estoque: ${product.stock} un',
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsPage(product: product, appState: appState),
                            ),
                          ),
                          child: const Text('Olhar'),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final _RpgMarketAppState appState;

  const ProductDetailsPage({super.key, required this.product, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(product.thumbnail, style: const TextStyle(fontSize: 100))),
            const SizedBox(height: 16),
            Text('ID do Item: ${product.id}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(product.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço: PO ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(product.stock > 0 ? 'Em Estoque (${product.stock})' : 'Esgotado'),
                  backgroundColor: product.stock > 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text('Propriedades e Lore:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.longDescription, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_moderator),
                label: const Text('Adicionar ao Inventário'),
                onPressed: product.stock > 0 ? () => appState.addToCart(product, context) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final _RpgMarketAppState appState;
  const CartPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventário do Carrinho')),
      body: appState.cart.isEmpty
          ? const Center(child: Text('Nenhum item adicionado à mochila.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: appState.cart.length,
                    itemBuilder: (context, index) {
                      final String id = appState.cart.keys.elementAt(index);
                      final int quantity = appState.cart[id]!;
                      final product = appState.productById(id);

                      if (product == null) return const SizedBox.shrink();

                      return ListTile(
                        leading: Text(product.thumbnail, style: const TextStyle(fontSize: 30)),
                        title: Text(product.name),
                        subtitle: Text('PO ${product.price.toStringAsFixed(2)} x $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => appState.updateQuantity(id, -1, context),
                            ),
                            Text('$quantity', style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => appState.updateQuantity(id, 1, context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:'),
                            Text('PO ${appState.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Montaria (Frete):'),
                            Text(appState.shipping == 0 ? 'Grátis' : 'PO ${appState.shipping.toStringAsFixed(2)}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Dízimo Imperial (8%):'),
                            Text('PO ${appState.taxes.toStringAsFixed(2)}'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Geral:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('PO ${appState.grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () {
                                  appState.cancelOrder();
                                  Navigator.pop(context);
                                },
                                child: const Text('Esvaziar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CheckoutPage(appState: appState)),
                                ),
                                child: const Text('Fechar Contrato'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final _RpgMarketAppState appState;
  const CheckoutPage({super.key, required this.appState});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _billingController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selar Contrato de Compra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Endereço do Comprador (Guilda/Cobrança)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _billingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Taverna do Dragão Verde, Quarto 4, Cidade de Validória',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Destino de Entrega dos Artefatos',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _shippingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Torre do Mago Real, Distrito de Alta Magia',
              ),
            ),
            const SizedBox(height: 30),
            if (widget.appState.confirmationNumber != null) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Text('📜 Pergaminho de Confirmação Emitido!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      SelectableText(
                        widget.appState.confirmationNumber!,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.appState.confirmationNumber != null
                    ? null
                    : () {
                        if (widget.appState.finishOrder(
                          context,
                          _billingController.text,
                          _shippingController.text,
                        )) {
                          setState(() {});
                        }
                      },
                child: const Text('Confirmar e Enviar Mensageiro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}