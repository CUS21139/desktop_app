import 'package:fluent_ui/fluent_ui.dart';

import '/src/presentation/components/totales_jabas.dart';
import 'detalle_widget.dart';

import 'filtro_widget.dart';
import 'table_widget.dart';

class VentasBeneficiadoView extends StatefulWidget {
  const VentasBeneficiadoView({super.key});

  @override
  State<VentasBeneficiadoView> createState() => _VentasBeneficiadoViewState();
}

class _VentasBeneficiadoViewState extends State<VentasBeneficiadoView> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosVentasBeneficiado(),
          Column(
            children: [
              TableTotalesJabas(controller: controller),
              const SizedBox(height: 20),
              TableVentasBeneficiado(height: size.height * 0.5),
              const SizedBox(height: 10),
              TableDetalleBeneficiado(height: size.height * 0.2),
            ],
          ),
        ],
      ),
    );
  }
}