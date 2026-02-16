import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazas_y_dados_ludo_cafe/features/menu/presentation/providers/menu_provider.dart';
import 'package:tazas_y_dados_ludo_cafe/features/orders/presentation/providers/orders_provider.dart';

class OrderScreen extends ConsumerStatefulWidget {
  final int tableId;
  const OrderScreen({super.key, required this.tableId});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  int? activePedidoId;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mesa ${widget.tableId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: _showCloseAccountDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          // Lado Izquierdo: Menú de Productos
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Filtro de Categorías
                SizedBox(
                  height: 60,
                  child: categoriesAsync.when(
                    data: (categories) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(cat.nombre),
                            selected: false,
                            onSelected: (bool selected) {},
                          ),
                        );
                      },
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Error cat: $e'),
                  ),
                ),
                // Grid de Productos
                Expanded(
                  child: productsAsync.when(
                    data: (products) => GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: InkWell(
                            onTap: () {
                              if (activePedidoId != null) {
                                ref
                                    .read(ordersControllerProvider.notifier)
                                    .agregarProducto(
                                      activePedidoId!,
                                      product.id,
                                      1,
                                      product.precio,
                                    );
                              } else {
                                _abrirMesaYAgregar(product.id, product.precio);
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.coffee, size: 40),
                                const SizedBox(height: 4),
                                Text(
                                  product.nombre,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.precio.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error prod: $e')),
                  ),
                ),
              ],
            ),
          ),
          // Lado Derecho: Comanda Actual
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Comanda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: activePedidoId == null
                        ? const Center(child: Text('Ningún pedido activo'))
                        : _OrderItemsList(pedidoId: activePedidoId!),
                  ),
                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$0.00',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirMesaYAgregar(int productId, double price) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Abriendo mesa...')));
  }

  void _showCloseAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Cuenta'),
        content: const Text('¿Desea cerrar la cuenta y liberar la mesa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (activePedidoId != null) {
                ref
                    .read(ordersControllerProvider.notifier)
                    .cerrarCuenta(activePedidoId!, widget.tableId);
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text('Confirmar Cobro'),
          ),
        ],
      ),
    );
  }
}

class _OrderItemsList extends ConsumerWidget {
  final int pedidoId;
  const _OrderItemsList({required this.pedidoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsStream = ref.watch(orderItemsStreamProvider(pedidoId));

    return itemsStream.when(
      data: (items) {
        if (items.isEmpty) return const Center(child: Text('Sin items'));
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final cantidad = item['cantidad'] ?? 0;
            final precio = item['precio_unitario'] ?? 0;
            return ListTile(
              title: Text('Producto #${item['producto_id']}'),
              subtitle: Text('$cantidad x \$$precio'),
              trailing: Text('\$${(cantidad * precio).toStringAsFixed(2)}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
