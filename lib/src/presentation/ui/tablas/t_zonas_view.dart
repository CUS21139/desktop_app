import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/zona.dart';
import '../../../services/zonas_service.dart';

import '../../providers/usuarios_provider.dart';
import '../../providers/zonas_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../utils/colors.dart';

class ZonasView extends StatefulWidget {
  const ZonasView({super.key});

  @override
  State<ZonasView> createState() => _ZonasViewState();
}

class _ZonasViewState extends State<ZonasView> {
  final zonaCtrl = TextEditingController();

  List<Zona> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<ZonasProv>(context, listen: false);
    isSearching = zonaCtrl.text.isNotEmpty;
    List<Zona> zonas = [];
    zonas.addAll(service.zonas);
    if (isSearching) {
      zonas.retainWhere((value) {
        String searchLetter = zonaCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
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
            placeholder: 'Buscar Zona',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 100,
                child: Text('CODIGO',
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
          child: Consumer<ZonasProv>(builder: (_, service, __) {
            final list = service.zonas;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final zona = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(zona.zonaCode)),
                    Text(zona.nombre),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, zona),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, zona),
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
    final service = ZonasService();
    final zonasProv = Provider.of<ZonasProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getZonas(token).then((value) {
      zonasProv.zonas = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = ZonasService();
    final zonasProv = Provider.of<ZonasProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nueva Zona',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                placeholder: 'Codigo',
                controller: codigoCtrl,
              ),
              const SizedBox(height: 10),
              TextBox(
                placeholder: 'Nombre',
                controller: nombreCtrl,
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final zona = Zona(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
                zonaCode: codigoCtrl.text,
              );
              await service.insertZona(zona, token).then((v) async {
                Navigator.pop(context);
                zonasProv.zonas = await service.getZonas(token);
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

  void update(BuildContext context, Zona zona) {
    final service = ZonasService();
    final zonasProv = Provider.of<ZonasProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final nombreCtrl = TextEditingController();
    nombreCtrl.text = zona.nombre;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Zona',
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
              final newZona = zona.copyWith(
                newNombre: nombreCtrl.text,
              );
              await service.updateZona(newZona, token).then((v) async {
                Navigator.pop(context);
                zonasProv.zonas = await service.getZonas(token);
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

  void delete(BuildContext context, Zona zona) {
    final service = ZonasService();
    final zonasProv = Provider.of<ZonasProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Zona',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child:
              Text('¿Está seguro que desea eliminar la zona ${zona.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteZona(zona, token).then((v) async {
                Navigator.pop(context);
                zonasProv.zonas = await service.getZonas(token);
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
