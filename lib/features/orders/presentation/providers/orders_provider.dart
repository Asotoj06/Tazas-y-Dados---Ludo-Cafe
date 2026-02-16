import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazas_y_dados_ludo_cafe/core/config/supabase_client.dart';
import 'package:tazas_y_dados_ludo_cafe/features/orders/data/repositories/orders_repository.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(supabaseClientProvider));
});

// Controller para manejar acciones de órdenes
class OrdersController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<int> abrirMesa(int mesaId) async {
    state = const AsyncValue.loading();
    final repository = ref.read(ordersRepositoryProvider);
    final pedidoId = await repository.abrirMesa(mesaId);
    state = const AsyncValue.data(null);
    return pedidoId;
  }

  Future<void> agregarProducto(
    int pedidoId,
    int productoId,
    int cantidad,
    double precio,
  ) async {
    final repository = ref.read(ordersRepositoryProvider);
    await repository.agregarProducto(pedidoId, productoId, cantidad, precio);
  }

  Future<void> cerrarCuenta(int pedidoId, int mesaId) async {
    state = const AsyncValue.loading();
    final repository = ref.read(ordersRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.cerrarCuenta(pedidoId, mesaId),
    );
  }
}

final ordersControllerProvider = AsyncNotifierProvider<OrdersController, void>(
  OrdersController.new,
);

// Stream de items de un pedido activo
final orderItemsStreamProvider =
    StreamProvider.family<List<Map<String, dynamic>>, int>((ref, pedidoId) {
      final repository = ref.watch(ordersRepositoryProvider);
      return repository.subscribeToPedidoUpdates(pedidoId);
    });

// Reporte de ventas del día
final dailySalesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(ordersRepositoryProvider);
  return repository.obtenerGananciasDia();
});
