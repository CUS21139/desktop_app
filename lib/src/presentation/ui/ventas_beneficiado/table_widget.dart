// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/pesaje.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_excel.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/ayer_hoy_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/providers/ventas_beneficiado_provider.dart';
import '/src/presentation/utils/colors.dart';

import '/src/services/clientes_service.dart';
import '/src/services/excel_service.dart';
import '/src/services/ventas_beneficiado_service.dart';
import '/src/utils/date_formats.dart';

class TableVentasBeneficiado extends StatefulWidget {
  const TableVentasBeneficiado({super.key, required this.height});
  final double height;

  @override
  State<TableVentasBeneficiado> createState() => _TableVentasBeneficiadoState();
}

class _TableVentasBeneficiadoState extends State<TableVentasBeneficiado> {
  final ventaServ = VentasBeneficiadoService();
  final globalWidth = 970.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: globalWidth,
          child: Consumer<VentasBeneficiadoProv>(builder: (_, service, __) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RefreshButton(onPressed: () => refresh(context)),
                const SizedBox(width: 20),
                ExcelButton(
                  onPressed: () async {
                    await ExcelService()
                        .exportarReporteDelDiaBeneficiado(lista: service.ventas);
                  },
                ),
                const Spacer(),
                service.ventas.isNotEmpty
                    ? Text(
                        'Fecha: ${date.format(service.ventas[0].ordenDate)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const SizedBox.shrink(),
                const Spacer(),
                CustomButton(
                  title: 'Descontar',
                  color: ligthBlueColor,
                  iconData: FluentIcons.remove_filter,
                  onPressed:
                      service.existeVenta ? () => descontar(context) : null,
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Editar Precio',
                  color: greenColor,
                  iconData: FluentIcons.edit,
                  onPressed:
                      service.existeVenta ? () => editarPrecio(context) : null,
                ),
                const SizedBox(width: 20),
                CustomButton(
                  title: 'Anular',
                  color: redColor,
                  iconData: FluentIcons.skype_circle_minus,
                  onPressed: service.existeVenta ? () => anular(context) : null,
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
            width: 930,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Consumer<VentasBeneficiadoProv>(builder: (_, service, __) {
                final lista = service.ventas;
                return HorizontalDataTable(
                  isFixedHeader: true,
                  rightHandSideColBackgroundColor:
                      Colors.white.withOpacity(0.8),
                  leftHandSideColBackgroundColor: Colors.white.withOpacity(0.8),
                  headerWidgets: const [
                    CellTitle(text: '', width: 0),
                    CellTitle(text: 'Doc ID'),
                    CellTitle(text: 'Cliente', width: 120),
                    CellTitle(text: 'Producto', width: 120),
                    CellTitle(text: 'Aves'),
                    CellTitle(text: 'Promedio'),
                    CellTitle(text: 'Peso Neto'),
                    CellTitle(text: 'Precio', width: 70),
                    CellTitle(text: 'Importe'),
                    CellTitle(text: 'Observaciones', width: 120),
                  ],
                  isFixedFooter: true,
                  footerWidgets: [
                    const CellTitle(text: '', width: 0),
                    const CellTitle(text: ''),
                    const CellTitle(text: '', width: 120),
                    const CellTitle(text: '', width: 120),
                    CellTitle(text: service.totalAves.toString()),
                    const CellTitle(text: ''),
                    CellTitle(text: service.totalPeso.toStringAsFixed(2)),
                    const CellTitle(text: '', width: 70),
                    CellTitle(text: service.totalImporte.toStringAsFixed(2)),
                    const CellTitle(text: '', width: 120),
                  ],
                  itemCount: lista.length,
                  leftHandSideColumnWidth: 0,
                  leftSideItemBuilder: (c, i) => const SizedBox(),
                  rightHandSideColumnWidth: 930,
                  rightSideItemBuilder: (c, i) {
                    final venta = lista[i];
                    return GestureDetector(
                      onTap: () {
                        if (service.existeVenta) {
                          if (service.venta == venta) {
                            service.ventaInitState();
                          } else {
                            service.venta = venta;
                          }
                        } else {
                          service.venta = venta;
                        }
                      },
                      child: Container(
                        color: venta.anulada == 1
                            ? ligthGreyColor
                            : service.existeVenta
                                ? venta == service.venta
                                    ? Colors.blue.withOpacity(0.3)
                                    : null
                                : null,
                        child: Row(
                          children: [
                            CellItem(text: venta.id.toString().padLeft(5, '0')),
                            CellItem(text: venta.clienteNombre, width: 120),
                            CellItem(text: venta.productoNombre, width: 120),
                            CellItem(text: venta.totalAves.toString()),
                            CellItem(
                                text: venta.totalPromedio.toStringAsFixed(2)),
                            CellItem(text: venta.totalNeto.toStringAsFixed(2)),
                            CellItem(
                                text: venta.precio.toStringAsFixed(2),
                                width: 70),
                            CellItem(
                                text: venta.totalImporte.toStringAsFixed(2)),
                            CellItem(text: venta.observacion ?? '', width: 120),
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
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final ventaProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await ventaServ.getVentas(token, ini, fin).then((value) async {
      ventaProv.setVentas(value, fechaProv.anuladas);
      ventaProv.ventasResumen = value;
      ventaProv.ventaInitState();
      await ClientesService().getClientes(token).then((value) {
        clienteProv.clientes = value;
        Navigator.pop(context);
      });
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void descontar(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventasProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final avesCtrl = TextEditingController();
    final netoCtrl = TextEditingController();
    final motivoCtrl = TextEditingController();

    final venta = ventasProv.venta;
    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Descontar Venta',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              controller: avesCtrl,
              title: 'Cant Aves',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: netoCtrl,
              title: 'Peso Neto',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: motivoCtrl,
              title: 'Motivo',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            child: const Text('Descontar'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final neto = double.parse(netoCtrl.text);
                final aves = int.parse(avesCtrl.text);
                CustomDialog.loadingDialog(context);
                final pesaje = Pesaje(
                  createdAt: now,
                  nroJabas: 0,
                  pesoJaba: 0,
                  bruto: 0,
                  tara: 0,
                  neto: neto,
                  nroAves: aves,
                  promedio: 0,
                  importe: neto * venta.precio,
                  observacion: motivoCtrl.text,
                );
                final newVenta = venta.insertarPesajeDescuento(pesaje);
                await ventaServ.descontar(newVenta, token).then((value) async {
                  if (value) {
                    await ClientesService().getClientes(token).then((value) {
                      clienteProv.clientes = value;
                    });
                    await ventaServ.getVentas(token, ini, fin).then((value) {
                      ventasProv.setVentas(value, false);
                      ventasProv.ventasResumen = value;
                      ventasProv.ventaInitState();
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

  void editarPrecio(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final precioCtrl = TextEditingController();
    precioCtrl.text = ventaProv.venta.precio.toStringAsFixed(2);

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
        content: CustomTextBox(
          controller: precioCtrl,
          title: 'Precio (S/)',
          width: 400,
        ),
        actions: [
          FilledButton(
            child: const Text('Editar Precio'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final precio = double.parse(precioCtrl.text);
                CustomDialog.loadingDialog(context);
                final newVenta = ventaProv.venta.editarPrecio(precio);
                await ventaServ
                    .editarPrecio(newVenta, token)
                    .then((value) async {
                  if (value) {
                    await ClientesService().getClientes(token).then((value) {
                      clienteProv.clientes = value;
                    });
                    await ventaServ.getVentas(token, ini, fin).then((value) {
                      ventaProv.setVentas(value, false);
                      ventaProv.ventaInitState();
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

  void anular(BuildContext context) {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = fechaProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Anular Venta',
          style: TextStyle(fontSize: 16),
        ),
        content: Text('Anular la venta N° ${ventaProv.venta.id}'),
        actions: [
          FilledButton(
            child: const Text('Anular Venta'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                CustomDialog.loadingDialog(context);
                final newVenta = ventaProv.venta.copyWith(newAnulada: 1);
                await ventaServ.anular(newVenta, token).then((value) async {
                  if (value) {
                    await ClientesService().getClientes(token).then((value) {
                      clienteProv.clientes = value;
                    });
                    await ventaServ.getVentas(token, ini, fin).then((value) {
                      ventaProv.setVentas(value, false);
                      ventaProv.ventasResumen = value;
                      ventaProv.ventaInitState();
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
