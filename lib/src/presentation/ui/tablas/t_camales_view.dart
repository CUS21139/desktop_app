import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/camal.dart';
import '../../../services/camales_service.dart';

import '../../providers/usuarios_provider.dart';
import '../../providers/zonas_provider.dart';
import '../../providers/camales_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_custom.dart';
import '../../components/button_create.dart';
import '../../components/custom_dialogs.dart';
import '../../components/custom_textfield.dart';
import '../../utils/colors.dart';

class CamalesView extends StatefulWidget {
  const CamalesView({super.key});

  @override
  State<CamalesView> createState() => _CamalesViewState();
}

class _CamalesViewState extends State<CamalesView> {
  final camalCtrl = TextEditingController();

  List<Camal> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<CamalesProv>(context, listen: false);
    isSearching = camalCtrl.text.isNotEmpty;
    List<Camal> camales = [];
    camales.addAll(service.camales);
    if (isSearching) {
      camales.retainWhere((value) {
        String searchLetter = camalCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = camales;
    });
  }

  @override
  void initState() {
    camalCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    camalCtrl.dispose();
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
            controller: camalCtrl,
            placeholder: 'Buscar Camales',
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
          child: Consumer<CamalesProv>(
            builder: (_, service, __) {
              final list = service.camales;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (c, i) {
                  final camal = isSearching ? filtro[i] : list[i];
                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(camal.zonaCode),
                      ),
                      Text(camal.nombre),
                      const Spacer(),
                      CustomButton(
                        title: 'Editar',
                        color: greenColor,
                        iconData: FluentIcons.edit,
                        onPressed: () => update(context, camal),
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        title: 'Borrar',
                        color: redColor,
                        iconData: FluentIcons.delete,
                        onPressed: () => delete(context, camal),
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
            },
          ),
        ),
      ],
    );
  }

  void refresh() async {
    final service = CamalesService();
    final camalesProv = Provider.of<CamalesProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getCamales(token).then((value) {
      camalesProv.camales = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = CamalesService();
    final camalesProv = Provider.of<CamalesProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
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
          'Crear Nuevo Camal',
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
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final camal = Camal(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
                zonaCode: codigoCtrl.text,
              );
              await service.insertCamal(camal, token).then((v) async {
                await service.getCamales(token).then((value) {
                  camalesProv.camales = value;
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

  void update(BuildContext context, Camal camal) {
    final service = CamalesService();
    final camalesProv = Provider.of<CamalesProv>(context, listen: false);
    final zonas = Provider.of<ZonasProv>(context, listen: false).zonas;
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final codigoCtrl = TextEditingController();
    codigoCtrl.text = camal.zonaCode;
    final nombreCtrl = TextEditingController();
    nombreCtrl.text = camal.nombre;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Camal',
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
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newCamal = camal.copyWith(
                newZoneCod: codigoCtrl.text,
                newNombre: nombreCtrl.text,
              );
              await service.updateCamal(newCamal, token).then((v) async {
                await service.getCamales(token).then((value) {
                  camalesProv.camales = value;
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

  void delete(BuildContext context, Camal camal) {
    final service = CamalesService();
    final camalesProv = Provider.of<CamalesProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Camal',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child:
              Text('¿Está seguro que desea eliminar el camal ${camal.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteCamal(camal, token).then((v) async {
                await service.getCamales(token).then((value) {
                  camalesProv.camales = value;
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
