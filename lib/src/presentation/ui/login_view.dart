import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '/src/models/usuario.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '/src/presentation/ui/home_view.dart';
import '/src/services/init_service.dart';
import '/src/services/login_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class _LoginPageState extends State<LoginPage> with WindowListener {
  final loginService = LoginService();

  final key = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String errorMessage = '';
  bool obscure = true;

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NavigationView(
      appBar: NavigationAppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_mabel.png', height: 30),
            const SizedBox(width: 20),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snap) {
                final version = snap.hasData ? snap.data!.version : '1.0.0';
                return Text(
                  'MABEL Admin v$version',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: isDesktop ? const WindowCaption() : null,
        automaticallyImplyLeading: false,
      ),
      content: Row(
        children: [
          SizedBox(
            height: size.height,
            width: size.width * 0.35,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/logo_mabel.png',
                        height: size.height * 0.2,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      'Usuario',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextFormBox(
                      controller: emailCtrl,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Contraseña',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextFormBox(
                      controller: passCtrl,
                      obscureText: obscure,
                      suffix: IconButton(
                        icon: Icon(
                          obscure ? FluentIcons.hide : FluentIcons.red_eye,
                          size: 20,
                        ),
                        onPressed: () => setState(() {
                          obscure = !obscure;
                        }),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: FilledButton(
                        child: const Text('Iniciar Sesión'),
                        onPressed: () => iniciarSesion(context),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width * 0.65,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width * 0.65,
                  child: Image.asset(
                    'assets/fondo.png',
                    fit: BoxFit.fitHeight,
                    filterQuality: FilterQuality.low,
                  ),
                ),
                SizedBox(
                  height: size.height,
                  width: size.width * 0.65,
                  child: const Acrylic(
                    tint: Colors.white,
                    blurAmount: 15,
                    luminosityAlpha: 0.001,
                  ),
                ),
                Align(
                  alignment: 
                  Alignment.center,
                  child: SizedBox(
                    height: size.height,
                    width: size.width * 0.5,
                    child: Image.asset(
                      'assets/fondo.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> iniciarSesion(BuildContext context) async {
    final usuarioProv = Provider.of<UsuariosProv>(context, listen: false);
    CustomDialog.loadingDialog(context);
    await loginService.login(emailCtrl.text, passCtrl.text).then((resp) async {
      if (resp['ok'] == true) {
        usuarioProv.usuario = Usuario.fromJson(resp['user']);
        usuarioProv.token = resp['token'];
        await InitService.cargarDatos(context, resp['token']).then((_) {
          Navigator.pushAndRemoveUntil(
            context,
            FluentPageRoute(builder: (_) => const HomeView()),
            (route) => false,
          );
        }).catchError((e) {
          Navigator.pop(context);
          CustomDialog.errorDialog(context, e.toString());
        });
      } else {
        Navigator.pop(context);
        CustomDialog.errorDialog(context, resp['message']);
      }
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  @override
  void onWindowClose() async {
    await windowManager.isPreventClose().then((value) {
      if (value) {
        showDialog(
          context: context,
          builder: (_) {
            return ContentDialog(
              title: const Text(
                'Cerrar MABEL Admin',
                style: TextStyle(fontSize: 18),
              ),
              content: const Text('¿Estás seguro que quieres salir?'),
              actions: [
                Button(
                  child: const Text('Si'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await windowManager.destroy();
                  },
                ),
                FilledButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
