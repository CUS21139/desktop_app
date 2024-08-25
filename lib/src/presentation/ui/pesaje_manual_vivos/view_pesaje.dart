import 'package:fluent_ui/fluent_ui.dart';

import 'button_back.dart';
import 'cabecera_widget.dart';
import 'datos_widget.dart';
import 'table_widget.dart';

class PesajeManualView extends StatefulWidget {
  const PesajeManualView({super.key});

  @override
  State<PesajeManualView> createState() => _PesajeManualViewState();
}

class _PesajeManualViewState extends State<PesajeManualView> {
  final scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const ButtonBack(),
            Row(
              children: [
                const DatosPesajeWidget(),
                Column(
                  children: [
                    const CabeceraWidget(),
                    TablePesajeManual(height: height * 0.6)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
