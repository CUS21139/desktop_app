import '/src/services/caja_mov_service.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '/src/models/banco.dart';
import '/src/models/caja_mov.dart';

import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/estado_banco_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/ui/estados_cta/detalle_caja_widget.dart';

import '/src/services/estados_cta_service.dart';

import '/src/utils/date_formats.dart';

class EstBancosView extends StatefulWidget {
  const EstBancosView({super.key});

  @override
  State<EstBancosView> createState() => _EstBancosViewState();
}

class _EstBancosViewState extends State<EstBancosView> {
  final bancoCtrl = TextEditingController();
  Banco? banco;

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

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
                Consumer<BancosProv>(
                  builder: (_, service, __) {
                    return AutoSuggestBox<Banco>(
                      controller: bancoCtrl,
                      placeholder: 'Banco',
                      items: service.bancos
                          .map((e) => AutoSuggestBoxItem<Banco>(
                              value: e,
                              label: e.nombre,
                              child: Text(e.nombre,
                                  overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onSelected: (item) {
                        setState(() => banco = item.value);
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
                    Consumer<EstadoBancoProv>(builder: (_, service, __) {
                      return Text(
                        'Banco: ${service.existeBancoSelect ? service.bancoSelect.nombre : ''}',
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
                    child: Consumer<EstadoBancoProv>(builder: (_, service, __) {
                      return HorizontalDataTable(
                        itemCount: service.movimientos.length,
                        headerWidgets: [
                          const CellTitle(text: '', width: 0),
                          const CellTitle(text: 'Fecha'),
                          const CellTitle(text: 'Hora', width: 80),
                          const CellTitle(text: 'DocID', width: 120),
                          const CellTitle(text: 'Tipo', width: 50),
                          const CellTitle(text: 'Entidad', width: 130),
                          CellTitle(
                              text: 'Descripción',
                              width: size.width <= 1366 ? 180 : 200),
                          const CellTitle(text: 'Ingreso'),
                          const CellTitle(text: 'Egreso'),
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
                                await CajaService()
                                    .getMov(token, mov.docId)
                                    .then((value) {
                                  Navigator.pop(context);
                                  setState(() => cajaMovSelect = value);
                                });
                              }
                            },
                            child: Container(
                              color: service.existeMovSelect &&
                                      service.movSelect.docId == mov.docId
                                  ? Colors.blue.withOpacity(0.3)
                                  : null,
                              child: Row(
                                children: [
                                  CellItem(text: date.format(mov.createdAt)),
                                  CellItem(
                                      text: time.format(mov.createdAt),
                                      width: 80),
                                  CellItem(text: mov.docId, width: 120),
                                  CellItem(text: mov.entityType, width: 50),
                                  CellItem(text: mov.entityNombre, width: 130),
                                  CellItem(
                                      text: mov.descripcion,
                                      width: size.width <= 1366 ? 180 : 200),
                                  CellItem(
                                      text: mov.ingreso == 0
                                          ? '-'
                                          : 'S/ ${mov.ingreso.toStringAsFixed(2)}'),
                                  CellItem(
                                      text: mov.egreso == 0
                                          ? '-'
                                          : 'S/ ${mov.egreso.toStringAsFixed(2)}'),
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
              Consumer<EstadoBancoProv>(builder: (_, prov, __) {
                if (prov.existeMovSelect && cajaMovSelect != null) {
                  return TableDetalleEstadoCajaMov(cajaMov: cajaMovSelect!);
                }
                return Container(
                  height: 140,
                  width: 860,
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
    final estadoBancoProv =
        Provider.of<EstadoBancoProv>(context, listen: false);

    DateTime date;
    final now = DateTime.now().subtract(const Duration(days: 5));
    date = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (estadoBancoProv.existeBancoSelect) {
      CustomDialog.loadingDialog(context);
      await EstadoCtaService()
          .getEstadoBanco(token, date, estadoBancoProv.bancoSelect.estadoCta!)
          .then((value) {
        estadoBancoProv.movimientos = value;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }

  void buscar() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoBancoProv =
        Provider.of<EstadoBancoProv>(context, listen: false);

    if (banco == null) {
      CustomDialog.errorDialog(context, 'Seleccione un banco');
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
          .getEstadoBanco(token, date, banco!.estadoCta!)
          .then((value) {
        estadoBancoProv.movimientos = value;
        estadoBancoProv.bancoSelect = banco!;
        Navigator.pop(context);
      }).catchError((e) {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, e.toString());
      });
    }
  }
}
