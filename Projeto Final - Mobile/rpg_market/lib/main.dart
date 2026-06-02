import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furniture Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4423), // Cor de madeira
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
      icon: Icons.door_back,
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
