import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/vehiculo.dart';

import '/src/presentation/providers/vehiculos_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/vehiculos_service.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../utils/colors.dart';

class VehiculosView extends StatefulWidget {
  const VehiculosView({super.key});

  @override
  State<VehiculosView> createState() => _VehiculosViewState();
}

class _VehiculosViewState extends State<VehiculosView> {
  final service = VehiculosService();
  final zonaCtrl = TextEditingController();

  List<Vehiculo> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<VehiculosProvider>(context, listen: false);
    isSearching = zonaCtrl.text.isNotEmpty;
    List<Vehiculo> zonas = [];
    zonas.addAll(service.vehiculos);
    if (isSearching) {
      zonas.retainWhere((value) {
        String searchLetter = zonaCtrl.text.toLowerCase();
        String name = value.placa.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = zonas;
    });
  }

  @override
  void initState() {
    zonaCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    zonaCtrl.dispose();
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
            controller: zonaCtrl,
            placeholder: 'Buscar Vehiculo',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 100,
                child: Text('PLACA',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Text('CAPACIDAD',
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
          child: Consumer<VehiculosProvider>(builder: (_, service, __) {
            final list = service.vehiculos;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final vehiculo = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(vehiculo.placa)),
                    Text(vehiculo.capacidad.toString()),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, vehiculo),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, vehiculo),
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
    final vehiculosProv = Provider.of<VehiculosProvider>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getVehiculos(token).then((value) {
      vehiculosProv.vehiculos = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final vehiculosProv = Provider.of<VehiculosProvider>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final placaCtrl = TextEditingController();
    final capacidadCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Vehiculo',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                placeholder: 'Placa',
                controller: placaCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Capacidad',
                controller: capacidadCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              final cap = int.tryParse(capacidadCtrl.text);
              if(cap == null){
                CustomDialog.errorDialog(context, 'Ingrese un número válido');
                return;
              }

              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final vehiculo = Vehiculo(
                createdAt: DateTime.now(),
                createdBy: user,
                placa: placaCtrl.text,
                capacidad: cap,
              );
              await service.insertVehiculo(vehiculo, token).then((v) async {
                Navigator.pop(context);
                vehiculosProv.vehiculos = await service.getVehiculos(token);
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

  void update(BuildContext context, Vehiculo vehiculo) {
    final vehiculosProv = Provider.of<VehiculosProvider>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final capacidadCtrl = TextEditingController();
    capacidadCtrl.text = vehiculo.capacidad.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Vehiculo',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: TextBox(
            placeholder: 'Capacidad',
            controller: capacidadCtrl,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              final cap = int.tryParse(capacidadCtrl.text);
              if(cap == null){
                CustomDialog.errorDialog(context, 'Ingrese un número válido');
                return;
              }

              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newVehiculo = vehiculo.copyWith(
                newCapacidad: cap,
              );
              await service.updateVehiculo(newVehiculo, token).then((v) async {
                Navigator.pop(context);
                vehiculosProv.vehiculos = await service.getVehiculos(token);
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

  void delete(BuildContext context, Vehiculo vehiculo) {
    final vehiculosProv = Provider.of<VehiculosProvider>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Vehiculo',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child:
              Text('¿Está seguro que desea eliminar el vehiculo ${vehiculo.placa}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteVehiculo(vehiculo, token).then((v) async {
                Navigator.pop(context);
                vehiculosProv.vehiculos = await service.getVehiculos(token);
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
