import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RpgMarketApp());
}

class Product {
  final String id;
  final String name;
  final String thumbnail;
  final double price;
  final int stock;

  Product({required this.id, required this.name, required this.thumbnail, required this.price, required this.stock});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price'].toString()) ?? 0.0,
      stock: (json['stock'] is int) ? json['stock'] as int : int.tryParse(json['stock']?.toString() ?? '') ?? 0,
    );
  }
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
    return MaterialApp(
      title: 'Furniture Store',
      themeMode: _themeMode, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4423), 
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6B4423),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8B6F47),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4423),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6B4423),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8B6F47),
        ),
      ),
      home: const FurnitureStorePage(),
    );
  }
}

class Furniture {
  final String name;
  final String category;
  final double price;
  final String description;
  final IconData icon;

  Furniture({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
  });
}

class FurnitureStorePage extends StatefulWidget {
  const FurnitureStorePage({super.key});

  @override
  State<FurnitureStorePage> createState() => _FurnitureStorePageState();
}

class _FurnitureStorePageState extends State<FurnitureStorePage> {
  final List<Furniture> furnitureList = [
    Furniture(
      name: 'Sofá Moderno',
      category: 'Sala',
      price: 1200.00,
      description: 'Sofá confortável com design moderno e elegante',
      icon: Icons.chair,
    ),
    Furniture(
      name: 'Mesa de Madeira',
      category: 'Sala',
      price: 450.00,
      description: 'Mesa de jantar feita em madeira maciça',
      icon: Icons.table_restaurant,
    ),
    Furniture(
      name: 'Cama King Size',
      category: 'Quarto',
      price: 1500.00,
      description: 'Cama espaçosa com estrutura robusta',
      icon: Icons.bed,
    ),
    Furniture(
      name: 'Guarda-roupa',
      category: 'Quarto',
      price: 800.00,
      description: 'Guarda-roupa espaçoso com espelho',
      icon: Icons.checkroom,
    ),
    Furniture(
      name: 'Estante de Livros',
      category: 'Escritório',
      price: 350.00,
      description: 'Estante com múltiplos compartimentos',
      icon: Icons.shelves,
    ),
    Furniture(
      name: 'Cadeira de Escritório',
      category: 'Escritório',
      price: 600.00,
      description: 'Cadeira ergonômica para longas jornadas de trabalho',
      icon: Icons.chair,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Móveis'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: furnitureList.length,
        itemBuilder: (context, index) {
          final furniture = furnitureList[index];
          return FurnitureCard(furniture: furniture);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carrinho atualizado!')),
          );
        },
        tooltip: 'Carrinho de Compras',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class FurnitureCard extends StatelessWidget {
  final Furniture furniture;

  const FurnitureCard({super.key, required this.furniture});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6F47).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    furniture.icon,
                    size: 40,
                    color: const Color(0xFF6B4423),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        furniture.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4.0),
                      Chip(
                        label: Text(furniture.category),
                        backgroundColor: const Color(0xFF8B6F47).withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              furniture.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$ ${furniture.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF6B4423),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4423),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${furniture.name} adicionado ao carrinho!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Adicionar'),
                ),
              ],
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