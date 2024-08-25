import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../providers/compras_vivo_provider.dart';
import '../providers/ordenes_vivo_provider.dart';

import '/src/presentation/utils/colors.dart';
import '/src/presentation/utils/text_style.dart';

import '/src/services/resumen__service.dart';

/// Widget que recibe un [Map] y muestra los totales por producto según el [Map].
class TableTotales extends StatelessWidget {
  const TableTotales({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final compraProv = Provider.of<ComprasVivoProv>(context);
    final ordenProv = Provider.of<OrdenesVivoProv>(context);
    final map = TableResumenCtrl.mapResumenOrdenCompra(compraProv.comprasResumen, ordenProv.ordenesResumen);
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 960.0 : 1050.0;
    return Container(
      height: 120,
      width: globalWidth,
      margin: EdgeInsets.all(size.width <= 1366 ? 5 :10),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: size.width * 0.07,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: greyColor),
                  height: 30,
                  child: const Center(
                    child: Text('Producto', style: cellDataDBErrorStyle),
                  ),
                ),
                TitleTableWidget(title: 'Compra', color: Colors.blue),
                TitleTableWidget(title: 'Programacion', color: Colors.green),
                TitleTableWidget(title: 'Diferencia', color: Colors.red),
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
                separatorBuilder: (c, i) => const Divider(
                  direction: Axis.vertical,
                ),
                itemBuilder: (c, i) {
                  final compra = map.values.elementAt(i)['compra'];
                  final venta = map.values.elementAt(i)['venta'];
                  final diferencia = (compra ?? 0) - (venta ?? 0);
                  return SizedBox(
                    width: size.width * 0.07,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              map.keys.elementAt(i),
                              style: cellDataDBStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              compra.toString(),
                              style: cantidadCompradaStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              venta.toString(),
                              style: cantidadProgramadaStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(diferencia.toString(),
                                style: cantidadDiferenciaStyle),
                          ),
                        ),
                      ],
                    ),
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

class TitleTableWidget extends StatelessWidget {
  const TitleTableWidget({
    super.key,
    required this.title,
    required this.color,
  });
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.2)),
      height: 30,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}
