import 'package:app_desktop/src/presentation/providers/compras_beneficiado_provider.dart';
import 'package:app_desktop/src/presentation/providers/ordenes_beneficiado_provider.dart';
import 'package:app_desktop/src/presentation/providers/ordenes_modelo_beneficiado_provider.dart';
import 'package:app_desktop/src/presentation/providers/productos_beneficiado_provider.dart';
import 'package:app_desktop/src/presentation/providers/ventas_beneficiado_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';

import '/src/presentation/providers/bancos_provider.dart';
import '/src/presentation/providers/caja_provider.dart';
import '/src/presentation/providers/camales_jabas_prov.dart';
import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import 'src/presentation/providers/compras_vivo_provider.dart';
import '/src/presentation/providers/estado_banco_provider.dart';
import '/src/presentation/providers/estado_cliente_provider.dart';
import '/src/presentation/providers/estado_gavipo_provider.dart';
import '/src/presentation/providers/estado_proveedor_mov.dart';
import '/src/presentation/providers/estado_trabajador_mov.dart';
import '/src/presentation/providers/estado_sin_nombre_provider.dart';
import '/src/presentation/providers/jabas_provider.dart';
import '/src/presentation/providers/ayer_hoy_provider.dart';
import 'src/presentation/providers/ordenes_vivo_provider.dart';
import 'src/presentation/providers/ordenes_modelo_vivo_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '/src/presentation/providers/pesaje_manual_provider.dart';
import '/src/presentation/providers/pesajes_list_provider.dart';
import 'src/presentation/providers/productos_vivo_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';
import 'src/presentation/providers/trab_registro_prov.dart';
import '/src/presentation/providers/trabajadores_modelo_provider.dart';
import '/src/presentation/providers/trabajadores_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import 'src/presentation/providers/ventas_vivo_provider.dart';
import '/src/presentation/providers/vehiculos_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import '/src/presentation/ui/login_view.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isDesktop) {
    await WindowManager.instance.ensureInitialized();
    await windowManager.setMinimumSize(const Size(1366, 768));
    await windowManager.setPreventClose(true);
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BancosProv()),
        ChangeNotifierProvider(create: (_) => CajaProv()),
        ChangeNotifierProvider(create: (_) => CamalesProv()),
        ChangeNotifierProvider(create: (_) => CamalesJabasProv()),
        ChangeNotifierProvider(create: (_) => ClientesProv()),
        ChangeNotifierProvider(create: (_) => ComprasVivoProv()),
        ChangeNotifierProvider(create: (_) => ComprasBeneficiadoProv()),
        ChangeNotifierProvider(create: (_) => EstadoBancoProv()),
        ChangeNotifierProvider(create: (_) => EstadoClienteProv()),
        ChangeNotifierProvider(create: (_) => EstadoGavipoProv()),
        ChangeNotifierProvider(create: (_) => EstadoSinNombreProv()),
        ChangeNotifierProvider(create: (_) => EstadoProveedorProv()),
        ChangeNotifierProvider(create: (_) => EstadoTrabajadorProv()),
        ChangeNotifierProvider(create: (_) => JabasProv()),
        ChangeNotifierProvider(create: (_) => AyerHoyProv()),
        ChangeNotifierProvider(create: (_) => OrdenesVivoProv()),
        ChangeNotifierProvider(create: (_) => OrdenesBeneficiadoProv()),
        ChangeNotifierProvider(create: (_) => OrdenesModeloVivoProv()),
        ChangeNotifierProvider(create: (_) => OrdenesModeloBeneficiadoProv()),
        ChangeNotifierProvider(create: (_) => PesadoresProv()),
        ChangeNotifierProvider(create: (_) => PesajesProv()),
        ChangeNotifierProvider(create: (_) => PesajeManualProv()),
        ChangeNotifierProvider(create: (_) => ProductosVivoProv()),
        ChangeNotifierProvider(create: (_) => ProductosBeneficiadoProv()),
        ChangeNotifierProvider(create: (_) => ProveedoresProv()),
        ChangeNotifierProvider(create: (_) => TrabajadoresProv()),
        ChangeNotifierProvider(create: (_) => TrabajadoresModeloProv()),
        ChangeNotifierProvider(create: (_) => TrabRegistroProv()),
        ChangeNotifierProvider(create: (_) => UsuariosProv()),
        ChangeNotifierProvider(create: (_) => VentasVivoProv()),
        ChangeNotifierProvider(create: (_) => VentasBeneficiadoProv()),
        ChangeNotifierProvider(create: (_) => VehiculosProvider()),
        ChangeNotifierProvider(create: (_) => ZonasProv()),
      ],
      child: FluentApp(
        title: 'MABEL Admin',
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('es')],
        locale: const Locale('es'),
        theme: FluentThemeData(),
        home: const LoginPage(),
      ),
    );
  }
}
