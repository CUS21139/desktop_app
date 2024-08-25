import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/caja_mov.dart';
import '../../../models/compra_vivo.dart';
import '/src/models/proveedor.dart';

import '/src/services/caja_mov_service.dart';
import '../../../services/compras_vivos_service.dart';

import '/src/presentation/ui/estados_cta/detalle_caja_widget.dart';
import '/src/presentation/ui/estados_cta/detalle_compra_widget.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/table_cell.dart';
import '/src/presentation/providers/estado_proveedor_mov.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/estados_cta_service.dart';

import '/src/utils/date_formats.dart';

class EstProveedoresView extends StatefulWidget {
  const EstProveedoresView({super.key});

  @override
  State<EstProveedoresView> createState() => _EstProveedoresViewState();
}

class _EstProveedoresViewState extends State<EstProveedoresView> {
  Proveedor? proveedorSelec;
  final proveedorCtrl = TextEditingController();
  Proveedor? proveedor;

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  CompraVivo? compraSelect;
  List<CajaMov>? cajaMovSelect;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 960.0 : 980.0;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width <= 1366 ? 180 : 200,
            child: Column(
              children: [
                TextBox(
                  placeholder: 'Fecha',
                  controller: fechaCtrl,
                  readOnly: true,
                  onTap: () async {
                    fecha = await CustomDatePicker.showPicker(context);
                    if (fecha != null) fechaCtrl.text = date.format(fecha!);
                  },
                ),
                const SizedBox(height: 15),
                Consumer<ProveedoresProv>(
                  builder: (_, service, __) {
                    return AutoSuggestBox<Proveedor>(
                      controller: proveedorCtrl,
                      placeholder: 'Proveedor',
                      items: service.proveedores
                          .map((e) => AutoSuggestBoxItem<Proveedor>(
                              value: e,
                              label: e.nombre,
                              child: Text(e.nombre,
                                  overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onSelected: (item) {
                        setState(() => proveedorSelec = item.value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                FilledButton(
                  child: const Text('Buscar'),
                  onPressed: () => buscar(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: globalWidth,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Consumer<EstadoProveedorProv>(builder: (_, service, __) {
                      return Text(
                        'Proveedor: ${service.existeProveedorSelect ? service.proveedorSelect.nombre : ''}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      );
                    }),
                    const Spacer(),
                    RefreshButton(onPressed: () => refresh()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: size.height * 0.55,
                  width: globalWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: Consumer<EstadoProveedorProv>(
                        builder: (_, service, __) {
                      return HorizontalDataTable(
                        itemCount: service.movimientos.length,
                        headerWidgets: [
                          const CellTitle(text: '', width: 0),
                          const CellTitle(text: 'Fecha'),
                          const CellTitle(text: 'Banco'),
                          const CellTitle(text: 'DocID', width: 120),
                          const CellTitle(text: 'Producto'),
                          const CellTitle(text: 'Cantidad', width: 70),
                          const CellTitle(text: 'Peso'),
                          CellTitle(
                              text: 'Precio',
                              width: size.width <= 1366 ? 70 : 90),
                          const CellTitle(text: 'Importe'),
                          const CellTitle(text: 'Pago'),
                          const CellTitle(text: 'Saldo'),
                        ],
                        isFixedHeader: true,
                        leftHandSideColumnWidth: 0,
                        leftHandSideColBackgroundColor:
                            Colors.white.withOpacity(0.8),
                        leftSideItemBuilder: (c, i) => const SizedBox(),
                        rightHandSideColumnWidth: globalWidth,
                        rightHandSideColBackgroundColor:
                            Colors.white.withOpacity(0.8),
                        rightSideItemBuilder: (c, i) {
                          final mov = service.movimientos[i];
                          return GestureDetector(
                            onTap: () async {
                              final token = Provider.of<UsuariosProv>(context,
                                      listen: false)
                                  .token;
                              if (service.existeMovSelect &&
                                  service.movSelect.docId == mov.docId) {
                                service.movSelectInitState();
                              } else {
                                CustomDialog.loadingDialog(context);
                                service.movSelect = mov;
                                if (mov.movType == 'C') {
                                  await ComprasVivosService()
                                      .getCompra(token, int.parse(mov.docId))
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() => compraSelect = value);
                                  });
                                }
                                if (mov.movType == 'E') {
                                  await CajaService()
                                      .getMov(token, mov.docId)
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() => cajaMovSelect = value);
                                  });
                                }
                              }
                            },
                            child: Container(
                              color: service.existeMovSelect &&
                                      service.movSelect.docId == mov.docId
                                  ? Colors.blue.withOpacity(0.3)
                                  : null,
                              child: Row(
                                children: [
                                  CellItem(text: date.format(mov.docDate)),
                                  CellItem(text: mov.bancoNombre),
                                  CellItem(
                                      text: mov.docId.padLeft(10, '0'),
                                      width: 120),
                                  CellItem(text: mov.producto),
                                  CellItem(
                                      text: mov.cantAves.toString(), width: 70),
                                  CellItem(text: mov.peso.toStringAsFixed(2)),
                                  CellItem(
                                      text: mov.precio.toStringAsFixed(2),
                                      width: size.width <= 1366 ? 70 : 90),
                                  CellItem(
                                      text: mov.importe == 0
                                          ? '-'
                                          : 'S/ ${mov.importe.toStringAsFixed(2)}'),
                                  CellItem(
                                      text: mov.pago == 0
                                          ? '-'
                                          : 'S/ ${mov.pago.toStringAsFixed(2)}'),
                                  CellItem(
                                      text:
                                          'S/ ${mov.saldo.toStringAsFixed(2)}'),
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
              const SizedBox(height: 20),
              Consumer<EstadoProveedorProv>(builder: (_, prov, __) {
                if (prov.existeMovSelect) {
                  if (prov.movSelect.movType == 'C' && compraSelect != null) {
                    return TableDetalleEstadoCompra(compra: compraSelect!);
                  }
                  if (prov.movSelect.movType == 'E' && cajaMovSelect != null) {
                    return TableDetalleEstadoCajaMov(cajaMov: cajaMovSelect!);
                  }
                }
                return Container(
                  height: 140,
                  width: 920,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void refresh() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoProveedorProv =
        Provider.of<EstadoProveedorProv>(context, listen: false);

    DateTime date;
    final now = DateTime.now().subtract(const Duration(days: 5));
    date = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (estadoProveedorProv.existeProveedorSelect) {
      CustomDialog.loadingDialog(context);
      await EstadoCtaService()
          .getEstadoProveedor(
              token, date, estadoProveedorProv.proveedorSelect.estadoCta!)
          .then((value) {
        estadoProveedorProv.movimientos = value;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }

  void buscar() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoProveedorProv =
        Provider.of<EstadoProveedorProv>(context, listen: false);

    if (proveedorSelec == null) {
      CustomDialog.errorDialog(context, 'Seleccione un proveedor');
    } else {
      CustomDialog.loadingDialog(context);
      DateTime date;
      if (fecha != null) {
        date = fecha!;
      } else {
        final now = DateTime.now().subtract(const Duration(days: 5));
        date = DateTime(now.year, now.month, now.day, 0, 0, 0);
      }
      await EstadoCtaService()
          .getEstadoProveedor(token, date, proveedorSelec!.estadoCta!)
          .then((value) {
        estadoProveedorProv.movimientos = value;
        estadoProveedorProv.proveedorSelect = proveedorSelec!;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }
}
