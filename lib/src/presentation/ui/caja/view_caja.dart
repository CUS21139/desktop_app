import 'package:fluent_ui/fluent_ui.dart';

import '/src/presentation/ui/caja/options_buttons.dart';
import './filtro_widget.dart';
import './table_widget.dart';

class CajaView extends StatelessWidget {
  const CajaView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          FiltrosCaja(),
          Column(
            children: [
              SizedBox(height: 25),
              OptionButtonsWidget(),
              SizedBox(height: 25),
              TableCaja(),
            ],
          ),
        ],
      ),
    );
  }
}