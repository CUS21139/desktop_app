import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '/src/presentation/providers/compras_beneficiado_provider.dart';
import '/src/presentation/providers/ventas_beneficiado_provider.dart';
import '/src/presentation/ui/compras_beneficiado/view_compras.dart';
import '/src/presentation/ui/modelo_pedido_beneficiado/view_modelo_pedido.dart';
import '/src/presentation/ui/programacion_beneficiado/view_programacion.dart';
import '/src/presentation/ui/resumen_beneficiado/resumen_ben_view.dart';
import '/src/presentation/ui/ventas_beneficiado/view_ventas.dart';

import '../providers/compras_vivo_provider.dart';
import '../providers/ventas_vivo_provider.dart';

import '/src/presentation/components/custom_dialogs.dart';

import '/src/presentation/providers/pesaje_manual_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/presentation/ui/caja/view_caja.dart';
import 'compras_vivos/view_compras.dart';
import '/src/presentation/ui/estados_cta/estados_cta_view.dart';
// import '/src/presentation/ui/jabas/view_jabas.dart';
import '/src/presentation/ui/login_view.dart';
import 'modelo_pedido_vivos/view_modelo_pedido.dart';
import 'pesaje_manual_vivos/view_pesaje.dart';
import 'programacion_vivos/view_programacion.dart';
import 'resumen_vivo/resumen_vivo_view.dart';
import '/src/presentation/ui/saldos/view_saldos.dart';
import '/src/presentation/ui/tablas/tablas_view.dart';
import 'ventas_vivos/view_ventas.dart';

import '/src/services/login_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class _HomeViewState extends State<HomeView> with WindowListener {
  final loginServ = LoginService();

  int select = 0;

  @override
  void initState() {
    final role = Provider.of<UsuariosProv>(context, listen: false).usuario.role;
    if (role == 'PED') select = 2;
    if (role == 'FIN') select = 1;
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
    final pesajeProv = Provider.of<PesajeManualProv>(context);
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final compraBenProv =
        Provider.of<ComprasBeneficiadoProv>(context, listen: false);
    final user = Provider.of<UsuariosProv>(context, listen: false).usuario;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ventaBenProv =
        Provider.of<VentasBeneficiadoProv>(context, listen: false);
    return NavigationView(
      appBar: NavigationAppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo_simple.png',
              height: 30,
              filterQuality: FilterQuality.medium,
            ),
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
                }),
          ],
        ),
        backgroundColor: Colors.white,
        actions: isDesktop ? const WindowCaption() : null,
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
          header: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                user.nombre,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          selected: select,
          onChanged: (i) {
            compraProv.compraInitState();
            compraBenProv.compraInitState();
            ventaProv.ventaInitState();
            ventaBenProv.ventaInitState();
            setState(() => select = i);
          },
          size: NavigationPaneSize(
            openMinWidth: size.width <= 1366 ? 170 : 200,
            openMaxWidth: size.width <= 1366 ? 170 : 200,
          ),
          items: [
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.blue.withOpacity(0.5)),
              icon: const Icon(FluentIcons.money),
              title: const Text(
                'Saldos',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const SaldosView(),
              enabled: user.role != 'PED',
            ),
            // PaneItem(
            //   icon: const Icon(FluentIcons.event_accepted),
            //   title: const Text('Recojo Jabas'),
            //   body: const JabasView(),
            //   enabled: user.role != 'PED',
            // ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.blue.withOpacity(0.5)),
              icon: const Icon(FluentIcons.analytics_view),
              title: const Text(
                'Est de Cuenta',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const EstadosView(),
              enabled: user.role != 'PED',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.blue.withOpacity(0.5)),
              icon: const Icon(FluentIcons.financial_solid),
              title: const Text(
                'Caja',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const CajaView(),
              enabled: user.role != 'PED',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.blue.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.blue.withOpacity(0.5)),
              icon: const Icon(FluentIcons.view_dashboard),
              title: const Text(
                'Tablas',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const TablasView(),
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.yellow.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.yellow.withOpacity(0.5)),
              icon: const Icon(FluentIcons.home),
              title: const Text(
                'Resumen Vivo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ResumenVivoView(),
              enabled: user.role == 'ADM',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.yellow.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.yellow.withOpacity(0.5)),
              icon: const Icon(FluentIcons.bus),
              title: const Text(
                'Pedidos Vivo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: pesajeProv.pesajeManual
                  ? const PesajeManualView()
                  : const ProgramacionVivoView(),
              enabled: user.role != 'FIN',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.yellow.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.yellow.withOpacity(0.5)),
              icon: const Icon(FluentIcons.shop_server),
              title: const Text(
                'Ventas Vivo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const VentasVivoView(),
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.yellow.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.yellow.withOpacity(0.5)),
              icon: const Icon(FluentIcons.shop),
              title: const Text(
                'Compras Vivo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ComprasVivosView(),
              enabled: user.role == 'ADM',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.yellow.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.yellow.withOpacity(0.5)),
              icon: const Icon(FluentIcons.modeling_view),
              title: const Text(
                'Modelo Pedidos Vivo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ModeloPedidoVivoView(),
              enabled: user.role != 'FIN',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.orange.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.orange.withOpacity(0.5)),
              icon: const Icon(FluentIcons.home),
              title: const Text(
                'Resumen Ben',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ResumenBeneficiadoView(),
              enabled: user.role == 'ADM',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.orange.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.orange.withOpacity(0.5)),
              icon: const Icon(FluentIcons.bus),
              title: const Text(
                'Pedidos Ben',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: pesajeProv.pesajeManual
                  ? const PesajeManualView()
                  : const ProgramacionBeneficiadoView(),
              enabled: user.role != 'FIN',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.orange.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.orange.withOpacity(0.5)),
              icon: const Icon(FluentIcons.shop_server),
              title: const Text(
                'Ventas Ben',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const VentasBeneficiadoView(),
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.orange.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.orange.withOpacity(0.5)),
              icon: const Icon(FluentIcons.shop),
              title: const Text(
                'Compras Ben',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ComprasBeneficiadoView(),
              enabled: user.role == 'ADM',
            ),
            PaneItem(
              tileColor: WidgetStatePropertyAll(Colors.orange.withOpacity(0.1)),
              selectedTileColor:
                  WidgetStatePropertyAll(Colors.orange.withOpacity(0.5)),
              icon: const Icon(FluentIcons.modeling_view),
              title: const Text(
                'Modelo Pedidos Ben',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              body: const ModeloPedidoBeneficiadoView(),
              enabled: user.role != 'FIN',
            ),
          ],
          footerItems: [
            PaneItemAction(
              icon: const Icon(FluentIcons.sign_out),
              title: const Text(
                'Cerrar Sesion',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                CustomDialog.loadingDialog(context);
                final userProv =
                    Provider.of<UsuariosProv>(context, listen: false);
                await loginServ.logout(userProv.usuario.email).then((resp) {
                  Navigator.pop(context);
                  if (resp['ok'] == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        FluentPageRoute(builder: (_) => const LoginPage()),
                        (route) => false);
                  } else {
                    CustomDialog.errorDialog(context, resp['message']);
                  }
                }).catchError((e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                });
              },
            ),
          ]),
    );
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
