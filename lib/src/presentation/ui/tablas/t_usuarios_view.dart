import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/usuario.dart';
import '/src/presentation/components/button_create.dart';
import '/src/presentation/components/button_custom.dart';
import '/src/presentation/components/button_refresh.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/custom_textfield.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/utils/colors.dart';
import '/src/services/login_service.dart';

// ignore: constant_identifier_names
enum Role { ADM, FIN, PED }

class UsuariosView extends StatefulWidget {
  const UsuariosView({super.key});

  @override
  State<UsuariosView> createState() => _UsuariosViewState();
}

class _UsuariosViewState extends State<UsuariosView> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 100,
                child:
                    Text('TIPO', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 250,
                child: Text('EMAIL',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Text('NOMBRE',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              RefreshButton(onPressed: () => refresh(context)),
              const SizedBox(width: 30),
              Container(
                alignment: Alignment.topRight,
                child: CreateButton(onPressed: () => create(context)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<UsuariosProv>(builder: (_, service, __) {
            final list = service.usuarios;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (c, i) {
                final usuario = list[i];
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(width: 100, child: Text(usuario.role)),
                    SizedBox(width: 250, child: Text(usuario.email)),
                    Text(usuario.nombre),
                    const Spacer(),
                    CustomButton(
                      title: 'Cambiar Password',
                      color: blueColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => changePass(context, usuario),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Editar',
                      color: greenColor,
                      iconData: FluentIcons.edit,
                      onPressed: () => update(context, usuario),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      title: 'Borrar',
                      color: redColor,
                      iconData: FluentIcons.delete,
                      onPressed: () => delete(context, usuario),
                    ),
                  ],
                );
              },
              separatorBuilder: (c, i) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              itemCount: list.length,
            );
          }),
        ),
      ],
    );
  }

  void refresh(BuildContext context) async {
    final service = LoginService();
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    CustomDialog.loadingDialog(context);
    await service.getUsers(token).then((value) {
      userProv.usuarios = value;
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void create(BuildContext context) {
    final service = LoginService();
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final roleCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Crear Nuevo Usuario',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              controller: nombreCtrl,
              title: 'Nombre',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: emailCtrl,
              title: 'Email',
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: passwordCtrl,
              title: 'Password',
              width: 400,
            ),
            const SizedBox(height: 10),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.w500)),
            AutoSuggestBox<String>(
              placeholder: 'Role',
              controller: roleCtrl,
              items: Role.values
                  .map((e) =>
                      AutoSuggestBoxItem<String>(value: e.name, label: e.name))
                  .toList(),
              onSelected: (v) => setState(() {
                roleCtrl.text = v.value!;
              }),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service
                  .createUser(
                nombreCtrl.text,
                emailCtrl.text,
                passwordCtrl.text,
                roleCtrl.text,
              )
                  .then((v) async {
                await service.getUsers(token).then((value) {
                  userProv.usuarios = value;
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

  void update(BuildContext context, Usuario usuario) {
    final service = LoginService();
    final bancosProv = Provider.of<UsuariosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final nombreCtrl = TextEditingController();
    nombreCtrl.text = usuario.nombre;
    final roleCtrl = TextEditingController();
    roleCtrl.text = usuario.role;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Actualizar Usuario',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              controller: nombreCtrl,
              title: 'Nombre',
              width: 400,
            ),
            const SizedBox(height: 10),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.w500)),
            AutoSuggestBox<String>(
              placeholder: 'Role',
              controller: roleCtrl,
              items: Role.values
                  .map((e) =>
                      AutoSuggestBoxItem<String>(value: e.name, label: e.name))
                  .toList(),
              onSelected: (v) => setState(() {
                roleCtrl.text = v.value!;
              }),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              final user = usuario.copyWith(
                  newNombre: nombreCtrl.text, newRole: roleCtrl.text);
              await service.updateUsuario(user, token).then((v) async {
                await service.getUsers(token).then((value) {
                  bancosProv.usuarios = value;
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

  void changePass(BuildContext context, Usuario usuario) {
    final service = LoginService();
    final userProv = Provider.of<UsuariosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;

    final admPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Cambiar Password',
          style: TextStyle(fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextBox(
              controller: admPassCtrl,
              title: 'Password ADMIN',
              obscure: true,
              width: 400,
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              controller: newPassCtrl,
              title: 'Password Nuevo',
              width: 400,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              if (newPassCtrl.text.isEmpty || admPassCtrl.text.isEmpty) {
                return CustomDialog.errorDialog(
                    context, 'Los campos no pueden estar vacios');
              }
              CustomDialog.loadingDialog(context);
              await service
                  .changePass(usuario.id!, userProv.usuario.email,
                      admPassCtrl.text, newPassCtrl.text, token)
                  .then((v) async {
                await service.getUsers(token).then((value) {
                  userProv.usuarios = value;
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

  void delete(BuildContext context, Usuario usuario) {
    final service = LoginService();
    final usuariosProv = Provider.of<UsuariosProv>(context, listen: false);
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ContentDialog(
        title: const Text(
          'Eliminar Usuario',
          style: TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: 400,
          child: Text(
              '¿Está seguro que desea eliminar el usuario ${usuario.nombre}?'),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              CustomDialog.loadingDialog(context);
              await service.deleteUsuario(usuario, token).then((v) async {
                await service.getUsers(token).then((value) {
                  usuariosProv.usuarios = value;
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
