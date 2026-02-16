import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazas_y_dados_ludo_cafe/features/tables/data/models/table_model.dart';
import 'package:tazas_y_dados_ludo_cafe/features/tables/presentation/providers/tables_provider.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsyncValue = ref.watch(tablesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Mesas'), centerTitle: true),
      body: tablesAsyncValue.when(
        data: (tables) {
          if (tables.isEmpty) {
            return const Center(
              child: Text(
                'No hay mesas configuradas.\nAsegúrate de tener registros en la tabla "mesas" (ID 1-6).',
                textAlign: TextAlign.center,
              ),
            );
          }
          return _TablesGrid(tables: tables);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _TablesGrid extends StatelessWidget {
  final List<TableModel> tables;
  const _TablesGrid({required this.tables});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return _TableCard(table: table);
      },
    );
  }
}

class _TableCard extends StatelessWidget {
  final TableModel table;
  const _TableCard({required this.table});

  @override
  Widget build(BuildContext context) {
    final isOccupied = table.isOccupied;
    final color = isOccupied ? Colors.red.shade100 : Colors.green.shade100;
    final iconColor = isOccupied ? Colors.red : Colors.green;
    final statusText = isOccupied ? 'Ocupada' : 'Disponible';

    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Abrir Mesa ${table.id}')));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_bar, size: 48, color: iconColor),
            const SizedBox(height: 8),
            Text(
              'MESA ${table.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 14,
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
