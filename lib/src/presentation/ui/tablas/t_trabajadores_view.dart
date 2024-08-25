import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/trabajador.dart';
import '../../../services/trabajadores_service.dart';

import '../../providers/usuarios_provider.dart';
import '../../providers/zonas_provider.dart';
import '../../providers/trabajadores_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../utils/colors.dart';

class TrabajadoresView extends StatefulWidget {
  const TrabajadoresView({super.key});

  @override
  State<TrabajadoresView> createState() => _TrabajadoresViewState();
}

class _TrabajadoresViewState extends State<TrabajadoresView> {
  final trabajadorCtrl = TextEditingController();

  List<Trabajador> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<TrabajadoresProv>(context, listen: false);
    isSearching = trabajadorCtrl.text.isNotEmpty;
    List<Trabajador> trabajadores = [];
    trabajadores.addAll(service.trabajadores);
    if (isSearching) {
      trabajadores.retainWhere((value) {
        String searchLetter = trabajadorCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = trabajadores;
    });
  }

  @override
  void initState() {
    trabajadorCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    trabajadorCtrl.dispose();
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
            controller: trabajadorCtrl,
            placeholder: 'Buscar Trabajador',
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
                width: 150,
                child: Text('CELULAR',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 200,
                child: Text('NOMBRE',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Text('SUELDO/DIA',
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
          child: Consumer<TrabajadoresProv>(builder: (_, service, __) {
            final list = service.trabajadores;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final trabajador = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(trabajador.zonaCode)),
                    SizedBox(
                        width: 200, child: Text(trabajador.estadoCta ?? 'NA')),
                    SizedBox(width: 150, child: Text('${trabajador.celular}')),
                    SizedBox(width: 200, child: Text(trabajador.nombre)),
                    Text('S/ ${trabajador.sueldoDia.toStringAsFixed(2)}'),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, trabajador),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, trabajador),
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
    final service = TrabajadoresService();
    final trabajadoresProv =
        Provider.of<TrabajadoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getTrabajadores(token).then((value) {
      trabajadoresProv.trabajadores = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = TrabajadoresService();
    final trabajadoresProv =
        Provider.of<TrabajadoresProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final celularCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final sueldoCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Trabajador',
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
              TextBox(
                placeholder: 'Nombre',
                controller: nombreCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Celular',
                controller: celularCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Password',
                controller: passCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Sueldo/Dia',
                controller: sueldoCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final camal = Trabajador(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
                celular: int.tryParse(celularCtrl.text),
                zonaCode: codigoCtrl.text,
                sueldoDia: double.tryParse(sueldoCtrl.text) ?? 0,
                password: passCtrl.text
              );
              await service.insertTrabajador(camal, token).then((v) async {
                Navigator.pop(context);
                trabajadoresProv.trabajadores =
                    await service.getTrabajadores(token);
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

  void update(BuildContext context, Trabajador trabajador) {
    final service = TrabajadoresService();
    final trabajadoresProv =
        Provider.of<TrabajadoresProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final codigoCtrl = TextEditingController();
    codigoCtrl.text = trabajador.zonaCode;
    final nombreCtrl = TextEditingController();
    nombreCtrl.text = trabajador.nombre;
    final celularCtrl = TextEditingController();
    celularCtrl.text = trabajador.celular.toString();
    final sueldoCtrl = TextEditingController();
    sueldoCtrl.text = trabajador.sueldoDia.toString();
    final passCtrl = TextEditingController(text: trabajador.password);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Trabajador',
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
              TextBox(
                placeholder: 'Nombre',
                controller: nombreCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Celular',
                controller: celularCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Password',
                controller: passCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Sueldo/Dia',
                controller: sueldoCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newCliente = trabajador.copyWith(
                newZone: codigoCtrl.text,
                newNombre: nombreCtrl.text,
                newCelular: int.tryParse(celularCtrl.text),
                newSueldo: double.tryParse(sueldoCtrl.text),
                newPass: passCtrl.text,
              );
              await service.updateTrabajador(newCliente, token).then((v) async {
                Navigator.pop(context);
                trabajadoresProv.trabajadores =
                    await service.getTrabajadores(token);
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

  void delete(BuildContext context, Trabajador trabajador) {
    final service = TrabajadoresService();
    final trabajadoresProv =
        Provider.of<TrabajadoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Trabajador',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar al trabajador ${trabajador.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteTrabajador(trabajador, token).then((v) async {
                Navigator.pop(context);
                trabajadoresProv.trabajadores =
                    await service.getTrabajadores(token);
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
