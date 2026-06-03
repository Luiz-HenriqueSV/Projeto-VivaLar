import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_theme.dart';
import '../widgets/product_card.dart';
import 'orders_page.dart';
import 'settings_page.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  final AppStateData appState;
  const HomePage({super.key, required this.appState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  AppStateData get app => widget.appState;

  List<String> get categories {
    final cats = app.products.map((p) => p.category).toSet().toList()..sort();
    return ['Todos', ...cats];
  }

  List get filteredProducts {
    return app.products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.shortDescription.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat =
          _selectedCategory == 'Todos' || p.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _navigate(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _selectedIndex == 0
          ? Row(children: [
              const Text('Viva', style: TextStyle(fontWeight: FontWeight.w300)),
              const Text('Lar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: woodAccent)),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: woodOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('STORE',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ])
          : Text(
              ['', 'Favoritos', 'Meu Carrinho', 'Minha Conta'][_selectedIndex],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
      actions: [
        IconButton(
          icon: Icon(
            app.themeMode == ThemeMode.light
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
          ),
          onPressed: app.toggleTheme,
          tooltip: 'Alternar tema',
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
            if (app.cartItemCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: woodOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${app.cartItemCount}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Drawer _buildDrawer() {
    final isDark = app.themeMode == ThemeMode.dark;
    final isLoggedIn = app.loggedInUser != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary),
            accountName: Text(
              isLoggedIn ? app.userName : 'Visitante',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              isLoggedIn ? app.userEmail : 'Faça login para continuar',
              style: const TextStyle(fontSize: 12),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: woodAccent,
              child: Text(
                isLoggedIn ? app.userName[0].toUpperCase() : '?',
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _drawerItem(Icons.home_outlined, 'Início', () {
            setState(() => _selectedIndex = 0);
            Navigator.pop(context);
          }),
          _drawerItem(Icons.favorite_outline, 'Meus Favoritos', () {
            setState(() => _selectedIndex = 1);
            Navigator.pop(context);
          }),
          _drawerItem(Icons.shopping_cart_outlined, 'Carrinho de Compras',
              () {
            setState(() => _selectedIndex = 2);
            Navigator.pop(context);
          }),
          _drawerItem(Icons.receipt_long_outlined, 'Meus Pedidos', () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => OrdersPage(appState: app)));
          }),
          const Divider(),
          _drawerItem(Icons.settings_outlined, 'Configurações', () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SettingsPage(appState: app)));
          }),
          _drawerItem(Icons.help_outline, 'Central de Ajuda', () {
            Navigator.pop(context);
            _showHelpDialog();
          }),
          _drawerItem(Icons.info_outline, 'Sobre o App', () {
            Navigator.pop(context);
            _showAboutDialog();
          }),
          const Divider(),
          if (isLoggedIn)
            _drawerItem(Icons.logout, 'Sair da Conta', () {
              app.logout();
              Navigator.pop(context);
            }, color: Colors.red)
          else
            _drawerItem(Icons.login, 'Entrar / Cadastrar', () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => LoginPage(appState: app)));
            }, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'VivaLar Store v1.0',
              style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: color != null ? TextStyle(color: color) : null),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildBody() {
    if (app.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }
    switch (_selectedIndex) {
      case 0:
        return _buildShopTab();
      case 1:
        return _buildWishlistTab();
      case 2:
        return CartPage(appState: app);
      case 3:
        return AccountPage(appState: app, onNavigate: _navigate);
      default:
        return _buildShopTab();
    }
  }

  Widget _buildShopTab() {
    return Column(
      children: [
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Buscar móveis, decoração...',
              prefixIcon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.primary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A1F18)
                  : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        Container(
          height: 44,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = cat == _selectedCategory;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline!,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_searchQuery.isEmpty && _selectedCategory == 'Todos')
          _buildBanner(),
        Expanded(
          child: filteredProducts.isEmpty
              ? _buildEmptyState()
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (_, i) => ProductCard(
                      product: filteredProducts[i],
                      appState: app,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: const EdgeInsets.all(12),
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Text('🛋️',
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.white.withOpacity(0.15))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: woodOrange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('FRETE GRÁTIS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                const SizedBox(height: 6),
                const Text('Acima de R\$ 299',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Text('Móveis para o lar dos seus sonhos',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistTab() {
    final favs =
        app.products.where((p) => app.wishlist.contains(p.id)).toList();
    if (favs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('Sua lista de favoritos está vazia',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Toque no ❤️ em um produto para salvar',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => setState(() => _selectedIndex = 0),
              child: const Text('Explorar Produtos'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: favs.length,
        itemBuilder: (_, i) =>
            ProductCard(product: favs[i], appState: app),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Nenhum produto encontrado'),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchCtrl.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'Todos';
              });
            },
            child: const Text('Limpar filtros'),
          ),
        ],
      ),
    );
  }

  NavigationBar _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _navigate,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: app.wishlist.isNotEmpty,
            label: Text('${app.wishlist.length}'),
            child: const Icon(Icons.favorite_outline),
          ),
          selectedIcon: const Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: app.cartItemCount > 0,
            label: Text('${app.cartItemCount}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: const Icon(Icons.shopping_cart),
          label: 'Carrinho',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Conta',
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Central de Ajuda'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📦 Entrega: 5 a 10 dias úteis'),
            SizedBox(height: 8),
            Text('🔄 Trocas: até 7 dias após recebimento'),
            SizedBox(height: 8),
            Text('💬 SAC: sac@vivalar.com.br'),
            SizedBox(height: 8),
            Text('📞 0800 123 4567 (seg-sex 8h-18h)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'VivaLar Store',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 VivaLar. Todos os direitos reservados.',
      children: const [
        SizedBox(height: 16),
        Text(
            'Sua loja de móveis e decoração com os melhores preços e qualidade garantida.'),
      ],
    );
  }
}
