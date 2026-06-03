import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product.dart';

class AppState extends StatefulWidget {
  final Widget Function(BuildContext, AppStateData) builder;
  const AppState({super.key, required this.builder});

  @override
  State<AppState> createState() => AppStateData();
}

class AppStateData extends State<AppState> {
  ThemeMode themeMode = ThemeMode.light;
  List<Product> products = [];
  final Map<String, int> cart = {};
  final Set<String> wishlist = {};
  bool isLoading = true;
  String? loggedInUser;
  String? orderNumber;
  String userName = 'Visitante';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final text = await rootBundle.loadString('assets/products.json');
      final list = json.decode(text) as List<dynamic>;
      setState(() {
        products =
            list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar produtos: $e');
      setState(() => isLoading = false);
    }
  }

  void toggleTheme() => setState(() {
        themeMode =
            themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      });

  void toggleWishlist(String id) => setState(
      () => wishlist.contains(id) ? wishlist.remove(id) : wishlist.add(id));

  Product? productById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  int get cartItemCount => cart.values.fold(0, (sum, qty) => sum + qty);

  double get subtotal {
    double total = 0;
    cart.forEach((id, qty) {
      final p = productById(id);
      if (p != null) total += p.price * qty;
    });
    return total;
  }

  double get shipping => subtotal == 0 ? 0 : (subtotal >= 299 ? 0 : 19.90);
  double get taxes => subtotal * 0.08;
  double get grandTotal => subtotal + shipping + taxes;

  void addToCart(Product product, BuildContext context, {int qty = 1}) {
    final current = cart[product.id] ?? 0;
    if (current + qty > product.stock) {
      _showSnack(context, 'Quantidade máxima em estoque atingida!', isError: true);
      return;
    }
    setState(() => cart[product.id] = current + qty);
    _showSnack(context, '${product.name} adicionado ao carrinho!');
  }

  void updateQty(String id, int delta, BuildContext context) {
    final p = productById(id);
    if (p == null) return;
    final current = cart[id] ?? 0;
    final next = current + delta;
    if (next <= 0) {
      setState(() => cart.remove(id));
    } else if (next > p.stock) {
      _showSnack(context, 'Estoque máximo atingido!', isError: true);
    } else {
      setState(() => cart[id] = next);
    }
  }

  void clearCart() => setState(() {
        cart.clear();
        orderNumber = null;
      });

  bool placeOrder(BuildContext context, String address) {
    if (cart.isEmpty) {
      _showSnack(context, 'Seu carrinho está vazio!', isError: true);
      return false;
    }
    if (address.trim().isEmpty) {
      _showSnack(context, 'Informe o endereço de entrega!', isError: true);
      return false;
    }
    final num = 'VL-${DateTime.now().year}-${100000 + Random().nextInt(900000)}';
    setState(() => orderNumber = num);
    return true;
  }

  void logout() {
    setState(() {
      loggedInUser = null;
      userName = 'Visitante';
      userEmail = '';
    });
  }

  void login(String name, String email) {
    setState(() {
      loggedInUser = email;
      userName = name;
      userEmail = email;
    });
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red[700] : Colors.green[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}
