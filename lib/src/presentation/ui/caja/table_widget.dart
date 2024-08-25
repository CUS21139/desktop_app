import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/caja_mov.dart';

import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/utils/colors.dart';
import '/src/presentation/utils/text_style.dart';

import '/src/services/bancos_service.dart';
import '/src/services/caja_mov_service.dart';
import '/src/services/clientes_service.dart';
import '/src/services/proveedores_service.dart';

class TableCaja extends StatefulWidget {
  const TableCaja({super.key});

  @override
  State<TableCaja> createState() => _TableCajaState();
}

class _TableCajaState extends State<TableCaja> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 890.0 : 920.0;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: globalWidth,
        child: Column(
          children: [
            Consumer<CajaProv>(builder: (_, service, __) {
              return Flex(
                direction: Axis.horizontal,
                children: [
                  RefreshButton(onPressed: () => refresh()),
                  const SizedBox(width: 20),
                  Text(
                    'Caja del Dia : ${service.existeCaja ? service.caja.fecha : '00-00-0000'}',
                    style: subtitleDataDBStyle,
                  ),
                  const Spacer(),
                  TotalSaldoWidget(
                    label: 'Saldo Inicial',
                    monto: service.caja.saldoInicial,
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height:
                    size.width <= 1366 ? size.height * 0.6 : size.height * 0.65,
                width: globalWidth,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: Consumer<CajaProv>(builder: (_, service, __) {
                    return HorizontalDataTable(
                      isFixedHeader: true,
                      rightHandSideColBackgroundColor:
                          Colors.white.withOpacity(0.8),
                      leftHandSideColBackgroundColor:
                          Colors.white.withOpacity(0.8),
                      headerWidgets: [
                        const CellTitle(text: '', width: 0),
                        const CellTitle(text: '', width: 60),
                        const CellTitle(text: 'Hora'),
                        const CellTitle(text: 'Doc ID', width: 120),
                        const CellTitle(text: 'Banco', width: 120),
                        const CellTitle(text: 'Entidad', width: 120),
                        CellTitle(
                          text: 'Descripcion',
                          width: size.width <= 1366 ? 170 : 200,
                        ),
                        const CellTitle(text: 'Ingreso S/'),
                        const CellTitle(text: 'Egreso S/'),
                      ],
                      isFixedFooter: true,
                      footerWidgets: [
                        const CellTitle(text: '', width: 0),
                        const CellTitle(text: '', width: 60),
                        const CellTitle(text: ''),
                        const CellTitle(text: '', width: 120),
                        const CellTitle(text: '', width: 120),
                        const CellTitle(text: '', width: 120),
                        CellTitle(
                          text: '',
                          width: size.width <= 1366 ? 170 : 200,
                        ),
                        CellTitle(
                            text:
                                'S/ ${service.caja.totalIngresos.toStringAsFixed(2)}'),
                        CellTitle(
                            text:
                                'S/ ${service.caja.totalEgresos.toStringAsFixed(2)}'),
                      ],
                      itemCount: service.cajaMov.length,
                      leftHandSideColumnWidth: 0,
                      leftSideItemBuilder: (c, i) => const SizedBox(),
                      rightHandSideColumnWidth: globalWidth,
                      rightSideItemBuilder: (c, i) {
                        final movimiento = service.cajaMov[i];
                        return Row(
                          children: [
                            CellDeleteButton(
                                colorIcon: service.caja.closed != 1
                                    ? Colors.red
                                    : greyColor,
                                onPressed: service.caja.closed != 1
                                    ? () async => deleteMov(movimiento)
                                    : null),
                            CellItem(text: movimiento.hora),
                            CellItem(text: movimiento.docId!, width: 120),
                            CellItem(text: movimiento.bancoNombre, width: 120),
                            CellItem(text: movimiento.entityNombre, width: 120),
                            CellItem(
                              text: movimiento.descripcion,
                              width: size.width <= 1366 ? 170 : 200,
                            ),
                            CellItem(
                                text: movimiento.ingreso == 0
                                    ? '-'
                                    : 'S/ ${movimiento.ingreso.toStringAsFixed(2)}'),
                            CellItem(
                                text: movimiento.egreso == 0
                                    ? '-'
                                    : 'S/ ${movimiento.egreso.toStringAsFixed(2)}'),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<CajaProv>(builder: (_, service, __) {
                  return TotalSaldoWidget(
                    label: 'Saldo Final',
                    monto: service.caja.saldoFinal,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteMov(CajaMov movimiento) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final cajaServ = CajaService();
    final bancoServ = BancosService();
    final bancoProv = Provider.of<BancosProv>(context, listen: false);
    final clienteServ = ClientesService();
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final proveedorServ = ProveedoresService();
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);

    try {
      CustomDialog.loadingDialog(context);
      if (movimiento.movType == 'I') {
        await cajaServ.deleteIngreso(token, movimiento).then((value) {
          cajaProv.caja = value['caja'];
          cajaProv.cajaMov = value['movs'];
        });
        await clienteServ.getClientes(token).then((value) {
          clienteProv.clientes = value;
        });
      } else if (movimiento.movType == 'E') {
        await cajaServ.deleteEgreso(token, movimiento).then((value) {
          cajaProv.caja = value['caja'];
          cajaProv.cajaMov = value['movs'];
        });
        await proveedorServ.getProveedores(token).then((value) {
          proveedorProv.proveedores = value;
        });
      } else if (movimiento.movType == 'TR') {
        await cajaServ.deleteTransferencia(token, movimiento).then((value) {
          cajaProv.caja = value['caja'];
          cajaProv.cajaMov = value['movs'];
        });
      }
      await bancoServ.getBancos(token).then((value) {
        bancoProv.bancos = value;
        Navigator.pop(context);
      });
    } catch (e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    }
  }

  void refresh() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final cajaServ = CajaService();
    try {
      CustomDialog.loadingDialog(context);
      await cajaServ.getCaja(token, DateTime.now()).then((value) {
        cajaProv.caja = value['caja'];
        cajaProv.cajaMov = value['movs'];
        Navigator.pop(context);
      });
    } catch (e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    }
  }
}

class TotalSaldoWidget extends StatelessWidget {
  const TotalSaldoWidget({Key? key, required this.label, required this.monto})
      : super(key: key);
  final String label;
  final double monto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10),
            ),
            color: blueColor,
          ),
          child: Text(label, style: titleTableStyle),
        ),
        Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Text(
            'S/ ${monto.toStringAsFixed(2)}',
            style: subtitleDataDBStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
