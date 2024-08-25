import 'package:fluent_ui/fluent_ui.dart';

import '../../components/totales_producto.dart';
import 'create_widget.dart';
import 'table_widget.dart';
import 'filtro_widget.dart';

class ProgramacionVivoView extends StatefulWidget {
  const ProgramacionVivoView({super.key});

  @override
  State<ProgramacionVivoView> createState() => _ProgramacionVivoViewState();
}

class _ProgramacionVivoViewState extends State<ProgramacionVivoView> {
  final scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosProgramacionVivo(),
          Column(
            children: [
              TableTotales(controller: scrollCtrl),
              const CreateOrdenVivo(),
              const SizedBox(height: 10),
              TableOrdenesVivo(
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
