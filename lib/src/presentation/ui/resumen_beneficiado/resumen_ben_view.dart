import 'package:fluent_ui/fluent_ui.dart';
import 'filtros_ben_widget.dart';
import 'resumen_ben_table.dart';

class ResumenBeneficiadoView extends StatelessWidget {
  const ResumenBeneficiadoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          FiltrosResumenBeneficiado(),
          ResumenPorProductoBeneficiado(),
        ],
      ),
    );
  }
}