import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/ordenes_vivo_provider.dart';
import '/src/presentation/utils/text_style.dart';

class CabeceraWidget extends StatelessWidget {
  const CabeceraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Consumer<OrdenesVivoProv>(builder: (_, service, __) {
        return Row(
          children: [
            Text(
              'Orden de Entrega N° ${service.orden.id.toString().padLeft(5, '0')}',
              style: subtitleDataDBStyle,
            ),
            const SizedBox(width: 50),
            Text(
              'N° Aves: ${service.orden.cantAves.toString()}',
              style: subtitleDataDBStyle,
            ),
          ],
        );
      }),
    );
  }
}
