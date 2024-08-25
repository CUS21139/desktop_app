import 'package:fluent_ui/fluent_ui.dart';
import 'create_widget.dart';
import 'filtro_widget.dart';
import 'table_widget.dart';

class ModeloPedidoVivoView extends StatefulWidget {
  const ModeloPedidoVivoView({super.key});

  @override
  State<ModeloPedidoVivoView> createState() => _ModeloPedidoVivoViewState();
}

class _ModeloPedidoVivoViewState extends State<ModeloPedidoVivoView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          const FiltrosModeloProgramacionVivo(),
          Column(
            children: [
              const CreateOrdenModeloVivo(),
              const SizedBox(height: 30),
              TableOrdenesModeloVivo(height: size.height * 0.6)
            ],
          ),
        ],
      ),
    );
  }
}