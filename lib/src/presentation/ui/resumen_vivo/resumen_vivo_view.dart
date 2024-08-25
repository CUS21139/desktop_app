import 'package:fluent_ui/fluent_ui.dart';
import 'filtros_vivo_widget.dart';
import 'resumen_vivo_table.dart';

class ResumenVivoView extends StatelessWidget {
  const ResumenVivoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          FiltrosResumenVivo(),
          ResumenPorProductoVivo(),
        ],
      ),
    );
  }
}