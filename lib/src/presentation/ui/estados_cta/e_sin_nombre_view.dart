import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';


import '/src/models/cliente.dart';
import '/src/models/caja_mov.dart';
import '/src/models/estado_sin_nombre_mov.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/table_cell.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/estado_sin_nombre_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/ui/estados_cta/detalle_caja_widget.dart';

import '/src/services/bancos_service.dart';
import '/src/services/clientes_service.dart';
import '/src/services/caja_mov_service.dart';
import '/src/services/estados_cta_service.dart';

import '/src/utils/date_formats.dart';

class EstSinNombreView extends StatefulWidget {
  const EstSinNombreView({super.key});

  @override
  State<EstSinNombreView> createState() => _EstSinNombreViewState();
}

class _EstSinNombreViewState extends State<EstSinNombreView> {
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
                    const Text(
                      'Estado de Cta SIN NOMBRE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Spacer(),
                    Consumer<EstadoSinNombreProv>(
                      builder: (_, serv, __) {
                        return CustomButton(
                          onPressed: serv.isIngresoSelect
                              ? () => asignarCliente(serv.movSelect)
                              : null,
                          title: 'Asignar a Cliente',
                          color: Colors.orange,
                          iconData: FluentIcons.reminder_person,
                        );
                      },
                    ),
                    const SizedBox(width: 10),
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
                    child: Consumer<EstadoSinNombreProv>(
                        builder: (_, service, __) {
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
                                    .getMov(token, mov.docId!)
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
                                  : mov.asignada ? Colors.grey.withOpacity(0.1) : null,
                              child: Row(
                                children: [
                                  CellItem(text: date.format(mov.createdAt)),
                                  CellItem(
                                      text: time.format(mov.createdAt),
                                      width: 80),
                                  CellItem(
                                      text: mov.docId.toString(), width: 120),
                                  CellItem(text: mov.entityType, width: 50),
                                  CellItem(text: mov.entityNombre, width: 130),
                                  CellItem(
                                      text: mov.descripcion,
                                      width: size.width <= 1366 ? 180 : 200),
                                  CellItem(
                                      text:
                                          'S/ ${mov.ingreso.toStringAsFixed(2)}'),
                                  CellItem(
                                      text:
                                          'S/ ${mov.egreso.toStringAsFixed(2)}'),
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
              Consumer<EstadoSinNombreProv>(builder: (_, prov, __) {
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

  void buscar() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoSinNombreProv =
        Provider.of<EstadoSinNombreProv>(context, listen: false);

    CustomDialog.loadingDialog(context);
    DateTime date;
    if (fecha != null) {
      date = fecha!;
    } else {
      final now = DateTime.now().subtract(const Duration(days: 5));
      date = DateTime(now.year, now.month, now.day, 0, 0, 0);
    }
    await EstadoCtaService().getEstadoSinNombre(token, date).then((value) {
      estadoSinNombreProv.movimientos = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void refresh() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final estadoSinNombreProv =
        Provider.of<EstadoSinNombreProv>(context, listen: false);

    CustomDialog.loadingDialog(context);
    DateTime date;
    final now = DateTime.now().subtract(const Duration(days: 5));
    date = DateTime(now.year, now.month, now.day, 0, 0, 0);

    await EstadoCtaService().getEstadoSinNombre(token, date).then((value) {
      estadoSinNombreProv.movimientos = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void asignarCliente(EstadoSinNombreMov mov) async {
    final bancoServ = BancosService();
    final cajaServ = CajaService();
    final clientesServ = ClientesService();
    final estadosServ = EstadoCtaService();

    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final usuarioName =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final estadoSinNombreProv =
        Provider.of<EstadoSinNombreProv>(context, listen: false);
    final bancoProv = Provider.of<BancosProv>(context, listen: false);
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final clientesProv = Provider.of<ClientesProv>(context, listen: false);

    final bancos = Provider.of<BancosProv>(context, listen: false).bancos;
    final clientes = Provider.of<ClientesProv>(context, listen: false).clientes;
    Cliente? cliente;

    showDialog(
      context: context,
      builder: (c) => ContentDialog(
        title: const Text(
          'Asignar a CLIENTE',
          style: TextStyle(fontSize: 16),
        ),
        content: StatefulBuilder(builder: (_, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cliente'),
              SizedBox(
                width: 400,
                child: AutoSuggestBox(
                  items: clientes
                      .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                      .toList(),
                  onSelected: (v) => cliente = v.value,
                ),
              ),
            ],
          );
        }),
        actions: [
          FilledButton(
            child: const Text('Aceptar'),
            onPressed: () async {
              Navigator.pop(c);
              if (cliente == null) {
                CustomDialog.errorDialog(
                    context, 'No se seleccionó un cliente');
                return;
              }

              CustomDialog.loadingDialog(context);
              try {
                final banco = bancos.singleWhere((e) => e.id == mov.bancoId);

                // Insertar egreso SIN NOMBRE
                final movEgreso = CajaMov(
                  fecha: date.format(mov.createdAt),
                  hora: time.format(mov.createdAt),
                  createdBy: usuarioName,
                  movType: 'I',
                  bancoId: mov.bancoId,
                  bancoNombre: mov.bancoNombre,
                  bancoEstadoCta: banco.estadoCta!,
                  entityType: 'SN',
                  entityId: 1,
                  entityNombre: 'SIN NOMBRE',
                  entityEstadoCta: 'ECSN000001',
                  descripcion: 'Enaviado a ${cliente!.nombre}',
                  ingreso: 0,
                  egreso: mov.ingreso,
                );
                await cajaServ.insertEgreso(token, movEgreso);
                await estadosServ.asignarEstadoSinNombre(token, mov.docId!);

                // Insertar ingreso a cliente
                final movIngreso = CajaMov(
                  fecha: date.format(mov.createdAt),
                  hora: time.format(mov.createdAt),
                  createdBy: usuarioName,
                  movType: 'I',
                  bancoId: mov.bancoId,
                  bancoNombre: mov.bancoNombre,
                  bancoEstadoCta: banco.estadoCta!,
                  entityType: cliente!.entityType,
                  entityId: cliente!.id!,
                  entityNombre: cliente!.nombre,
                  entityEstadoCta: cliente!.estadoCta!,
                  descripcion: mov.descripcion,
                  ingreso: mov.ingreso,
                  egreso: 0,
                );
                await cajaServ.insertIngreso(token, movIngreso);

                // Obtener listas actualizadas
                DateTime dateTime;
                final now = DateTime.now();
                final searchDate = now.subtract(const Duration(days: 5));
                dateTime = DateTime(searchDate.year, searchDate.month, searchDate.day, 0, 0, 0);
                await estadosServ.getEstadoSinNombre(token, dateTime).then((value){
                  estadoSinNombreProv.movimientos = value;
                });

                await cajaServ.getCaja(token, now).then((value){
                  cajaProv.caja = value['caja'];
                  cajaProv.cajaMov = value['movs'];
                });

                await clientesServ.getClientes(token).then((value){
                  clientesProv.clientes = value;
                });

                await bancoServ.getBancos(token).then((value) {
                  bancoProv.bancos = value;
                });
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              }
            },
          ),
          Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(c),
          ),
        ],
      ),
    );
  }
}
