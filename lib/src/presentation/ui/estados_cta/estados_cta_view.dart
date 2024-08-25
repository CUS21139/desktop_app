import 'package:fluent_ui/fluent_ui.dart';

import './e_bancos_view.dart';
import './e_clientes_view.dart';
import './e_proveedores_view.dart';
// import './e_trabajadores_view.dart';
// import './e_sin_nombre_view.dart';
import './e_gavipo_view.dart';

class EstadosView extends StatefulWidget {
  const EstadosView({super.key});

  @override
  State<EstadosView> createState() => _EstadosViewState();
}

class _EstadosViewState extends State<EstadosView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: TabView(
        currentIndex: currentIndex,
        onChanged: (i) => setState(() => currentIndex = i),
        closeButtonVisibility: CloseButtonVisibilityMode.never,
        tabs: [
          Tab(
            selectedBackgroundColor: Colors.grey.withOpacity(0.1),
            text: const Text('CLIENTES'),
            body: const EstClientesView(),
          ),
          Tab(
            selectedBackgroundColor: Colors.grey.withOpacity(0.1),
            text: const Text('BANCOS'),
            body: const EstBancosView(),
          ),
          Tab(
            selectedBackgroundColor: Colors.grey.withOpacity(0.1),
            text: const Text('PROVEEDORES'),
            body: const EstProveedoresView(),
          ),
          // Tab(
          //   selectedBackgroundColor: Colors.grey.withOpacity(0.1),
          //   text: const Text('TRABAJADORES'),
          //   body: const EstTrabajadoresView(),
          // ),
          Tab(
            selectedBackgroundColor: Colors.grey.withOpacity(0.1),
            text: const Text('MABEL'),
            body: const EstGavipoView(),
          ),
          // Tab(
          //   text: const Text('SIN NOMBRE'),
          //   body: const EstSinNombreView(),
          // ),
        ],
      ),
    );
  }
}
