import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/pesador.dart';
import '../../../services/pesadores_service.dart';

import '../../providers/pesadores_provider.dart';
import '../../providers/usuarios_provider.dart';
import '../../providers/zonas_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../components/button_create.dart';
import '../../utils/colors.dart';

class PesadoresView extends StatefulWidget {
  const PesadoresView({super.key});

  @override
  State<PesadoresView> createState() => _PesadoresViewState();
}

class _PesadoresViewState extends State<PesadoresView> {
  final pesadorCtrl = TextEditingController();

  List<Pesador> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<PesadoresProv>(context, listen: false);
    isSearching = pesadorCtrl.text.isNotEmpty;
    List<Pesador> pesadores = [];
    pesadores.addAll(service.pesadores);
    if (isSearching) {
      pesadores.retainWhere((value) {
        String searchLetter = pesadorCtrl.text.toLowerCase();
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
    pesadorCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    pesadorCtrl.dispose();
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
            controller: pesadorCtrl,
            placeholder: 'Buscar Pesador',
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
          child: Consumer<PesadoresProv>(builder: (_, service, __) {
            final list = service.pesadores;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final pesador = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(pesador.zonaCode)),
                    Text(pesador.nombre),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, pesador),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, pesador),
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
    final service = PesadoresService();
    final pesadoresProv = Provider.of<PesadoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getPesadores(token).then((value) {
      pesadoresProv.pesadores = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = PesadoresService();
    final pesadoresProv = Provider.of<PesadoresProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Pesador',
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
                placeholder: 'Password',
                controller: passwordCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final pesador = Pesador(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
                password: passwordCtrl.text,
                zonaCode: codigoCtrl.text,
              );
              await service.insertPesador(pesador, token).then((v) async {
                await service.getPesadores(token).then((value) {
                  pesadoresProv.pesadores = value;
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

  void update(BuildContext context, Pesador pesador) {
    final service = PesadoresService();
    final pesadoresProv = Provider.of<PesadoresProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final codigoCtrl = TextEditingController();
    codigoCtrl.text = pesador.zonaCode;
    final nombreCtrl = TextEditingController();
    nombreCtrl.text = pesador.nombre;
    final passCtrl = TextEditingController();
    passCtrl.text = pesador.password.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Pesador',
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
                placeholder: 'Password',
                controller: passCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newPesador = pesador.copyWith(
                newZonaCode: codigoCtrl.text,
                newNombre: nombreCtrl.text,
                newPassword: passCtrl.text,
              );
              await service.updateCliente(newPesador, token).then((v) async {
                await service.getPesadores(token).then((value) {
                  pesadoresProv.pesadores = value;
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

  void delete(BuildContext context, Pesador pesador) {
    final service = PesadoresService();
    final pesadoresProv = Provider.of<PesadoresProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Pesador',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar al pesador ${pesador.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deletePesador(pesador, token).then((v) async {
                await service.getPesadores(token).then((value) {
                  pesadoresProv.pesadores = value;
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
