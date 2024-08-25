import 'package:fluent_ui/fluent_ui.dart';

import '/src/presentation/components/totales_jabas.dart';
import 'detalle_widget.dart';

import 'filtro_widget.dart';
import 'table_widget.dart';

class VentasVivoView extends StatefulWidget {
  const VentasVivoView({super.key});

  @override
  State<VentasVivoView> createState() => _VentasVivoViewState();
}

class _VentasVivoViewState extends State<VentasVivoView> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosVentasVivo(),
          Column(
            children: [
              TableTotalesJabas(controller: controller),
              const SizedBox(height: 20),
              TableVentasVivo(height: size.height * 0.5),
              const SizedBox(height: 10),
              TableDetalleVivo(height: size.height * 0.2),
            ],
          ),
        ],
      ),
    );
  }
}