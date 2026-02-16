import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importa tus features aquí cuando vayas creando las pantallas
import 'features/tables/presentation/screens/tables_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZACION DE SUPABASE
  // REEMPLAZA CON TUS CREDENCIALES REALES
  await Supabase.initialize(
    url: 'https://fwmourlyvjxntfgzxdvs.supabase.co',
    anonKey: 'sb_publishable_JY8TE2Z6Fzsy8Nl6M0ktxQ_wY9WN_Ue',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tazas y Dados - POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // Configuración básica de estilos
        cardTheme: const CardThemeData(elevation: 4, margin: EdgeInsets.all(8)),
      ),
      home: const PlaceholderHomeScreen(),
    );
  }
}

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tazas y Dados - Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.casino, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              'Bienvenido al POS Ludo Café',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TablesScreen()),
                );
              },
              icon: const Icon(Icons.table_restaurant),
              label: const Text('Gestionar Mesas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navegar a reporte (cuando exista)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ir a Reportes (Pendiente)')),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('Ver Reporte del Día'),
            ),
          ],
        ),
      ),
    );
  }
}
