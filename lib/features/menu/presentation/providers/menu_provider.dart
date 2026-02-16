import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazas_y_dados_ludo_cafe/core/config/supabase_client.dart';
import 'package:tazas_y_dados_ludo_cafe/features/menu/data/models/category_model.dart';
import 'package:tazas_y_dados_ludo_cafe/features/menu/data/models/product_model.dart';
import 'package:tazas_y_dados_ludo_cafe/features/menu/data/repositories/menu_repository.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MenuRepository(client);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.watch(menuRepositoryProvider).getCategories();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(menuRepositoryProvider).getProducts();
});
