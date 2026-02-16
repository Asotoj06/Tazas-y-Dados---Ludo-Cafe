# ☕🎲 Tazas y Dados — Ludo Café (POS)

Sistema de Punto de Venta (POS) para **Tazas y Dados**, un Ludo Café que gestiona mesas, pedidos y reportes de ventas en tiempo real.

---

## 📋 Descripción

Aplicación multiplataforma desarrollada en **Flutter** con **Supabase** como backend. Permite a los meseros y administradores gestionar el flujo completo de servicio: desde abrir una mesa, tomar pedidos, hasta cerrar la cuenta y generar reportes de ventas diarias.

---

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture organizada por Features**:

```
lib/
├── core/                              # Configuración global
│   ├── config/
│   │   └── supabase_client.dart       # Provider global de SupabaseClient
│   ├── constants/
│   └── utils/
├── features/
│   ├── tables/                        # Gestión del mapa de 6 mesas
│   │   ├── data/
│   │   │   ├── models/                # TableModel
│   │   │   └── repositories/          # TablesRepository (Stream real-time)
│   │   └── presentation/
│   │       ├── providers/             # tablesStreamProvider (Riverpod)
│   │       └── screens/               # TablesScreen (Grid de mesas)
│   ├── menu/                          # Visualización de productos
│   │   ├── data/
│   │   │   ├── models/                # Product, CategoryModel
│   │   │   └── repositories/          # MenuRepository
│   │   └── presentation/
│   │       └── providers/             # categoriesProvider, productsProvider
│   ├── orders/                        # Lógica principal de venta
│   │   ├── data/
│   │   │   ├── models/                # Order, OrderItem
│   │   │   └── repositories/          # OrdersRepository (RPCs + Streams)
│   │   └── presentation/
│   │       ├── providers/             # OrdersController, orderItemsStreamProvider
│   │       └── screens/               # OrderScreen (comanda activa)
│   └── admin/                         # Reportes y gestión
│       ├── data/
│       │   └── repositories/
│       └── presentation/
│           └── screens/
└── main.dart                          # Entry point + Supabase init
```

Cada feature se divide en 3 capas:
- **Data**: Modelos (`fromJson`/`toJson`) y Repositorios (llamadas a Supabase).
- **Domain**: Entidades y lógica de negocio pura.
- **Presentation**: Widgets de UI y gestores de estado (Riverpod).

---

## 🛠️ Stack Tecnológico

| Tecnología | Uso |
|---|---|
| **Flutter 3.x** | Framework de UI multiplataforma |
| **Dart** | Lenguaje de programación |
| **Supabase** | Backend (PostgreSQL, Auth, Realtime) |
| **Riverpod 3.x** | Gestión de estado reactiva |
| **Equatable** | Comparación de objetos |

---

## 🗄️ Base de Datos (Supabase)

### Tablas

| Tabla | Descripción |
|---|---|
| `mesas` | 6 mesas con estado (`disponible` / `ocupada`) |
| `categorias` | Categorías de productos (Café, Frappés, Comida, etc.) |
| `productos` | Catálogo de productos con nombre, precio y categoría |
| `pedidos` | Órdenes vinculadas a una mesa, con estado y total acumulado |
| `pedidio_items` | Items individuales de cada pedido (producto, cantidad, precio) |

### Funciones RPC y Triggers

| Función | Tipo | Descripción |
|---|---|---|
| `calcular_total_pedido` | **Trigger** | Recalcula automáticamente `total_acumulado` en `pedidos` cada vez que se modifica `pedidio_items` |
| `abrir_mesa` | **RPC** | Cambia estado de mesa a `ocupada` y crea un nuevo pedido `abierto` |
| `cerrar_cuenta` | **RPC** | Marca pedido como `pagado`, registra `cerrado_at` y libera la mesa |
| `obtener_ganancias_dia` | **RPC** | Retorna ganancia total y número de pedidos pagados del día actual |

---

## 🚀 Funcionalidades

- **Mapa de Mesas en Tiempo Real**: Visualización de las 6 mesas con su estado actual (disponible/ocupada), actualizado via Supabase Realtime.
- **Gestión de Pedidos**: Abrir mesa → tomar pedido → agregar productos → cerrar cuenta.
- **Menú por Categorías**: Visualización de productos organizados por categoría.
- **Cálculo Automático de Totales**: El trigger `calcular_total_pedido` en PostgreSQL garantiza que el total sea siempre exacto sin cálculos en el frontend.
- **Reporte de Ventas Diarias**: Consulta RPC que retorna las ganancias del día y conteo de pedidos.
- **Sincronización Multi-dispositivo**: Streams de Supabase Realtime para que cambios en una mesa se reflejen en todos los dispositivos al instante.

---

## ⚙️ Configuración

### Requisitos Previos
- Flutter SDK (>= 3.9.2)
- Cuenta de Supabase con las tablas y funciones RPC configuradas

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/Asotoj06/Tazas-y-Dados---Ludo-Cafe.git
cd Tazas-y-Dados---Ludo-Cafe

# Instalar dependencias
flutter pub get

# Configurar credenciales de Supabase en lib/main.dart
# Reemplazar url y anonKey con tus valores

# Ejecutar en navegador (Edge/Chrome)
flutter run -d edge
```

---

## 📝 Estado del Proyecto

- [x] Estructura de Clean Architecture por Features
- [x] Modelos de datos mapeados a Supabase (`Product`, `Order`, `OrderItem`, `TableModel`, `CategoryModel`)
- [x] Repositorios con integración a RPCs (`abrir_mesa`, `cerrar_cuenta`, `obtener_ganancias_dia`)
- [x] Stream Realtime para mesas y pedidos
- [x] Providers de Riverpod (AsyncNotifier)
- [x] Pantalla de Dashboard (Home)
- [x] Pantalla de Mapa de Mesas
- [x] Pantalla de Pedido / Comanda
- [ ] UI de Reporte de Ventas (Admin)
- [ ] CRUD de Productos (Admin)
- [ ] Diseño visual premium (colores, animaciones, branding)

---

## 👥 Autor

- **Asotoj06** — [GitHub](https://github.com/Asotoj06)