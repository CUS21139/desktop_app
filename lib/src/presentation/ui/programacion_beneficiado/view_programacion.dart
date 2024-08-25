import 'package:fluent_ui/fluent_ui.dart';

import '../../components/totales_producto.dart';
import 'create_widget.dart';
import 'table_widget.dart';
import 'filtro_widget.dart';

class ProgramacionBeneficiadoView extends StatefulWidget {
  const ProgramacionBeneficiadoView({super.key});

  @override
  State<ProgramacionBeneficiadoView> createState() => _ProgramacionBeneficiadoViewState();
}

class _ProgramacionBeneficiadoViewState extends State<ProgramacionBeneficiadoView> {
  final scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosProgramacionBeneficiado(),
          Column(
            children: [
              TableTotales(controller: scrollCtrl),
              const CreateOrdenBeneficiado(),
              const SizedBox(height: 10),
              TableOrdenesBeneficiado(
                  height: size.width <= 1366
                      ? size.height * 0.45
                      : size.height * 0.5)
            ],
          ),
        ],
      ),
    );
  }
}
