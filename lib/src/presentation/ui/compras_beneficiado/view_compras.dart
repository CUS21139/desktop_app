import 'package:app_desktop/src/presentation/ui/compras_beneficiado/create_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../components/totales_producto.dart';
import 'table_widget.dart';
import 'filtro_widget.dart';

class ComprasBeneficiadoView extends StatefulWidget {
  const ComprasBeneficiadoView({super.key});

  @override
  State<ComprasBeneficiadoView> createState() => _ComprasBeneficiadoViewState();
}

class _ComprasBeneficiadoViewState extends State<ComprasBeneficiadoView> {
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
              const CreateCompraBeneficiados(),
              const SizedBox(height: 10),
              TableComprasBeneficiado(height: size.height * 0.53)
            ],
          ),
        ],
      ),
    );
  }
}