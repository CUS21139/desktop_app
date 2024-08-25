import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/providers/pesaje_manual_provider.dart';
import '/src/presentation/providers/pesajes_list_provider.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<PesajeManualProv>(builder: (_, service, __) {
          return IconButton(
            icon: const Row(
              children: [
                Icon(FluentIcons.back),
                SizedBox(width: 20),
                Text(
                  'Volver',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () {
              final pesajeProv = Provider.of<PesajesProv>(context, listen: false);
              service.pesajeManual = false;
              pesajeProv.clearList();
            },
          );
        }),
      ],
    );
  }
}
