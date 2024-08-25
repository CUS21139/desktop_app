import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/banco.dart';
import '../../../services/bancos_service.dart';

import '../../providers/usuarios_provider.dart';
import '../../providers/bancos_provider.dart';

import '../../components/button_refresh.dart';
import '../../components/button_create.dart';
import '../../components/button_custom.dart';
import '../../components/custom_dialogs.dart';
import '../../components/custom_textfield.dart';
import '../../utils/colors.dart';

class BancosView extends StatefulWidget {
  const BancosView({super.key});

  @override
  State<BancosView> createState() => _BancosViewState();
}

class _BancosViewState extends State<BancosView> {
  final bancoCtrl = TextEditingController();

  List<Banco> filtro = [];

  bool isSearching = false;

  void filter() {
    final service = Provider.of<BancosProv>(context, listen: false);
    isSearching = bancoCtrl.text.isNotEmpty;
    List<Banco> bancos = [];
    bancos.addAll(service.bancos);
    if (isSearching) {
      bancos.retainWhere((value) {
        String searchLetter = bancoCtrl.text.toLowerCase();
        String name = value.nombre.toLowerCase();
        return name.contains(searchLetter);
      });
    }
    setState(() {
      filtro = bancos;
    });
  }

  @override
  void initState() {
    bancoCtrl.addListener(() => filter());
    super.initState();
  }

  @override
  void dispose() {
    bancoCtrl.dispose();
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
            controller: bancoCtrl,
            placeholder: 'Buscar Banco',
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
          child: Consumer<BancosProv>(builder: (_, service, __) {
            final list = service.bancos;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final banco = isSearching ? filtro[i] : list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(banco.estadoCta ?? 'NA'),
                    ),
                    Text(banco.nombre),
                    const Spacer(),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, banco),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, banco),
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
    final service = BancosService();
    final bancosProv = Provider.of<BancosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getBancos(token).then((value) {
      bancosProv.bancos = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = BancosService();
    final bancosProv = Provider.of<BancosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final user =
        Provider.of<UsuariosProv>(context, listen: false).usuario.nombre;

    final nombreCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Banco',
          style: TextStyle(fontSize: 16),
        ),
        content: CustomTextBox(
          controller: nombreCtrl,
          title: 'Nombre',
          width: 400,
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final banco = Banco(
                createdAt: DateTime.now(),
                createdBy: user,
                nombre: nombreCtrl.text,
              );
              await service.insertBanco(banco, token).then((v) async {
                await service.getBancos(token).then((value) {
                  bancosProv.bancos = value;
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

  void update(BuildContext context, Banco banco) {
    final service = BancosService();
    final bancosProv = Provider.of<BancosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final nombreCtrl = TextEditingController();
    nombreCtrl.text = banco.nombre;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Banco',
          style: TextStyle(fontSize: 16),
        ),
        content: CustomTextBox(
          controller: nombreCtrl,
          title: 'Nombre',
          width: 400,
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final newBanco = banco.copyWith(
                newNombre: nombreCtrl.text,
              );
              await service.updateBanco(newBanco, token).then((v) async {
                await service.getBancos(token).then((value) {
                  bancosProv.bancos = value;
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

  void delete(BuildContext context, Banco banco) {
    final service = BancosService();
    final bancosProv = Provider.of<BancosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Banco',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child:
              Text('¿Está seguro que desea eliminar el banco ${banco.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteBanco(banco, token).then((v) async {
                await service.getBancos(token).then((value) {
                  bancosProv.bancos = value;
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
