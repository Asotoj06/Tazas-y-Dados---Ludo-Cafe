import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/table_model.dart';

class TablesRepository {
  final SupabaseClient _supabase;

  TablesRepository(this._supabase);

  // Stream de todas las mesas en tiempo real, ordenadas por ID (1 a 6)
  Stream<List<TableModel>> getTablesStream() {
    return _supabase
        .from('mesas')
        .stream(primaryKey: ['id'])
        .order('id')
        .map((data) => data.map((json) => TableModel.fromJson(json)).toList());
  }
}
