import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/custom_dialogs.dart';

import '../providers/compras_vivo_provider.dart';
import '/src/presentation/providers/ayer_hoy_provider.dart';
import '../providers/ordenes_vivo_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '../providers/ventas_vivo_provider.dart';

import '../../services/compras_vivos_service.dart';
import '../../services/ordenes_vivo_service.dart';
import '../../services/ventas_vivo_service.dart';

class HoyAyerWidget extends StatefulWidget {
  const HoyAyerWidget({super.key});

  @override
  State<HoyAyerWidget> createState() => _HoyAyerWidgetState();
}

class _HoyAyerWidgetState extends State<HoyAyerWidget> {
  final compraServ = ComprasVivosService();
  final ordenServ = OrdenesVivoService();
  final ventaServ = VentasVivoService();
  final date = DateTime.now();

  Future<void> getHoy(bool anuladas) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final ordenProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ini = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final fin = DateTime(date.year, date.month, date.day, 23, 59, 59);
    try {
      await ordenServ.getOrdenes(token, ini, fin).then((value) {
        ordenProv.ordenes = value;
        ordenProv.ordenesResumen = value;
      });
      await compraServ.getCompras(token, ini, fin).then((value) {
        compraProv.compras = value;
        compraProv.comprasResumen = value;
      });
      await ventaServ.getVentas(token, ini, fin).then((value) {
        ventaProv.setVentas(value, anuladas);
        ventaProv.ventasResumen = value;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> getAyer(bool anuladas) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv = Provider.of<ComprasVivoProv>(context, listen: false);
    final ordenProv = Provider.of<OrdenesVivoProv>(context, listen: false);
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ini = DateTime(date.year, date.month, date.day, 0, 0, 0).subtract(const Duration(days: 1));
    final fin = DateTime(date.year, date.month, date.day, 23, 59, 59).subtract(const Duration(days: 1));
    try {
      await ordenServ.getOrdenes(token, ini, fin).then((value) {
        ordenProv.ordenes = value;
        ordenProv.ordenesResumen = value;
      });
      await compraServ.getCompras(token, ini, fin).then((value) {
        compraProv.compras = value;
        compraProv.comprasResumen = value;
      });
      await ventaServ.getVentas(token, ini, fin).then((value) {
        ventaProv.setVentas(value, anuladas);
        ventaProv.ventasResumen = value;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyerHoyProv>(builder: (_, service, __) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Checkbox(
            content: const Text('Ver Hoy'),
            checked: service.hoy,
            onChanged: (v) async {
              service.hoy = v!;
              if (v) {
                service.ayer = false;
                CustomDialog.loadingDialog(context);
                await getHoy(service.anuladas).then((value) {
                  Navigator.pop(context);
                }).catchError((e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                });
              }
            },
          ),
          const SizedBox(height: 20),
          Checkbox(
            content: const Text('Ver Ayer'),
            checked: service.ayer,
            onChanged: (v) async {
              service.ayer = v!;
              if (v) {
                service.hoy = false;
                CustomDialog.loadingDialog(context);
                await getAyer(service.anuladas).then((value) {
                  Navigator.pop(context);
                }).catchError((e) {
                  Navigator.pop(context);
                  CustomDialog.errorDialog(context, e.toString());
                });
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
