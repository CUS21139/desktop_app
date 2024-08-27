import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/cliente.dart';
import '../../../services/clientes_service.dart';

import '../../providers/usuarios_provider.dart';
import '../../providers/zonas_provider.dart';
import '../../providers/clientes_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../components/custom_textfield.dart';
import '../../utils/colors.dart';

class ClientesView extends StatefulWidget {
  const ClientesView({super.key});

  @override
  State<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends State<ClientesView> {
  final clienteCtrl = TextEditingController();

  List<Cliente> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<ClientesProv>(context, listen: false);
    isSearching = clienteCtrl.text.isNotEmpty;
    List<Cliente> clientes = [];
    clientes.addAll(service.clientes);
    if (isSearching) {
      clientes.retainWhere((value) {
        String searchLetter = clienteCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = clientes;
    });
  }

  @override
  void initState() {
    clienteCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    clienteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextBox(
            controller: clienteCtrl,
            placeholder: 'Buscar Cliente',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 100,
                child: Text('ZONA COD',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 200,
                child: Text('ESTADO CUENTA',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 120,
                child: Text('CELULAR',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 230,
                child: Text('NOMBRE',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 150,
                child: Text('SALDO MAX',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 150,
                child: Text('SALDO MIN',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              RefreshButton(onPressed: () => refresh()),
              const SizedBox(width: 30),
              Container(
                alignment: Alignment.topRight,
                child: CreateButton(onPressed: () => create(context)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ClientesProv>(builder: (_, service, __) {
            final list = service.clientes;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final cliente = isSearching ? filtro[i] : list[i];
                return Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(width: 100, child: Text(cliente.zonaCode)),
                        SizedBox(
                            width: 200, child: Text(cliente.estadoCta ?? 'NA')),
                        SizedBox(width: 120, child: Text('${cliente.celular}')),
                        SizedBox(width: 230, child: Text(cliente.nombre)),
                        SizedBox(
                            width: 150,
                            child: Text(
                                'S/ ${cliente.saldoMaximo!.toStringAsFixed(2)}')),
                        SizedBox(
                            width: 150,
                            child: Text(
                                'S/ ${cliente.saldoMinimo!.toStringAsFixed(2)}')),
                        const Spacer(),
                        CustomButton(
                          title: 'Editar',
                          color: greenColor,
                          iconData: FluentIcons.edit,
                          onPressed: () => update(context, cliente),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          title: 'Borrar',
                          color: redColor,
                          iconData: FluentIcons.delete,
                          onPressed: () => delete(context, cliente),
                        ),
                      ],
                    ),
                    // Flex(
                    //   direction: Axis.horizontal,
                    //   children: [
                    //     const SizedBox(width: 100, child: Text('')),
                    //     SizedBox(child: Text('Usuario: ${cliente.usuario}')),
                    //   ],
                    // )
                  ],
                );
              },
              separatorBuilder: (c, i) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              itemCount: isSearching ? filtro.length : list.length,
            );
          }),
        ),
      ],
    );
  }

  void refresh() async {
    final service = ClientesService();
    final clientesProv = Provider.of<ClientesProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getClientes(token).then((value) {
      clientesProv.clientes = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = ClientesService();
    final clientesProv = Provider.of<ClientesProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final celularCtrl = TextEditingController();
    // final usuarioCtrl = TextEditingController();
    // final passCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Cliente',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSuggestBox<String>(
                placeholder: 'Zona Code',
                controller: codigoCtrl,
                items: zonas
                    .map((e) => AutoSuggestBoxItem<String>(
                        value: e.zonaCode, label: e.zonaCode))
                    .toList(),
                onSelected: (v) => setState(() {
                  codigoCtrl.text = v.value!;
                }),
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: nombreCtrl,
                title: 'Nombre',
                width: 400,
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: celularCtrl,
                title: 'Celular',
                width: 400,
              ),
              // const SizedBox(height: 10),
              // CustomTextBox(
              //   controller: usuarioCtrl,
              //   title: 'Usuario',
              //   width: 400,
              // ),
              // const SizedBox(height: 10),
              // CustomTextBox(
              //   controller: passCtrl,
              //   title: 'Contraseña',
              //   width: 400,
              // ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);

              //validar que no existe usuario
              // for (var cliente in clientesProv.clientes) {
              //   if (cliente.usuario == usuarioCtrl.text) {
              //     Navigator.pop(context);
              //     return CustomDialog.errorDialog(
              //         context, 'El usuario ya esta en uso');
              //   }
              // }

              final cliente = Cliente(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
                celular: celularCtrl.text,
                zonaCode: codigoCtrl.text,
                // usuario: usuarioCtrl.text,
                // password: passCtrl.text,
              );
              await service.insertCliente(cliente, token).then((v) async {
                await service.getClientes(token).then((value) {
                  clientesProv.clientes = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Crear'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void update(BuildContext context, Cliente cliente) {
    final service = ClientesService();
    final clientesProv = Provider.of<ClientesProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final codigoCtrl = TextEditingController();
    codigoCtrl.text = cliente.zonaCode;
    final nombreCtrl = TextEditingController();
    nombreCtrl.text = cliente.nombre;
    final celularCtrl = TextEditingController();
    celularCtrl.text = cliente.celular.toString();
    final saldoMaxCtrl = TextEditingController();
    saldoMaxCtrl.text = cliente.saldoMaximo!.toStringAsFixed(2);
    final saldoMinCtrl = TextEditingController();
    saldoMinCtrl.text = cliente.saldoMinimo!.toStringAsFixed(2);
    // final usuarioCtrl = TextEditingController();
    // usuarioCtrl.text = cliente.usuario;
    // final passCtrl = TextEditingController();
    // passCtrl.text = cliente.password;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Cliente',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSuggestBox<String>(
                placeholder: 'Zona Code',
                controller: codigoCtrl,
                items: zonas
                    .map((e) => AutoSuggestBoxItem<String>(
                        value: e.zonaCode, label: e.zonaCode))
                    .toList(),
                onSelected: (v) => setState(() {
                  codigoCtrl.text = v.value!;
                }),
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: nombreCtrl,
                title: 'Nombre',
                width: 400,
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: celularCtrl,
                title: 'Celular',
                width: 400,
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: saldoMaxCtrl,
                title: 'Saldo Máximo',
                width: 400,
              ),
              const SizedBox(height: 10),
              CustomTextBox(
                controller: saldoMinCtrl,
                title: 'Saldo Mínimo',
                width: 400,
              ),
              // const SizedBox(height: 10),
              // CustomTextBox(
              //   controller: usuarioCtrl,
              //   title: 'Usuario',
              //   width: 400,
              // ),
              // const SizedBox(height: 10),
              // CustomTextBox(
              //   controller: passCtrl,
              //   title: 'Contraseña',
              //   width: 400,
              // ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newCliente = cliente.copyWith(
                newZone: codigoCtrl.text,
                newNombre: nombreCtrl.text,
                newCelular: celularCtrl.text,
                newSaldoMaximo: double.tryParse(saldoMaxCtrl.text),
                newSaldoMinimo: double.tryParse(saldoMinCtrl.text),
                // newUsuario: usuarioCtrl.text,
                // newPass: passCtrl.text,
              );
              // final userOK = usuarioCtrl.text.trim() == cliente.usuario.trim();

              // if (!userOK) {
              //   //validar que no existe usuario
              //   for (var cl in clientesProv.clientes) {
              //     if (cl.usuario == usuarioCtrl.text) {
              //       Navigator.pop(context);
              //       return CustomDialog.errorDialog(
              //           context, 'El usuario ya esta en uso');
              //     }
              //   }
              // }

              await service.updateCliente(newCliente, token).then((v) async {
                await service.getClientes(token).then((value) {
                  clientesProv.clientes = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Actualizar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void delete(BuildContext context, Cliente cliente) {
    final service = ClientesService();
    final camalesProv = Provider.of<ClientesProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Cliente',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar al cliente ${cliente.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteCliente(cliente, token).then((v) async {
                await service.getClientes(token).then((value) {
                  camalesProv.clientes = value;
                  Navigator.pop(context);
                });
              }).catchError((e) {
                Navigator.pop(context);
                CustomDialog.errorDialog(context, e.toString());
              });
            },
            child: const Text('Eliminar'),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
