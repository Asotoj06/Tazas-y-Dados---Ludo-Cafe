import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazas_y_dados_ludo_cafe/core/config/supabase_client.dart';
import 'package:tazas_y_dados_ludo_cafe/features/tables/data/repositories/tables_repository.dart';
import 'package:tazas_y_dados_ludo_cafe/features/tables/data/models/table_model.dart';

// Provider del Repositorio de Mesas
final tablesRepositoryProvider = Provider<TablesRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return TablesRepository(supabase);
});

// Stream Provider: El estado que la UI va a consumir.
final tablesStreamProvider = StreamProvider<List<TableModel>>((ref) {
  final repository = ref.watch(tablesRepositoryProvider);
  return repository.getTablesStream();
});
