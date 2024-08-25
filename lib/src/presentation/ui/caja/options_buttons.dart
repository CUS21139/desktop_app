// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/banco.dart';
import '/src/models/caja_mov.dart';
import '/src/models/cliente.dart';
import '/src/models/proveedor.dart';
// import '/src/models/trabajador.dart';

import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
// import '/src/presentation/providers/trabajadores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/bancos_service.dart';
import '/src/services/caja_mov_service.dart';
import '/src/services/clientes_service.dart';
import '/src/services/proveedores_service.dart';
// import '/src/services/trabajadores_service.dart';

import '/src/utils/date_formats.dart';

class OptionButtonsWidget extends StatelessWidget {
  const OptionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalWidth = size.width <= 1366 ? 890.0 : 920.0;
    return SizedBox(
      width: globalWidth,
      child: Row(
        children: [
          CustomFilledButton(
            onPressed: () => _ingreso(context),
            title: 'Ingreso',
            color: Colors.green,
            iconData: FluentIcons.arrow_tall_up_right,
          ),
          const SizedBox(width: 25),
          CustomFilledButton(
            onPressed: () => _egreso(context),
            title: 'Egreso',
            color: Colors.red,
            iconData: FluentIcons.arrow_tall_up_right,
          ),
          const SizedBox(width: 25),
          CustomFilledButton(
            onPressed: () => _transferir(context),
            title: 'Transferencia',
            color: Colors.blue,
            iconData: FluentIcons.share,
          ),
          // const Spacer(),
          // CustomFilledButton(
          //   onPressed: () => _ingresoSinNombre(context),
          //   title: 'Ingreso Sin Nombre',
          //   color: Colors.orange,
          //   iconData: FluentIcons.user_warning,
          // ),
        ],
      ),
    );
  }
}

void _transferir(BuildContext context) async {
  final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
  final cajaProv = Provider.of<CajaProv>(context, listen: false);
  final cajaServ = CajaService();
  final bancoProv = Provider.of<BancosProv>(context, listen: false);
  final bancoServ = BancosService();

  final bancos = Provider.of<BancosProv>(context, listen: false).bancos;
  Banco? bancoDesde;
  final bancoDesdeCtrl = TextEditingController();
  Banco? bancoHacia;
  final bancoHaciaCtrl = TextEditingController();

  final montoCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (c) => ContentDialog(
      title: const Text(
        'Realizar Transferencia',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Desde:'),
          SizedBox(
            width: 400,
            child: AutoSuggestBox(
              controller: bancoDesdeCtrl,
              items: bancos
                  .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                  .toList(),
              onSelected: (v) {
                bancoDesde = v.value;
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text('Hacia:'),
          SizedBox(
            width: 400,
            child: AutoSuggestBox(
              controller: bancoHaciaCtrl,
              items: bancos
                  .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                  .toList(),
              onSelected: (v) => bancoHacia = v.value,
            ),
          ),
          const SizedBox(height: 10),
          CustomTextBox(
            width: 400,
            controller: montoCtrl,
            title: 'Monto S/',
          ),
        ],
      ),
      actions: [
        FilledButton(
          child: const Text('Tranferir'),
          onPressed: () async {
            Navigator.pop(c);
            CustomDialog.loadingDialog(context);
            try {
              if (bancoDesde!.saldo! < double.parse(montoCtrl.text)) {
                CustomDialog.errorDialog(
                    context, 'El saldo del banco es menor al monto');
              } else {
                final now = DateTime.now();
                final mov = CajaMov(
                  fecha: date.format(now),
                  hora: time.format(now),
                  createdBy: usuarioProv.usuario.nombre,
                  movType: 'TR',
                  bancoId: bancoDesde!.id!,
                  bancoNombre: bancoDesde!.nombre,
                  bancoEstadoCta: bancoDesde!.estadoCta!,
                  entityType: 'BN',
                  entityId: bancoHacia!.id!,
                  entityNombre: bancoHacia!.nombre,
                  entityEstadoCta: bancoHacia!.estadoCta!,
                  descripcion: 'Transferencia',
                  ingreso: 0,
                  egreso: double.parse(montoCtrl.text),
                );
                await cajaServ
                    .insertTransferencia(usuarioProv.token, mov)
                    .then((value) {
                  cajaProv.caja = value['caja'];
                  cajaProv.cajaMov = value['movs'];
                });
                await bancoServ.getBancos(usuarioProv.token).then((value) {
                  bancoProv.bancos = value;
                  Navigator.pop(context);
                });
              }
            } catch (e) {
              Navigator.pop(context);
              CustomDialog.errorDialog(context, e.toString());
            }
          },
        ),
        Button(
          child: const Text('Cerrar'),
          onPressed: () => Navigator.pop(c),
        ),
      ],
    ),
  );
}

void _ingreso(BuildContext context) async {
  final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
  final bancoProv = Provider.of<BancosProv>(context, listen: false);
  final cajaProv = Provider.of<CajaProv>(context, listen: false);
  final clienteProv = Provider.of<ClientesProv>(context, listen: false);

  final bancoServ = BancosService();
  final cajaServ = CajaService();
  final clienteServ = ClientesService();

  final bancos = Provider.of<BancosProv>(context, listen: false).bancos;
  final clientes = Provider.of<ClientesProv>(context, listen: false).clientes;

  Banco? banco;
  final bancoCtrl = TextEditingController();
  Cliente? cliente;
  final clienteCtrl = TextEditingController();

  final montoCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  bool clienteCheck = true;
  bool gavipoCheck = false;

  showDialog(
    context: context,
    builder: (c) => ContentDialog(
      title: const Text(
        'Agregar Ingreso',
        style: TextStyle(fontSize: 16),
      ),
      content: StatefulBuilder(builder: (_, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160,
                    child: Checkbox(
                      checked: clienteCheck,
                      onChanged: (v) {
                        setState(() {
                          clienteCheck = v!;
                          if (clienteCheck) {
                            gavipoCheck = false;
                            clienteCtrl.clear();
                          }
                        });
                      },
                      content: const Text('Cliente'),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: Checkbox(
                      checked: gavipoCheck,
                      onChanged: (v) {
                        setState(() {
                          gavipoCheck = v!;
                          if (gavipoCheck) {
                            clienteCheck = false;
                            clienteCtrl.text = 'MABEL';
                          }
                        });
                      },
                      content: const Text('MABEL'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Banco'),
            SizedBox(
              width: 400,
              child: AutoSuggestBox(
                controller: bancoCtrl,
                items: bancos
                    .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                    .toList(),
                onSelected: (v) => banco = v.value,
              ),
            ),
            const SizedBox(height: 10),
            Text(gavipoCheck ? 'MABEL' : 'Cliente'),
            SizedBox(
              width: 400,
              child: AutoSuggestBox(
                controller: clienteCtrl,
                enabled: clienteCheck,
                items: clientes
                    .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                    .toList(),
                onSelected: (v) => cliente = v.value,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: montoCtrl,
              title: 'Monto',
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: descripcionCtrl,
              title: 'Descripción',
            ),
          ],
        );
      }),
      actions: [
        FilledButton(
          child: const Text('Agregar'),
          onPressed: () async {
            Navigator.pop(c);
            CustomDialog.loadingDialog(context);
            try {
              final now = DateTime.now();
              final movimiento = CajaMov(
                fecha: date.format(now),
                hora: time.format(now),
                createdBy: usuarioProv.usuario.nombre,
                movType: 'I',
                bancoId: banco!.id!,
                bancoNombre: banco!.nombre,
                bancoEstadoCta: banco!.estadoCta!,
                entityType: gavipoCheck ? 'G' : 'CL',
                entityId: gavipoCheck ? 1 : cliente!.id!,
                entityNombre: gavipoCheck ? 'MABEL' : cliente!.nombre,
                entityEstadoCta:
                    gavipoCheck ? 'ECG0000001' : cliente!.estadoCta!,
                descripcion: descripcionCtrl.text,
                ingreso: double.parse(montoCtrl.text),
                egreso: 0,
              );
              await cajaServ
                  .insertIngreso(usuarioProv.token, movimiento)
                  .then((value) async {
                cajaProv.caja = value['caja'];
                cajaProv.cajaMov = value['movs'];
                await clienteServ.getClientes(usuarioProv.token).then((value) {
                  clienteProv.clientes = value;
                });
              });
              await bancoServ.getBancos(usuarioProv.token).then((value) {
                bancoProv.bancos = value;
                Navigator.pop(context);
              });
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

void _egreso(BuildContext context) async {
  final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
  final bancoProv = Provider.of<BancosProv>(context, listen: false);
  final cajaProv = Provider.of<CajaProv>(context, listen: false);
  final proveedorProv = Provider.of<ProveedoresProv>(context, listen: false);
  // final trabajadorProv = Provider.of<TrabajadoresProv>(context, listen: false);

  final bancoServ = BancosService();
  final cajaServ = CajaService();
  final proveedorServ = ProveedoresService();
  // final trabajadorServ = TrabajadoresService();

  final bancos = Provider.of<BancosProv>(context, listen: false).bancos;
  final proveedores =
      Provider.of<ProveedoresProv>(context, listen: false).proveedores;
  // final trabajadores =
  //     Provider.of<TrabajadoresProv>(context, listen: false).trabajadores;

  Banco? banco;
  final bancoCtrl = TextEditingController();
  Proveedor? proveedor;
  // Trabajador? trabajador;
  final entityCtrl = TextEditingController();

  final montoCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  bool proveedorCheck = true;
  // bool trabajadorCheck = false;
  bool gavipoCheck = false;

  showDialog(
    context: context,
    builder: (c) => ContentDialog(
      title: const Text(
        'Agregar Egreso',
        style: TextStyle(fontSize: 16),
      ),
      content: StatefulBuilder(builder: (_, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    content: const Text('Proveedor'),
                    checked: proveedorCheck,
                    onChanged: (v) {
                      setState(() {
                        proveedorCheck = v!;
                        if (proveedorCheck) {
                          // trabajadorCheck = false;
                          gavipoCheck = false;
                          entityCtrl.clear();
                        }
                      });
                    },
                  ),
                  // Checkbox(
                  //   content: const Text('Trabajador'),
                  //   checked: trabajadorCheck,
                  //   onChanged: (v) {
                  //     setState(() {
                  //       trabajadorCheck = v!;
                  //       if (trabajadorCheck) {
                  //         proveedorCheck = false;
                  //         gavipoCheck = false;
                  //         entityCtrl.clear();
                  //       }
                  //     });
                  //   },
                  // ),
                  Checkbox(
                    content: const Text('MABEL'),
                    checked: gavipoCheck,
                    onChanged: (v) {
                      setState(() {
                        gavipoCheck = v!;
                        if (gavipoCheck) {
                          entityCtrl.text = 'MABEL';
                          // trabajadorCheck = false;
                          proveedorCheck = false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Banco'),
            SizedBox(
              width: 400,
              child: AutoSuggestBox(
                controller: bancoCtrl,
                items: bancos
                    .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
                    .toList(),
                onSelected: (v) => banco = v.value,
              ),
            ),
            const SizedBox(height: 10),
            Text(gavipoCheck
                ? 'MABEL'
                // : trabajadorCheck
                //     ? 'Trabajador'
                : 'Proveedor'),
            SizedBox(
              width: 400,
              child: 
              // proveedorCheck
              //     ? 
                  AutoSuggestBox(
                      enabled: !gavipoCheck,
                      controller: entityCtrl,
                      items: proveedores
                          .map((e) =>
                              AutoSuggestBoxItem(value: e, label: e.nombre))
                          .toList(),
                      onSelected: (v) {
                        proveedor = v.value;
                      },
                    )
                  // : AutoSuggestBox(
                  //     enabled: !gavipoCheck,
                  //     controller: entityCtrl,
                  //     items: trabajadores
                  //         .map((e) =>
                  //             AutoSuggestBoxItem(value: e, label: e.nombre))
                  //         .toList(),
                  //     onSelected: (v) {
                  //       trabajador = v.value;
                  //     },
                  //   ),
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: montoCtrl,
              title: 'Monto',
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              width: 400,
              controller: descripcionCtrl,
              title: 'Descripción',
            ),
          ],
        );
      }),
      actions: [
        FilledButton(
          child: const Text('Agregar'),
          onPressed: () async {
            Navigator.pop(c);
            CustomDialog.loadingDialog(context);
            try {
              final now = DateTime.now();
              final movimiento = CajaMov(
                fecha: date.format(now),
                hora: time.format(now),
                createdBy: usuarioProv.usuario.nombre,
                movType: 'E',
                bancoId: banco!.id!,
                bancoNombre: banco!.nombre,
                bancoEstadoCta: banco!.estadoCta!,
                entityType: gavipoCheck
                    ? 'G'
                    // : trabajadorCheck
                    //     ? 'TR'
                    : 'PR',
                entityId: gavipoCheck
                    ? 1
                    // : trabajadorCheck
                    //     ? trabajador!.id!
                    : proveedor!.id!,
                entityNombre: gavipoCheck
                    ? 'MABEL'
                    // : trabajadorCheck
                    //     ? trabajador!.nombre
                    : proveedor!.nombre,
                entityEstadoCta: gavipoCheck
                    ? 'ECG0000001'
                    // : trabajadorCheck
                    //     ? trabajador!.estadoCta!
                        : proveedor!.estadoCta!,
                descripcion: descripcionCtrl.text,
                ingreso: 0,
                egreso: double.parse(montoCtrl.text),
              );

              if (banco!.saldo! < double.parse(montoCtrl.text)) {
                throw Exception('El saldo del banco es menor al monto');
              } else {
                await cajaServ
                    .insertEgreso(usuarioProv.token, movimiento)
                    .then((value) async {
                  cajaProv.caja = value['caja'];
                  cajaProv.cajaMov = value['movs'];
                  // if (trabajadorCheck) {
                  //   await trabajadorServ
                  //       .getTrabajadores(usuarioProv.token)
                  //       .then((value) => trabajadorProv.trabajadores = value);
                  // }
                  if (proveedorCheck) {
                    await proveedorServ
                        .getProveedores(usuarioProv.token)
                        .then((value) => proveedorProv.proveedores = value);
                  }
                });
              }
              await bancoServ.getBancos(usuarioProv.token).then((value) {
                bancoProv.bancos = value;
                Navigator.pop(context);
              });
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

// void _ingresoSinNombre(BuildContext context) async {
//   final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
//   final bancoProv = Provider.of<BancosProv>(context, listen: false);
//   final cajaProv = Provider.of<CajaProv>(context, listen: false);

//   final bancoServ = BancosService();
//   final cajaServ = CajaService();

//   final bancos = Provider.of<BancosProv>(context, listen: false).bancos;

//   Banco? banco;
//   final bancoCtrl = TextEditingController();

//   final montoCtrl = TextEditingController();
//   final descripcionCtrl = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (c) => ContentDialog(
//       title: const Text(
//         'Agregar Ingreso SIN NOMBRE',
//         style: TextStyle(fontSize: 16),
//       ),
//       content: StatefulBuilder(builder: (_, setState) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Banco',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//             SizedBox(
//               width: 400,
//               child: AutoSuggestBox(
//                 controller: bancoCtrl,
//                 items: bancos
//                     .map((e) => AutoSuggestBoxItem(value: e, label: e.nombre))
//                     .toList(),
//                 onSelected: (v) => banco = v.value,
//               ),
//             ),
//             const SizedBox(height: 10),
//             CustomTextBox(
//               width: 400,
//               controller: montoCtrl,
//               title: 'Monto',
//             ),
//             const SizedBox(height: 10),
//             CustomTextBox(
//               width: 400,
//               controller: descripcionCtrl,
//               title: 'Descripción',
//             ),
//           ],
//         );
//       }),
//       actions: [
//         FilledButton(
//           child: const Text('Agregar'),
//           onPressed: () async {
//             Navigator.pop(c);
//             CustomDialog.loadingDialog(context);
//             try {
//               final now = DateTime.now();
//               final movimiento = CajaMov(
//                 fecha: date.format(now),
//                 hora: time.format(now),
//                 createdBy: usuarioProv.usuario.nombre,
//                 movType: 'I',
//                 bancoId: banco!.id!,
//                 bancoNombre: banco!.nombre,
//                 bancoEstadoCta: banco!.estadoCta!,
//                 entityType: 'SN',
//                 entityId: 1,
//                 entityNombre: 'SIN NOMBRE',
//                 entityEstadoCta: 'ECSN000001',
//                 descripcion: descripcionCtrl.text,
//                 ingreso: double.parse(montoCtrl.text),
//                 egreso: 0,
//               );
//               await cajaServ
//                   .insertIngreso(usuarioProv.token, movimiento)
//                   .then((value) async {
//                 cajaProv.caja = value['caja'];
//                 cajaProv.cajaMov = value['movs'];
//               });
//               await bancoServ.getBancos(usuarioProv.token).then((value) {
//                 bancoProv.bancos = value;
//                 Navigator.pop(context);
//               });
//             } catch (e) {
//               Navigator.pop(context);
//               CustomDialog.errorDialog(context, e.toString());
//             }
//           },
//         ),
//         Button(
//           child: const Text('Cancelar'),
//           onPressed: () => Navigator.pop(c),
//         ),
//       ],
//     ),
//   );
// }
