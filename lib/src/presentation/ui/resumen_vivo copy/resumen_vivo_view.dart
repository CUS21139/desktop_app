import 'package:fluent_ui/fluent_ui.dart';
import '/src/presentation/ui/resumen_beneficiado/filtros_ben_widget.dart';
import '/src/presentation/ui/resumen_beneficiado/resumen_ben_table.dart';

class ResumenVivoView extends StatelessWidget {
  const ResumenVivoView({super.key});

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