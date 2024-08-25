import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/compras_vivo_provider.dart';
import '../../providers/ventas_vivo_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/utils/colors.dart';
import '/src/presentation/utils/text_style.dart';
import '/src/services/resumen__service.dart';

class ResumenPorProductoVivo extends StatelessWidget {
  const ResumenPorProductoVivo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final ventasProv = Provider.of<VentasVivoProv>(context);
    final comprasProv = Provider.of<ComprasVivoProv>(context);
    final productoProv = Provider.of<ProductosVivoProv>(context);
    final difAves = ventasProv.totalAvesResumen - comprasProv.sumNroAvesResumen;
    final difPeso = ventasProv.totalPesoResumen - comprasProv.sumPesoResumen;
    final difImporte = ventasProv.totalImporteResumen - comprasProv.sumImporteResumen;
    Map<String, Map<String, dynamic>> map =
        TableResumenCtrl.mapResumenVentaCompra(
      productos: productoProv.productos,
      ventas: ventasProv.ventasResumen,
      compras: comprasProv.comprasResumen,
    );

    final globalWidth = size.width <= 1366 ? 960.0 : 1065.0;
    final productoWidth = size.width <= 1366 ? 177.0 : 195.0;
    final titleWidth = size.width <= 1366 ? 261.0 : 285.0;

    return Padding(
      padding: EdgeInsets.all(size.width <= 1366 ? 5 : 10),
      child: Container(
        width: globalWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: productoWidth,
                  decoration: const BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Producto', style: titleTableStyle),
                ),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                Column(
                  children: [
                    Container(
                      height: 25,
                      width: titleWidth,
                      alignment: Alignment.center,
                      color: blueColor,
                      child: const Text('Compra', style: titleTableStyle),
                    ),
                    const Row(
                      children: [
                        CustomCellResumen(
                            title: 'Cantidad',
                            color: blueColor,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Peso',
                            color: blueColor,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Importe',
                            color: blueColor,
                            style: titleTableStyle),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                Column(
                  children: [
                    Container(
                      height: 25,
                      width: titleWidth,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: const Text('Venta', style: titleTableStyle),
                    ),
                    const Row(
                      children: [
                        CustomCellResumen(
                            title: 'Cantidad',
                            color: Colors.green,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Peso',
                            color: Colors.green,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Importe',
                            color: Colors.green,
                            style: titleTableStyle),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                Column(
                  children: [
                    Container(
                      height: 25,
                      width: titleWidth,
                      decoration: const BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Diferencia', style: titleTableStyle),
                    ),
                    const Row(
                      children: [
                        CustomCellResumen(
                            title: 'Cantidad',
                            color: redColor,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Peso',
                            color: redColor,
                            style: titleTableStyle),
                        CustomCellResumen(
                            title: 'Importe',
                            color: redColor,
                            style: titleTableStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: globalWidth,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(5),
              )),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  final productoName = map.keys.elementAt(i);
                  final ventaCantidad =
                      map.values.elementAt(i)['venta']['cantidad'];
                  final ventaPeso = map.values.elementAt(i)['venta']['peso'];
                  final ventaImporte =
                      map.values.elementAt(i)['venta']['importe'];
                  final compraCantidad =
                      map.values.elementAt(i)['compra']['cantidad'];
                  final compraPeso = map.values.elementAt(i)['compra']['peso'];
                  final compraImporte =
                      map.values.elementAt(i)['compra']['importe'];
                  final diferenciaCantidad =
                      (ventaCantidad ?? 0) - (compraCantidad ?? 0);
                  final diferenciaPeso = (ventaPeso ?? 0) - (compraPeso ?? 0);
                  final diferenciaImporte =
                      (ventaImporte ?? 0) - (compraImporte ?? 0);
                  return Row(
                    children: [
                      Container(
                        height: 30,
                        width: productoWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              i % 2 == 0 ? Colors.grey[300] : Colors.grey[400],
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child:
                              Text(productoName, style: cellDataResumenStyle),
                        ),
                      ),
                      SizedBox(width: size.width <= 1366 ? 0 : 5),
                      CustomCellResumen(
                          title: compraCantidad.toString(),
                          color:
                              i % 2 == 0 ? Colors.blue[100] : Colors.blue[200],
                          style: cellDataResumenStyle),
                      CustomCellResumen(
                          title: '${compraPeso.toStringAsFixed(2)} kg',
                          color:
                              i % 2 == 0 ? Colors.blue[100] : Colors.blue[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                      CustomCellResumen(
                          title: 'S/ ${compraImporte.toStringAsFixed(2)}',
                          color:
                              i % 2 == 0 ? Colors.blue[100] : Colors.blue[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                      SizedBox(width: size.width <= 1366 ? 0 : 5),
                      CustomCellResumen(
                          title: ventaCantidad.toString(),
                          color: i % 2 == 0
                              ? Colors.green[100]
                              : Colors.green[200],
                          style: cellDataResumenStyle),
                      CustomCellResumen(
                          title: '${ventaPeso.toStringAsFixed(2)} kg',
                          color: i % 2 == 0
                              ? Colors.green[100]
                              : Colors.green[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                      CustomCellResumen(
                          title: 'S/ ${ventaImporte.toStringAsFixed(2)}',
                          color: i % 2 == 0
                              ? Colors.green[100]
                              : Colors.green[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                      SizedBox(width: size.width <= 1366 ? 0 : 5),
                      CustomCellResumen(
                          title: diferenciaCantidad.toString(),
                          color: i % 2 == 0 ? Colors.red[100] : Colors.red[200],
                          style: cellDataResumenStyle),
                      CustomCellResumen(
                          title: '${diferenciaPeso.toStringAsFixed(2)} kg',
                          color: i % 2 == 0 ? Colors.red[100] : Colors.red[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                      CustomCellResumen(
                          title: 'S/ ${diferenciaImporte.toStringAsFixed(2)}',
                          color: i % 2 == 0 ? Colors.red[100] : Colors.red[200],
                          style: cellDataResumenStyle,
                          align: Alignment.centerRight),
                    ],
                  );
                },
                itemCount: map.keys.length,
              ),
            ),
            Row(
              children: [
                Container(
                  height: 30,
                  width: productoWidth,
                  decoration: const BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                CustomCellResumen(
                    title: comprasProv.sumNroAvesResumen.toStringAsFixed(0),
                    color: blueColor,
                    style: titleResumenStyle),
                CustomCellResumen(
                    title: '${comprasProv.sumPesoResumen.toStringAsFixed(2)} kg',
                    align: Alignment.centerRight,
                    color: blueColor,
                    style: titleResumenStyle),
                CustomCellResumen(
                    title: 'S/ ${comprasProv.sumImporteResumen.toStringAsFixed(2)}',
                    align: Alignment.centerRight,
                    color: blueColor,
                    style: titleResumenStyle),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                CustomCellResumen(
                    title: ventasProv.totalAvesResumen.toStringAsFixed(0),
                    color: Colors.green,
                    style: titleResumenStyle),
                CustomCellResumen(
                    title: '${ventasProv.totalPesoResumen.toStringAsFixed(2)} kg',
                    align: Alignment.centerRight,
                    color: Colors.green,
                    style: titleResumenStyle),
                CustomCellResumen(
                    title: 'S/ ${ventasProv.totalImporteResumen.toStringAsFixed(2)}',
                    align: Alignment.centerRight,
                    color: Colors.green,
                    style: titleResumenStyle),
                SizedBox(width: size.width <= 1366 ? 0 : 5),
                CustomCellResumen(
                    title: difAves.toStringAsFixed(0),
                    color: redColor,
                    style: titleResumenStyle),
                CustomCellResumen(
                    title: '${difPeso.toStringAsFixed(2)} kg',
                    color: redColor,
                    align: Alignment.centerRight,
                    style: titleResumenStyle),
                Container(
                  height: 30,
                  width: size.width <= 1366 ? 87 : 95,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('S/ ${difImporte.toStringAsFixed(2)}',
                          style: titleResumenStyle)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCellResumen extends StatelessWidget {
  const CustomCellResumen(
      {super.key,
      required this.title,
      this.color,
      this.style,
      this.align = Alignment.center});
  final String title;
  final Color? color;
  final TextStyle? style;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 30,
      width: width <= 1366 ? 87 : 95,
      padding: const EdgeInsets.all(3),
      color: color,
      alignment: align,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(title, style: style),
      ),
    );
  }
}
