import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/caja_mov.dart';
import '../../../models/venta_vivo.dart';
import '/src/models/cliente.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/table_cell.dart';
import '/src/presentation/components/button_excel.dart';
import '/src/presentation/components/button_refresh.dart';

import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/estado_cliente_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/ui/estados_cta/detalle_caja_widget.dart';
import '/src/presentation/ui/estados_cta/detalle_venta_widget.dart';

import '/src/services/caja_mov_service.dart';
import '/src/services/estados_cta_service.dart';
import '../../../services/ventas_vivo_service.dart';
import '/src/services/excel_service.dart';
import '/src/utils/date_formats.dart';

class EstClientesView extends StatefulWidget {
  const EstClientesView({super.key});

  @override
  State<EstClientesView> createState() => _EstClientesViewState();
}

class _EstClientesViewState extends State<EstClientesView> {
  Cliente? clienteSelec;
  final clienteCtrl = TextEditingController();

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  VentaVivo? ventaSelect;
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
                Consumer<ClientesProv>(
                  builder: (_, service, __) {
                    return AutoSuggestBox<Cliente>(
                      controller: clienteCtrl,
                      placeholder: 'Cliente',
                      items: service.clientes
                          .map((e) => AutoSuggestBoxItem<Cliente>(
                              value: e,
                              label: e.nombre,
                              child: Text(e.nombre,
                                  overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onSelected: (item) {
                        setState(() => clienteSelec = item.value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                FilledButton(
                  child: const Text('Buscar'),
                  onPressed: () => buscar(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 100,
                  child: ExcelButton(onPressed: () async {
                    final clienteProv =
                        Provider.of<EstadoClienteProv>(context, listen: false);
                    if (clienteProv.existeClienteSelect) {
                      await ExcelService().exportarEstadoCuenta(
                        cliente: clienteProv.clienteSelect,
                        lista: clienteProv.movimientos,
                      );
                    } else {
                      CustomDialog.errorDialog(
                          context, 'Seleccione un estado de cuenta');
                    }
                  }),
                )
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
                    Consumer<EstadoClienteProv>(builder: (_, service, __) {
                      return Text(
                        'Cliente: ${service.existeClienteSelect ? service.clienteSelect.nombre : ''}',
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
                  height: size.height * 0.4,
                  width: globalWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child:
                        Consumer<EstadoClienteProv>(builder: (_, service, __) {
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
                                if (mov.movType == 'V') {
                                  await VentasVivoService()
                                      .getVenta(int.parse(mov.docId), token)
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() => ventaSelect = value[0]);
                                  });
                                }
                                if (mov.movType == 'I') {
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
                                  : mov.movType == 'V'
                                      ? Colors.green.withOpacity(0.4)
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
              Consumer<EstadoClienteProv>(builder: (_, prov, __) {
                if (prov.existeMovSelect) {
                  if (prov.movSelect.movType == 'V' && ventaSelect != null) {
                    return TableDetalleEstadoVenta(venta: ventaSelect!);
                  }
                  if (prov.movSelect.movType == 'I' && cajaMovSelect != null) {
                    return TableDetalleEstadoCajaMov(cajaMov: cajaMovSelect!);
                  }
                }
                return Container(
                  height: 280,
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
    final estadoClienteProv =
        Provider.of<EstadoClienteProv>(context, listen: false);

    DateTime date;
    final now = DateTime.now().subtract(const Duration(days: 5));
    date = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (estadoClienteProv.existeClienteSelect) {
      CustomDialog.loadingDialog(context);
      await EstadoCtaService()
          .getEstadoCliente(
              token, date, estadoClienteProv.clienteSelect.estadoCta!)
          .then((value) {
        estadoClienteProv.movimientos = value;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }

  void buscar() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoClienteProv =
        Provider.of<EstadoClienteProv>(context, listen: false);

    if (clienteSelec == null) {
      CustomDialog.errorDialog(context, 'Seleccione un cliente');
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
          .getEstadoCliente(token, date, clienteSelec!.estadoCta!)
          .then((value) {
        estadoClienteProv.movimientos = value;
        estadoClienteProv.clienteSelect = clienteSelec!;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }
}
