// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/zona.dart';
import '/src/models/ordenes_beneficiado.dart';
import '/src/models/producto_beneficiado.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_excel.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/ayer_hoy_ben_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_modelo_beneficiado_provider.dart';
import '/src/presentation/providers/productos_beneficiado_provider.dart';
import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import '/src/presentation/utils/colors.dart';
import '/src/services/clientes_service.dart';
import '/src/services/excel_service.dart';
import '/src/services/ordenes_beneficiado_service.dart';
import '/src/utils/date_formats.dart';

class TableOrdenesBeneficiado extends StatefulWidget {
  const TableOrdenesBeneficiado({super.key, required this.height});
  final double height;

  @override
  State<TableOrdenesBeneficiado> createState() => _TableOrdenesBeneficiadoState();
}

class _TableOrdenesBeneficiadoState extends State<TableOrdenesBeneficiado> {
  final ordenServ = OrdenesBeneficiadoService();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final globalWidth = width <= 1366 ? 960.0 : 980.0;
    return Column(
      children: [
        SizedBox(
          width: globalWidth,
          child: Consumer<OrdenesBeneficiadoProv>(builder: (_, service, __) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RefreshButton(onPressed: () => refresh(context)),
                const SizedBox(width: 10),
                ExcelButton(
                  onPressed: () async => await ExcelService()
                      .exportarProgamacion(lista: service.ordenes)
                      .catchError((e) =>
                          CustomDialog.errorDialog(context, e.toString())),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Autogen',
                  color: darkBlueColor,
                  iconData: FluentIcons.add,
                  onPressed: () => autogen(),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Edit Aves',
                  color: Colors.blue.dark,
                  iconData: FluentIcons.edit,
                  onPressed: () => editAves(),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Edit Precio',
                  color: Colors.green.dark,
                  iconData: FluentIcons.edit,
                  onPressed: () => editPrecio(),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Descontar',
                  color: Colors.orange.darkest,
                  iconData: FluentIcons.edit,
                  onPressed: () => descontarPrecio(),
                ),
                const Spacer(),
                CustomButton(
                  title: 'Editar',
                  color: greenColor,
                  iconData: FluentIcons.edit,
                  onPressed: service.existeOrden ? () => update(context) : null,
                ),
                const SizedBox(width: 10),
                CustomButton(
                  title: 'Borrar Seleccion',
                  color: redColor,
                  iconData: FluentIcons.delete,
                  onPressed: service.selectCount > 0
                      ? () => deleteSeleccion(context)
                      : null,
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
              child: Consumer<OrdenesBeneficiadoProv>(builder: (_, service, __) {
                final lista = service.ordenes;
                return HorizontalDataTable(
                  isFixedHeader: true,
                  rightHandSideColBackgroundColor:
                      Colors.white.withOpacity(0.8),
                  leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
                  headerWidgets: [
                    const CellTitle(text: '', width: 0),
                    const CellTitle(text: 'Selec', width: 60),
                    CellTitle(
                      text: 'Fecha',
                      width: width <= 1366 ? 80 : 100,
                    ),
                    const CellTitle(text: 'Producto', width: 120),
                    const CellTitle(text: 'Camal'),
                    const CellTitle(text: 'Cliente', width: 120),
                    const CellTitle(text: 'Aves', width: 60),
                    const CellTitle(text: 'Jabas', width: 60),
                    const CellTitle(text: 'Precio', width: 80),
                    const CellTitle(text: 'Pelado', width: 80),
                    const CellTitle(text: 'Conf ADM', width: 80),
                    const CellTitle(text: 'Observacion', width: 120),
                  ],
                  isFixedFooter: true,
                  footerWidgets: [
                    const CellTitle(text: '', width: 0),
                    const CellTitle(text: '', width: 60),
                    const CellTitle(text: ''),
                    const CellTitle(text: '', width: 120),
                    const CellTitle(text: ''),
                    const CellTitle(text: '', width: 120),
                    CellTitle(
                      text: service.sumNroAves.toStringAsFixed(0),
                      width: 60,
                    ),
                    CellTitle(
                      text: service.sumNroJabas.toStringAsFixed(0),
                      width: 60,
                    ),
                    const CellTitle(text: '-', width: 80),
                    const CellTitle(text: '', width: 80),
                    const CellTitle(text: '', width: 80),
                    const CellTitle(text: '', width: 120),
                  ],
                  itemCount: lista.length,
                  leftHandSideColumnWidth: 0,
                  leftSideItemBuilder: (c, i) => const SizedBox(),
                  rightHandSideColumnWidth: globalWidth,
                  rightSideItemBuilder: (c, i) {
                    final orden = lista[i];
                    return GestureDetector(
                      onTap: orden.delivered == 1
                          ? null
                          : () {
                              OrdenBeneficiado.fromJson(orden.toJson());
                              if (service.existeOrden) {
                                if (service.orden == orden) {
                                  service.ordenInitState();
                                } else {
                                  service.orden = orden;
                                }
                              } else {
                                service.orden = orden;
                              }
                            },
                      child: Container(
                        color: orden.delivered! == 1
                            ? ligthGreyColor.withOpacity(0.5)
                            : service.existeOrden && orden == service.orden
                                ? Colors.blue.withOpacity(0.3)
                                : orden.precio == 0
                                    ? Colors.yellow
                                    : orden.confirm == 1
                                    ? Colors.white
                                    : orden.confirmAdm == 1
                                        ? Colors.green.withOpacity(0.4)
                                        : Colors.red.withOpacity(0.3),
                        child: Row(
                          children: [
                            Container(
                              height: 35,
                              width: 60,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  left: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    orden.isSelected
                                        ? FluentIcons.checkbox_fill
                                        : FluentIcons.checkbox,
                                    color: redColor,
                                  ),
                                  onPressed: orden.confirm == 1
                                      ? () => CustomDialog.messageDialog(
                                          context,
                                          'No se puede selecionar la Orden de Pedido',
                                          const Text(
                                            'Esta orden esta confirmada, no es posible seleccionarla para eliminar. Desmarque la casilla de confirmado si desea elminar la orden.',
                                          ))
                                      : orden.delivered == 0
                                          ? () => service.actualizarSeleccion(i)
                                          : null,
                                ),
                              ),
                            ),
                            CellItem(text: date.format(orden.createdAt)),
                            CellItem(text: orden.productoNombre, width: 120),
                            CellItem(text: orden.camalNombre),
                            CellItem(text: orden.clienteNombre, width: 120),
                            CellItem(
                                text: orden.cantAves.toString(), width: 60),
                            CellItem(
                                text: orden.cantJabas.toString(), width: 60),
                            CellItem(
                                text: orden.precio.toStringAsFixed(2),
                                width: 80),
                            CellItem(
                                text: orden.precioPelado.toStringAsFixed(2),
                                width: 80),
                            Container(
                              height: 35,
                              width: 80,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  left: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    orden.confirm == 1
                                        ? FluentIcons.checkbox_fill
                                        : FluentIcons.checkbox,
                                    color: greenColor,
                                  ),
                                  onPressed: orden.delivered == 0
                                      ? () => confirmarOrden(context, orden)
                                      : null,
                                ),
                              ),
                            ),
                            CellItem(text: orden.observacion ?? '', width: 120),
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
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);
    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await ordenServ.getOrdenes(token, ini, fin).then((value) {
      ordenProv.ordenes = value;
      ordenProv.ordenesResumen = value;
      Navigator.pop(context);
    }).catchError((e) {
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void autogen() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final clientesProv = Provider.of<ClientesProv>(context, listen: false);
    final ordenesProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ordenesModeloProv =
        Provider.of<OrdenesModeloBeneficiadoProv>(context, listen: false);

    final productos =
        Provider.of<ProductosBeneficiadoProv>(context, listen: false).productos;

    Zona? zona;
    final zonaCtrl = TextEditingController();

    final now = DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Generar Ordenes por Zona',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Elije una Zona'),
            Consumer<ZonasProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<Zona>(
                  controller: zonaCtrl,
                  placeholder: 'Zona',
                  items: service.zonas
                      .map((e) => AutoSuggestBoxItem<Zona>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => zona = item.value);
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Generar'),
            onPressed: () async {
              Navigator.pop(context);
              if (zona == null) {
                CustomDialog.errorDialog(context, 'Elija una zona');
              } else if (ordenesProv.ordenes
                  .any((e) => e.zonaCode == zona!.zonaCode)) {
                CustomDialog.errorDialog(
                    context, 'Ya existen ordenes para esta zona');
              } else {
                try {
                  CustomDialog.loadingDialog(context);
                  await ClientesService()
                      .getClientes(token)
                      .then((value) async {
                    clientesProv.clientes = value;
                    Map<String, double> map = {};
                    List<OrdenBeneficiado> ordenesGenerar = [];
                    for (var orden in ordenesModeloProv.ordenes) {
                      if (orden.zonaCode == zona!.zonaCode) {
                        final cliente = clientesProv.clientes
                            .singleWhere((e) => e.id! == orden.clienteId);
                        if (cliente.inRangeMin) {
                          ordenesGenerar.add(orden);
                        } else if (cliente.inRangeMax) {
                          ordenesGenerar.add(orden);
                        } else {
                          map.putIfAbsent(
                              orden.clienteNombre, () => cliente.saldo!);
                        }
                      }
                    }
                    if (map.isNotEmpty) {
                      Navigator.pop(context);
                      CustomDialog.autogenerarDialog(
                        context,
                        map,
                        () async {
                          Navigator.pop(context);
                          CustomDialog.loadingDialog(context);
                          for (var ordenGen in ordenesGenerar) {
                            final prod = productos.singleWhere(
                                (p) => p.id == ordenGen.productoId);
                            await ordenServ.insertOrden(
                              ordenGen.copyWith(
                                  newCratedAt: DateTime.now(),
                                  newProducto: prod),
                              token,
                            );
                          }
                          await ordenServ
                              .getOrdenes(token, ini, fin)
                              .then((value) {
                            ordenesProv.ordenes = value;
                            ordenesProv.ordenesResumen = value;
                            Navigator.pop(context);
                          });
                        },
                      );
                    } else {
                      for (var ordenGen in ordenesGenerar) {
                        final prod = productos
                            .singleWhere((p) => p.id == ordenGen.productoId);
                        await ordenServ.insertOrden(
                          ordenGen.copyWith(
                              newCratedAt: DateTime.now(), newProducto: prod),
                          token,
                        );
                      }
                      await ordenServ.getOrdenes(token, ini, fin).then((value) {
                        ordenesProv.ordenes = value;
                        ordenesProv.ordenesResumen = value;
                        Navigator.pop(context);
                      });
                    }
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
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

  void update(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenesProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    Camal? uCamal;
    final uCamalCtrl = TextEditingController();
    Cliente? uCliente;
    final uClienteCtrl = TextEditingController();
    ProductoBeneficiado? uProducto;
    final uProductoCtrl = TextEditingController();

    final zonaCtrl = TextEditingController();
    final pesadorCtrl = TextEditingController();
    final avesCtrl = TextEditingController();
    final jabasCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final uObservacionCtrl = TextEditingController();

    final orden = ordenesProv.orden;
    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    zonaCtrl.text = orden.zonaCode;
    pesadorCtrl.text = orden.pesadorNombre;
    uCamalCtrl.text = orden.camalNombre;
    uClienteCtrl.text = orden.clienteNombre;
    uProductoCtrl.text = orden.productoNombre;
    jabasCtrl.text = orden.cantJabas.toString();
    avesCtrl.text = (orden.cantAves / orden.cantJabas).toStringAsFixed(0);
    precioCtrl.text = (orden.precio).toStringAsFixed(2);
    uObservacionCtrl.text = orden.observacion ?? '';

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Orden',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
                controller: zonaCtrl,
                title: 'Zona',
                readOnly: true,
                width: 400),
            const SizedBox(height: 10),
            CustomTextBox(
                controller: pesadorCtrl,
                title: 'Pesador',
                readOnly: true,
                width: 400),
            const SizedBox(height: 10),
            const Text(
              'Camal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Consumer<CamalesProv>(
              builder: (_, service, __) {
                final camales = service.camales
                    .where((camal) => camal.zonaCode == orden.zonaCode)
                    .toList();
                camales.sort((a, b) => a.nombre.compareTo(b.nombre));
                return AutoSuggestBox<Camal>(
                  controller: uCamalCtrl,
                  placeholder: 'Camal',
                  items: camales
                      .map(
                        (e) => AutoSuggestBoxItem<Camal>(
                            value: e,
                            label: e.nombre,
                            child: Text(
                              e.nombre,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )
                      .toList(),
                  onSelected: (item) {
                    setState(() => uCamal = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Cliente',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Consumer<ClientesProv>(
              builder: (_, service, __) {
                final clientes = service.clientes
                    .where((cliente) => cliente.zonaCode == orden.zonaCode)
                    .toList();
                clientes.sort((a, b) => a.nombre.compareTo(b.nombre));
                return AutoSuggestBox<Cliente>(
                  controller: uClienteCtrl,
                  placeholder: 'Cliente',
                  items: clientes
                      .map((e) => AutoSuggestBoxItem<Cliente>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => uCliente = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Producto',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: uProductoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => uProducto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: avesCtrl,
              title: 'Cant Aves',
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
              controller: uObservacionCtrl,
              title: 'Observacion',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);
              await ClientesService()
                  .getCliente(
                      token, uCliente != null ? uCliente!.id! : orden.clienteId)
                  .then((value) async {
                if (!value.inRangeMax) {
                  CustomDialog.errorDialog(
                    context,
                    'No se puede actualizar la Orden, el cliente ${value.nombre} tiene una deuda de S/ ${value.saldo!.toStringAsFixed(2)}',
                  );
                  return;
                }
                if (!value.inRangeMin) {
                  CustomDialog.errorDialog(
                    context,
                    'No se puede actualizar la Orden, el cliente ${value.nombre} debe tener al menos S/ ${value.saldoMinimo!.toStringAsFixed(2)} como saldo.',
                  );
                  return;
                }
                try {
                  final jabas = int.parse(jabasCtrl.text);
                  final aves = int.parse(avesCtrl.text) * jabas;
                  final precio = double.parse(precioCtrl.text);
                  CustomDialog.loadingDialog(context);
                  final newOrden = orden.copyWith(
                      newCamal: uCamal,
                      newCliente: value,
                      newProducto: uProducto,
                      newCantJabas: jabas,
                      newCantAves: aves,
                      newPrecio: precio,
                      newObservacion: uObservacionCtrl.text);
                  await ordenServ
                      .updateOrden(newOrden, token)
                      .then((value) async {
                    if (value) {
                      await ordenServ.getOrdenes(token, ini, fin).then((value) {
                        ordenesProv.ordenes = value;
                        ordenesProv.ordenesResumen = value;
                        Navigator.pop(context);
                      });
                    }
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
              });
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

  void deleteSeleccion(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text('Eliminar Ordenes', style: TextStyle(fontSize: 16)),
        content: Text('Se eliminarán ${ordenProv.selectCount} ordenes'),
        actions: [
          FilledButton(
            child: const Text('Eliminar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                CustomDialog.loadingDialog(context);
                for (var orden in ordenProv.ordenes) {
                  if (orden.isSelected) {
                    await ordenServ.deleteOrden(orden, token);
                  }
                }
                await ordenServ.getOrdenes(token, ini, fin).then((value) {
                  ordenProv.ordenes = value;
                  ordenProv.ordenesResumen = value;
                  Navigator.pop(context);
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

  void confirmarOrden(BuildContext context, OrdenBeneficiado orden) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final newConfirm = orden.confirm == 1 ? 0 : 1;
    final newOrden = orden.copyWith(newConfirm: newConfirm);
    CustomDialog.loadingDialog(context);

    final cliente = await ClientesService().getCliente(token, orden.clienteId);

    if (!cliente.inRangeMax) {
      Navigator.pop(context);
      CustomDialog.errorDialog(
        context,
        'No se puede actualizar la Orden, el cliente ${cliente.nombre} tiene una deuda de S/ ${cliente.saldo!.toStringAsFixed(2)}',
      );
      return;
    }
    if (!cliente.inRangeMin) {
      Navigator.pop(context);
      CustomDialog.errorDialog(
        context,
        'No se puede actualizar la Orden, el cliente ${cliente.nombre} debe tener al menos S/ ${cliente.saldoMinimo!.toStringAsFixed(2)} como saldo.',
      );
      return;
    }

    await ordenServ.updateOrden(newOrden, token).then((value) async {
      if (value) {
        await ordenServ.getOrdenes(token, ini, fin).then((list) {
          ordenProv.ordenes = list;
          Navigator.pop(context);
        });
      }
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void editPrecio() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    ProductoBeneficiado? producto;
    final productoCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Editar Precio',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: productoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => producto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: precioCtrl,
              title: 'Precio (S/)',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);
              if (producto == null) {
                CustomDialog.errorDialog(context, 'Elija un producto');
              } else {
                try {
                  CustomDialog.loadingDialog(context);
                  final precio = double.parse(precioCtrl.text);
                  for (var orden in ordenProv.ordenes) {
                    if (orden.delivered != 1) {
                      if (orden.productoId == producto!.id) {
                        final newOrden = orden.copyWith(newPrecio: precio);
                        await ordenServ.updateOrden(newOrden, token);
                      }
                    }
                  }
                  ordenServ.getOrdenes(token, ini, fin).then((value) {
                    ordenProv.ordenes = value;
                    ordenProv.ordenInitState();
                    Navigator.pop(context);
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
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

  void editAves() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    ProductoBeneficiado? producto;
    final productoCtrl = TextEditingController();
    final avesCtrl = TextEditingController();

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Editar Cant Aves',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ProductosBeneficiadoProv>(
              builder: (_, service, __) {
                return AutoSuggestBox<ProductoBeneficiado>(
                  controller: productoCtrl,
                  placeholder: 'Producto',
                  items: service.productos
                      .map((e) => AutoSuggestBoxItem<ProductoBeneficiado>(
                          value: e,
                          label: e.nombre,
                          child:
                              Text(e.nombre, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onSelected: (item) {
                    setState(() => producto = item.value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: avesCtrl,
              title: 'Cant Aves',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              Navigator.pop(context);
              if (producto == null) {
                CustomDialog.errorDialog(context, 'Elija un producto');
              } else {
                try {
                  final aves = int.parse(avesCtrl.text);
                  CustomDialog.loadingDialog(context);
                  for (var orden in ordenProv.ordenes) {
                    if (orden.delivered != 1) {
                      if (orden.productoId == producto!.id) {
                        final newJabas = (orden.cantAves / aves).round();
                        final newAves = (aves * newJabas).round();
                        final newOrden = orden.copyWith(
                          newCantAves: newAves,
                          newCantJabas: newJabas,
                        );
                        await ordenServ.updateOrden(newOrden, token);
                      }
                    }
                  }
                  ordenServ.getOrdenes(token, ini, fin).then((value) {
                    ordenProv.ordenes = value;
                    ordenProv.ordenesResumen = value;
                    ordenProv.ordenInitState();
                    Navigator.pop(context);
                  });
                } catch (e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                }
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

  void descontarPrecio() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ordenProv = Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyBenProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final precioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Descontar Precio',
          style: TextStyle(fontSize: 16),
        ),
        content: CustomTextBox(
          controller: precioCtrl,
          title: 'Descontar (S/)',
          width: 400,
        ),
        actions: [
          FilledButton(
            child: const Text('Confirmar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final descuento = double.parse(precioCtrl.text);
                CustomDialog.loadingDialog(context);
                for (var orden in ordenProv.ordenes) {
                  final newPrecio = descuento + orden.precio;
                  final newOrden = orden.copyWith(newPrecio: newPrecio);
                  await ordenServ.updateOrden(newOrden, token);
                }
                ordenServ.getOrdenes(token, ini, fin).then((value) {
                  ordenProv.ordenes = value;
                  ordenProv.ordenInitState();
                  Navigator.pop(context);
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
