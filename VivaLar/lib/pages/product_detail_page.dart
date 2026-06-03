import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/app_state.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final AppStateData appState;

  const ProductDetailPage(
      {super.key, required this.product, required this.appState});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  Product get p => widget.product;
  AppStateData get app => widget.appState;

  @override
  Widget build(BuildContext context) {
    final isFav = app.wishlist.contains(p.id);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_outline,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  app.toggleWishlist(p.id);
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withOpacity(0.1),
                      primary.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: p.image.isNotEmpty
                      ? Image.asset(
                          p.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Text(
                            p.thumbnail,
                            style: const TextStyle(fontSize: 120),
                          ),
                        )
                      : Text(p.thumbnail,
                          style: const TextStyle(fontSize: 120)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(p.category,
                            style: const TextStyle(fontSize: 12)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      const Spacer(),
                      Icon(
                        p.stock > 0
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: p.stock > 0 ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.stock > 0
                            ? '${p.stock} em estoque'
                            : 'Fora de estoque',
                        style: TextStyle(
                            color: p.stock > 0 ? Colors.green : Colors.red,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(p.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < p.rating.floor()
                              ? Icons.star
                              : (i < p.rating
                                  ? Icons.star_half
                                  : Icons.star_outline),
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${p.rating} (${p.reviewCount} avaliações)',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.originalPrice > p.price) ...[
                          Row(
                            children: [
                              Text(
                                'R\$ ${p.originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                    fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${p.discountPercent}% OFF',
                                  style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          'R\$ ${p.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                        ),
                        Text(
                          'em até 10x de R\$ ${(p.price / 10).toStringAsFixed(2)} sem juros',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.local_shipping_outlined,
                                color: primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              p.price >= 299
                                  ? 'Frete grátis'
                                  : 'Frete: R\$ 19,90',
                              style: TextStyle(
                                  color: p.price >= 299
                                      ? Colors.green[700]
                                      : Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: p.price >= 299
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(p.shortDescription,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Descrição do Produto',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(p.longDescription,
                      style:
                          TextStyle(color: Colors.grey[700], height: 1.5)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Quantidade:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outline!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                            ),
                            Text('$quantity',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: quantity < p.stock
                                  ? () => setState(() => quantity++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_outline,
                    color: isFav ? Colors.red : null,
                  ),
                  label: const Text('Favoritar'),
                  onPressed: () {
                    app.toggleWishlist(p.id);
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Adicionar ao Carrinho'),
                  onPressed: p.stock > 0
                      ? () {
                          app.addToCart(p, context, qty: quantity);
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
