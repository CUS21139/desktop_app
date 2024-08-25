import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/banco.dart';
import '/src/models/caja_mov.dart';
import '/src/models/cliente.dart';
import '/src/models/proveedor.dart';

import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/bancos_service.dart';
import '/src/services/caja_mov_service.dart';
import '/src/services/clientes_service.dart';
import '/src/services/proveedores_service.dart';
import '/src/utils/date_formats.dart';

class MovimientoWidget extends StatefulWidget {
  const MovimientoWidget({super.key});

  @override
  State<MovimientoWidget> createState() => _MovimientoWidgetState();
}

class _MovimientoWidgetState extends State<MovimientoWidget> {
  bool ingreso = true;
  bool egreso = false;
  bool gavipo = false;

  Banco? banco;
  Cliente? cliente;
  Proveedor? proveedor;

  final montoCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  clearCtrl() {
    montoCtrl.clear();
    descripcionCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                content: const Text('Ingreso'),
                checked: ingreso,
                onChanged: (v) => setState(() {
                  ingreso = v!;
                  egreso = !v;
                }),
              ),
              const SizedBox(height: 10),
              Checkbox(
                content: const Text('Egreso'),
                checked: egreso,
                onChanged: (v) => setState(() {
                  egreso = v!;
                  ingreso = !v;
                }),
              ),
              const SizedBox(height: 10),
              Checkbox(
                content: const Text('Gavipo'),
                checked: gavipo,
                onChanged: (v) => setState(() => gavipo = v!),
              ),
            ],
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Banco',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Consumer<BancosProv>(
                            builder: (_, service, __) {
                              return AutoSuggestBox<Banco>(
                                items: service.bancos
                                    .map(
                                      (e) => AutoSuggestBoxItem<Banco>(
                                        value: e,
                                        label: e.nombre,
                                        child: Text(e.nombre,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                    .toList(),
                                onSelected: (item) {
                                  setState(() => banco = item.value);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: Builder(
                        builder: (_) {
                          if (gavipo) {
                            return CustomTextBox(
                              controller: TextEditingController(text: 'Gavipo'),
                              title: 'Gavipo',
                              readOnly: true,
                            );
                          }
                          if (ingreso) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cliente',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Consumer<ClientesProv>(
                                  builder: (_, service, __) {
                                    return AutoSuggestBox<Cliente>(
                                      items: service.clientes
                                          .map((e) =>
                                              AutoSuggestBoxItem<Cliente>(
                                                value: e,
                                                label: e.nombre,
                                                child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                              ))
                                          .toList(),
                                      onSelected: (item) {
                                        setState(() => cliente = item.value);
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Proveedor',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Consumer<ProveedoresProv>(
                                builder: (_, service, __) {
                                  return AutoSuggestBox<Proveedor>(
                                    items: service.proveedores
                                        .map((e) =>
                                            AutoSuggestBoxItem<Proveedor>(
                                              value: e,
                                              label: e.nombre,
                                              child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                                            ))
                                        .toList(),
                                    onSelected: (item) {
                                      setState(() => proveedor = item.value);
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    CustomTextBox(controller: montoCtrl, title: 'Monto S/'),
                  ],
                ),
                const SizedBox(height: 5),
                CustomTextBox(
                  controller: descripcionCtrl,
                  title: 'Descripcion',
                  width: 640,
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          FilledButton(
            onPressed: agregarMovimiento,
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> agregarMovimiento() async {
    final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
    final cajaProv = Provider.of<CajaProv>(context, listen: false);
    final bancoProv = Provider.of<BancosProv>(context, listen: false);
    final clienteProv = Provider.of<ClientesProv>(context, listen: false);
    final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
    final cajaServ = CajaService();
    final bancoServ = BancosService();
    final clienteServ = ClientesService();
    final proveedorServ = ProveedoresService();
    try {
      CustomDialog.loadingDialog(context);
      final now = DateTime.now();
      final movimiento = CajaMov(
        fecha: date.format(now),
        hora: time.format(now),
        createdBy: usuarioProv.usuario.nombre,
        movType: ingreso ? 'I' : 'E',
        bancoId: banco!.id!,
        bancoNombre: banco!.nombre,
        bancoEstadoCta: banco!.estadoCta!,
        entityType: gavipo
            ? 'G'
            : ingreso
                ? 'CL'
                : 'PR',
        entityId: gavipo
            ? 1
            : ingreso
                ? cliente!.id!
                : proveedor!.id!,
        entityNombre: gavipo
            ? 'GAVIPO'
            : ingreso
                ? cliente!.nombre
                : proveedor!.nombre,
        entityEstadoCta: gavipo
            ? 'ECG0000001'
            : ingreso
                ? cliente!.estadoCta!
                : proveedor!.estadoCta!,
        descripcion: descripcionCtrl.text,
        ingreso: ingreso ? double.parse(montoCtrl.text) : 0,
        egreso: egreso ? double.parse(montoCtrl.text) : 0,
      );
      if (movimiento.movType == 'I') {
        await cajaServ
            .insertIngreso(usuarioProv.token, movimiento)
            .then((value) async {
          cajaProv.caja = value['caja'];
          cajaProv.cajaMov = value['movs'];
          await clienteServ.getClientes(usuarioProv.token).then((value) {
            clienteProv.clientes = value;
          });
        });
      } else if (movimiento.movType == 'E') {
        if (banco!.saldo! < double.parse(montoCtrl.text)) {
          throw Exception('El saldo del banco es menor al monto');
        } else {
          await cajaServ
              .insertEgreso(usuarioProv.token, movimiento)
              .then((value) async {
            cajaProv.caja = value['caja'];
            cajaProv.cajaMov = value['movs'];
            await proveedorServ.getProveedores(usuarioProv.token).then((value) {
              proveedorProv.proveedores = value;
            });
          });
        }
      }
      await bancoServ.getBancos(usuarioProv.token).then((value) {
        bancoProv.bancos = value;
        Navigator.pop(context);
      });
      clearCtrl();
    } catch (e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    }
  }
}
