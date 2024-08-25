import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/proveedor.dart';
import '../../../services/proveedores_service.dart';

import '../../providers/proveedores_provider.dart';
import '../../providers/usuarios_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../utils/colors.dart';

class ProveedorView extends StatefulWidget {
  const ProveedorView({super.key});

  @override
  State<ProveedorView> createState() => _ProveedorViewState();
}

class _ProveedorViewState extends State<ProveedorView> {
  final proveedorCtrl = TextEditingController();

  List<Proveedor> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<ProveedoresProv>(context, listen: false);
    isSearching = proveedorCtrl.text.isNotEmpty;
    List<Proveedor> pesadores = [];
    pesadores.addAll(service.proveedores);
    if (isSearching) {
      pesadores.retainWhere((value) {
        String searchLetter = proveedorCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = pesadores;
    });
  }

  @override
  void initState() {
    proveedorCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    proveedorCtrl.dispose();
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
            controller: proveedorCtrl,
            placeholder: 'Buscar Proveedor',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 200,
                child: Text('ESTADO CTA',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Text('NOMBRE',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
          child: Consumer<ProveedoresProv>(builder: (_, service, __) {
            final list = service.proveedores;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final proveedor = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                        width: 200, child: Text(proveedor.estadoCta ?? 'NA')),
                    Text(proveedor.nombre),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, proveedor),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, proveedor),
                    ),
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
    final service = ProveedoresService();
    final proveedoresProv =
        Provider.of<ProveedoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getProveedores(token).then((value) {
      proveedoresProv.proveedores = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = ProveedoresService();
    final proveedoresProv =
        Provider.of<ProveedoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final nombreCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Proveedor',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: TextBox(
            placeholder: 'Nombre',
            controller: nombreCtrl,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final proveedor = Proveedor(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
              );
              await service.insertProveedor(proveedor, token).then((v) async {
                await service.getProveedores(token).then((value) {
                  proveedoresProv.proveedores = value;
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

  void update(BuildContext context, Proveedor proveedor) {
    final service = ProveedoresService();
    final proveedoresProv =
        Provider.of<ProveedoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final nombreCtrl = TextEditingController();
    nombreCtrl.text = proveedor.nombre;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Proveedor',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: TextBox(
            placeholder: 'Nombre',
            controller: nombreCtrl,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newProveedor = proveedor.copyWith(
                newNombre: nombreCtrl.text,
              );
              await service
                  .updateProveedor(newProveedor, token)
                  .then((v) async {
                await service.getProveedores(token).then((value) {
                  proveedoresProv.proveedores = value;
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

  void delete(BuildContext context, Proveedor proveedor) {
    final service = ProveedoresService();
    final proveedoresProv =
        Provider.of<ProveedoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Proveedor',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar al proveedor ${proveedor.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteProveedor(proveedor, token).then((v) async {
                await service.getProveedores(token).then((value) {
                  proveedoresProv.proveedores = value;
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
