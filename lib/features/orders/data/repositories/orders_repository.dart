import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersRepository {
  final SupabaseClient _supabase;

  OrdersRepository(this._supabase);

  /// Real-time: Stream que escucha cambios en la tabla 'pedidio_items'.
  /// Esto permite que si un mesero agrega un Capuchino, la barra lo vea al instante.
  Stream<List<Map<String, dynamic>>> subscribeToPedidoUpdates(int pedidoId) {
    // Escuchamos la tabla 'pedidio_items' filtrando por el ID del pedido activo
    // Nota: El frontend deberá proveer el `pedidoId` actual de la mesa.
    return _supabase
        .from('pedidio_items')
        .stream(primaryKey: ['id'])
        .eq('pedido_id', pedidoId)
        .order('creado_at');
  }

  /// RPC: abrir_mesa
  /// Inicia el servicio: Cambia estado de mesa a 'ocupada' y crea pedido 'abierto'.
  Future<int> abrirMesa(int mesaId) async {
    // Llama a la funcion RPC 'abrir_mesa' en Postgres
    final response = await _supabase.rpc(
      'abrir_mesa',
      params: {'p_mesa_id': mesaId},
    );

    // Retorna el ID del nuevo pedido creado
    return response as int;
  }

  /// Agregar item al pedido (El trigger calcular_total_pedido actualizará el total automáticamente)
  Future<void> agregarProducto(
    int pedidoId,
    int productoId,
    int cantidad,
    double precioUnitario,
  ) async {
    await _supabase.from('pedidio_items').insert({
      'pedido_id': pedidoId,
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    });
  }

  /// RPC: cerrar_cuenta
  /// Finaliza la venta: Marca pedido estatus 'pagado', registra fecha cierre y libera mesa.
  Future<void> cerrarCuenta(int pedidoId, int mesaId) async {
    await _supabase.rpc(
      'cerrar_cuenta',
      params: {'p_pedido_id': pedidoId, 'p_mesa_id': mesaId},
    );
  }

  /// RPC: obtener_ganancias_dia
  /// Cierre de caja: Retorna ganancia total y conteo de pedidos del día.
  Future<Map<String, dynamic>> obtenerGananciasDia() async {
    // La RPC debe retornar un objeto JSON o registro con { "total": X, "cantidad": Y }
    final response = await _supabase.rpc('obtener_ganancias_dia');
    return response as Map<String, dynamic>;
  }
}
