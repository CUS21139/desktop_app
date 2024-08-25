import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../providers/ventas_vivo_provider.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

/// Widget que recibe un [Map] y muestra los totales por producto según el [Map].
class TableTotalesJabas extends StatelessWidget {
  const TableTotalesJabas({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 970.0 : 1050.0;
    final ventaProv = Provider.of<VentasVivoProv>(context);
    final map = ventaProv.jabasPorCamal();
    return SizedBox(
      height: 80,
      width: globalWidth,
      child: Row(
        children: [
          Container(
            width: size.width * 0.07,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  color: greyColor,
                  height: 40,
                  child: const Center(
                    child: Text('Camales', style: cellDataDBErrorStyle),
                  ),
                ),
                Container(
                  color: blueGreyColor,
                  height: 40,
                  child: const Center(
                    child: Text('Cant. Jabas', style: titleTableStyle),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: controller,
              child: ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: map.length,
                separatorBuilder: (c, i) => const Divider(direction: Axis.vertical),
                itemBuilder: (c, i) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: size.width * 0.05,
                        child: Center(
                          child: Text(
                            map.keys.elementAt(i),
                            style: cellDataDBStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: size.width * 0.05,
                        child: Center(
                          child: Text(
                            map.values.elementAt(i).toString(),
                            style: cantidadCompradaStyle,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
