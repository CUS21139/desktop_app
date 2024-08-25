import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../models/producto_vivo.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/ayer_hoy_provider.dart';
import '../../providers/compras_vivo_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/utils/colors.dart';
import '/src/presentation/utils/round_number.dart';

import '/src/services/proveedores_service.dart';
import '../../../services/compras_vivos_service.dart';

import '/src/utils/date_formats.dart';

class TableComprasVivos extends StatefulWidget {
  const TableComprasVivos({super.key, required this.height});
  final double height;

  @override
  State<TableComprasVivos> createState() => _TableComprasVivosState();
}

class _TableComprasVivosState extends State<TableComprasVivos> {
  final compraServ = ComprasVivosService();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final globalWidth = width <= 1366 ? 960.0 : 1000.0;
    return Column(
      children: [
        SizedBox(
          width: globalWidth,
          child: Consumer<ComprasVivoProv>(builder: (_, service, __) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RefreshButton(onPressed: () => refresh(context)),
                const Spacer(),
                CustomButton(
                  title: 'Editar',
                  color: greenColor,
                  iconData: FluentIcons.edit,
                  onPressed:
                      service.existeCompra ? () => update(context) : null,
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Borrar',
                  color: redColor,
                  iconData: FluentIcons.delete,
                  onPressed:
                      service.existeCompra ? () => delete(context) : null,
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: widget.height,
            width: globalWidth,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Consumer<ComprasVivoProv>(builder: (_, service, __) {
                final lista = service.compras;
                return HorizontalDataTable(
                  isFixedHeader: true,
                  rightHandSideColBackgroundColor:
                      Colors.white.withOpacity(0.8),
                  leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
                  headerWidgets: [
                    const CellTitle(text: '', width: 0),
                    CellTitle(text: 'Fecha', width: width <= 1366 ? 80 : 100),
                    const CellTitle(text: 'Proveedor', width: 140),
                    const CellTitle(text: 'Producto', width: 140),
                    const CellTitle(text: 'Promedio', width: 120),
                    const CellTitle(text: 'Nro Aves', width: 80),
                    const CellTitle(text: 'Nro Jabas', width: 80),
                    CellTitle(text: 'Precio', width: width <= 1366 ? 80 : 100),
                    const CellTitle(text: 'Peso Total'),
                    const CellTitle(text: 'Importe Total', width: 140),
                  ],
                  isFixedFooter: true,
                  footerWidgets: [
                    const CellTitle(text: '', width: 0),
                    CellTitle(text: '', width: width <= 1366 ? 80 : 100),
                    const CellTitle(text: '', width: 140),
                    const CellTitle(text: '', width: 140),
                    const CellTitle(text: '', width: 120),
                    CellTitle(
                        text: service.sumNroAves.toStringAsFixed(0), width: 80),
                    CellTitle(
                        text: service.sumNroJabas.toStringAsFixed(0),
                        width: 80),
                    CellTitle(text: '-', width: width <= 1366 ? 80 : 100),
                    CellTitle(text: '${service.sumPeso.toStringAsFixed(2)} kg'),
                    CellTitle(
                        text: 'S/ ${service.sumImporte.toStringAsFixed(2)}',
                        width: 140),
                  ],
                  itemCount: lista.length,
                  leftHandSideColumnWidth: 0,
                  leftSideItemBuilder: (c, i) => const SizedBox(),
                  rightHandSideColumnWidth: globalWidth,
                  rightSideItemBuilder: (c, i) {
                    final compra = lista[i];
                    return GestureDetector(
                      onTap: () {
                        if (service.existeCompra) {
                          if (service.compra == compra) {
                            service.compraInitState();
                          } else {
                            service.compra = compra;
                          }
                        } else {
                          service.compra = compra;
                        }
                      },
                      child: Container(
                        color: service.existeCompra
                            ? compra == service.compra
                                ? Colors.blue.withOpacity(0.3)
                                : null
                            : null,
                        child: Row(
                          children: [
                            CellItem(
                                text: date.format(compra.createdAt),
                                width: width <= 1366 ? 80 : 100),
                            CellItem(text: compra.proveedorNombre, width: 140),
                            CellItem(text: compra.productoNombre, width: 140),
                            CellItem(text: (compra.promedio).toStringAsFixed(2), width: 120),
                            CellItem(
                              text: compra.cantAves.toStringAsFixed(0),
                              width: 80,
                            ),
                            CellItem(
                              text: compra.cantJabas.toStringAsFixed(0),
                              width: 80,
                            ),
                            CellItem(
                                text: 'S/ ${compra.precio.toStringAsFixed(4)}',
                                width: width <= 1366 ? 80 : 100),
                            CellItem(
                                text:
                                    '${compra.pesoTotal.toStringAsFixed(2)} kg'),
                            CellItem(
                              text:
                                  'S/ ${compra.importeTotal.toStringAsFixed(2)}',
                              width: 140,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void refresh(BuildContext context) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await compraServ.getCompras(token, ini, fin).then((value) async {
      compraProv.compras = value;
      compraProv.comprasResumen = value;
      compraProv.compraInitState();
      await ProveedoresService().getProveedores(token).then((value) {
        proveedorProv.proveedores = value;
        Navigator.pop(context);
      });
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void update(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    ProductoVivo? producto;
    final productoCtrl = TextEditingController();
    final avesCtrl = TextEditingController();
    final jabasCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final pesoCtrl = TextEditingController();

    final compra = compraProv.compra;

    productoCtrl.text = compra.productoNombre;
    jabasCtrl.text = compra.cantJabas.toString();
    avesCtrl.text = (compra.cantAves / compra.cantJabas).toStringAsFixed(0);
    precioCtrl.text = (compra.precio).toStringAsFixed(2);
    pesoCtrl.text = roundNumber(compra.pesoTotal).toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Compra',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Producto',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 400,
              child: Consumer<ProductosVivoProv>(
                builder: (_, service, __) {
                  return AutoSuggestBox<ProductoVivo>(
                    controller: productoCtrl,
                    placeholder: 'Producto',
                    items: service.productos
                        .map((e) => AutoSuggestBoxItem<ProductoVivo>(
                            value: e,
                            label: e.nombre,
                            child: Text(e.nombre,
                                overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onSelected: (item) {
                      setState(() => producto = item.value);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: avesCtrl,
              title: 'Aves x Jaba',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: jabasCtrl,
              title: 'Cant Jabas',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: precioCtrl,
              title: 'Precio (S/)',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: pesoCtrl,
              title: 'Peso (kg)',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              final jabas = int.parse(jabasCtrl.text);
              final aves = int.parse(avesCtrl.text) * jabas;
              final precio = double.parse(precioCtrl.text);
              final peso = double.parse(pesoCtrl.text);

              Navigator.pop(context);
              try {
                CustomDialog.loadingDialog(context);
                final newCompra = compra.copyWith(
                    newProducto: producto,
                    newCantJabas: jabas,
                    newCantAves: aves,
                    newPeso: peso,
                    newPrecio: precio,
                    newImporte: precio * peso);
                await compraServ
                    .updateCompra(newCompra, token)
                    .then((value) async {
                  if (value) {
                    await ProveedoresService()
                        .getProveedores(token)
                        .then((value) {
                      proveedorProv.proveedores = value;
                    });
                    await compraServ.getCompras(token, ini, fin).then((value) {
                      compraProv.compras = value;
                      compraProv.comprasResumen = value;
                      compraProv.compraInitState();
                      Navigator.pop(context);
                    });
                  }
                });
              } catch (e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void delete(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final compra = compraProv.compra;
    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text('Eliminar Compra', style: TextStyle(fontSize: 16)),
        content: const Text('¿Desea eliminar esta compra?'),
        actions: [
          FilledButton(
            child: const Text('Eliminar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                CustomDialog.loadingDialog(context);
                await compraServ
                    .deleteCompra(compra, token)
                    .then((value) async {
                  if (value) {
                    await ProveedoresService()
                        .getProveedores(token)
                        .then((value) {
                      proveedorProv.proveedores = value;
                    });
                    await compraServ.getCompras(token, ini, fin).then((value) {
                      compraProv.compras = value;
                      compraProv.comprasResumen = value;
                      compraProv.compraInitState();
                      Navigator.pop(context);
                    });
                  }
                });
              } catch (e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              }
            },
          ),
          Button(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
