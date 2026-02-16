import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class MenuRepository {
  final SupabaseClient _supabase;

  MenuRepository(this._supabase);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _supabase
        .from('categorias')
        .select()
        .order('nombre');

    return (response as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<Product>> getProducts() async {
    final response = await _supabase.from('productos').select().order('nombre');

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await _supabase
        .from('productos')
        .select()
        .eq('categoria_id', categoryId)
        .order('nombre');

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }
}
