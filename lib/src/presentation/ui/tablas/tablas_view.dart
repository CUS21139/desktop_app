import 'package:app_desktop/src/presentation/ui/tablas/t_vehiculos_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/ui/tablas/t_usuarios_view.dart';

import 't_bancos_view.dart';
import 't_camales_view.dart';
import 't_clientes_view.dart';
import 't_pesadores_view.dart';
import 't_productos_beneficiado_view.dart';
import 't_productos_vivo_view.dart';
import 't_proveedores_view.dart';
import 't_zonas_view.dart';

class TablasView extends StatefulWidget {
  const TablasView({super.key});

  @override
  State<TablasView> createState() => _TablasViewState();
}

class _TablasViewState extends State<TablasView> {
  int currentIndex = 0;
  final key = const Key('userTable');

  List<Tab> tabList = [
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Zonas'),
      body: const ZonasView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Bancos'),
      body: const BancosView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Clientes'),
      body: const ClientesView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Proveedores'),
      body: const ProveedorView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Productos Vivo'),
      body: const ProductosVivoView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Productos Beneficiado'),
      body: const ProductosBeneficiadoView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Vehículos'),
      body: const VehiculosView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Camales'),
      body: const CamalesView(),
    ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      text: const Text('Pesadores App'),
      body: const PesadoresView(),
    ),
    // Tab(
    //   text: const Text('Trabajadores'),
    //   body: const TrabajadoresView(),
    // ),
    Tab(
      selectedBackgroundColor: Colors.grey.withOpacity(0.1),
      key: const Key('userTable'),
      text: const Text('Usuarios'),
      body: const UsuariosView(),
    ),
  ];

  @override
  void initState() {
    final userRole = Provider.of<UsuariosProv>(context, listen: false).usuario.role;
    if (userRole != 'ADM') {
      tabList.removeWhere((e) => e.key == key);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: TabView(
        currentIndex: currentIndex,
        onChanged: (i) => setState(() => currentIndex = i),
        closeButtonVisibility: CloseButtonVisibilityMode.never,
        tabs: tabList,
      ),
    );
  }
}
