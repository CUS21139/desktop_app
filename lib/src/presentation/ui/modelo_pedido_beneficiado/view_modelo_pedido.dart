import 'package:fluent_ui/fluent_ui.dart';
import 'create_widget.dart';
import 'filtro_widget.dart';
import 'table_widget.dart';

class ModeloPedidoBeneficiadoView extends StatefulWidget {
  const ModeloPedidoBeneficiadoView({super.key});

  @override
  State<ModeloPedidoBeneficiadoView> createState() => _ModeloPedidoBeneficiadoViewState();
}

class _ModeloPedidoBeneficiadoViewState extends State<ModeloPedidoBeneficiadoView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosModeloProgramacionBeneficiado(),
          Column(
            children: [
              const CreateOrdenModeloBeneficiado(),
              const SizedBox(height: 30),
              TableOrdenesModeloBeneficiado(height: size.height * 0.6)
            ],
          ),
        ],
      ),
    );
  }
}