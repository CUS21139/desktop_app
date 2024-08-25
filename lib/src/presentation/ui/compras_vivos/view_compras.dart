import 'package:fluent_ui/fluent_ui.dart';

import '/src/presentation/components/totales_producto.dart';
import '/src/presentation/ui/compras_beneficiado/filtro_widget.dart';
import 'create_widget.dart';
import 'table_widget.dart';

class ComprasVivosView extends StatefulWidget {
  const ComprasVivosView({super.key});

  @override
  State<ComprasVivosView> createState() => _ComprasVivosViewState();
}

class _ComprasVivosViewState extends State<ComprasVivosView> {
  final scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosComprasVivos(),
          Column(
            children: [
              TableTotales(controller: scrollCtrl),
              const CreateCompraVivos(),
              const SizedBox(height: 10),
              TableComprasVivos(height: size.height * 0.53)
            ],
          ),
        ],
      ),
    );
  }
}