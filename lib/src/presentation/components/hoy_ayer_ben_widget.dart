import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/compra_beneficiado.dart';
import '/src/models/ordenes_beneficiado.dart';
import '/src/models/venta_beneficiado.dart';

import '/src/presentation/providers/ayer_hoy_ben_provider.dart';
import '/src/presentation/providers/compras_beneficiado_provider.dart';
import '/src/presentation/providers/ordenes_beneficiado_provider.dart';
import '/src/presentation/providers/ventas_beneficiado_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';

import '/src/services/compras_beneficiado_service.dart';
import '/src/services/ordenes_beneficiado_service.dart';
import '/src/services/ventas_beneficiado_service.dart';

import '/src/presentation/components/custom_dialogs.dart';

class HoyAyerBeneficiadoWidget extends StatefulWidget {
  const HoyAyerBeneficiadoWidget({super.key});

  @override
  State<HoyAyerBeneficiadoWidget> createState() =>
      _HoyAyerBeneficiadoWidgetState();
}

class _HoyAyerBeneficiadoWidgetState extends State<HoyAyerBeneficiadoWidget> {
  final compraServ = ComprasBeneficiadoService();
  final ordenServ = OrdenesBeneficiadoService();
  final ventaServ = VentasBeneficiadoService();
  final date = DateTime.now();

  Future<void> getHoy(bool anuladas) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv =
        Provider.of<ComprasBeneficiadoProv>(context, listen: false);
    final ordenProv =
        Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ventaProv =
        Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final ini = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final fin = DateTime(date.year, date.month, date.day, 23, 59, 59);

    await Future.wait([
      ordenServ.getOrdenes(token, ini, fin),
      compraServ.getCompras(token, ini, fin),
      ventaServ.getVentas(token, ini, fin)
    ]).then((result) {
      ordenProv.ordenes = result[0] as List<OrdenBeneficiado>;
      ordenProv.ordenesResumen = result[0] as List<OrdenBeneficiado>;

      compraProv.compras = result[1] as List<CompraBeneficiado>;
      compraProv.comprasResumen = result[1] as List<CompraBeneficiado>;

      ventaProv.setVentas(result[2] as List<VentaBeneficiado>, anuladas);
      ventaProv.ventasResumen = result[2] as List<VentaBeneficiado>;
    }).catchError((e) {
      throw Exception(e.toString());
    });
  }

  Future<void> getAyer(bool anuladas) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final compraProv =
        Provider.of<ComprasBeneficiadoProv>(context, listen: false);
    final ordenProv =
        Provider.of<OrdenesBeneficiadoProv>(context, listen: false);
    final ventaProv =
        Provider.of<VentasBeneficiadoProv>(context, listen: false);
    final ini = DateTime(date.year, date.month, date.day, 0, 0, 0)
        .subtract(const Duration(days: 1));
    final fin = DateTime(date.year, date.month, date.day, 23, 59, 59)
        .subtract(const Duration(days: 1));
    
    await Future.wait([
      ordenServ.getOrdenes(token, ini, fin),
      compraServ.getCompras(token, ini, fin),
      ventaServ.getVentas(token, ini, fin)
    ]).then((result) {
      ordenProv.ordenes = result[0] as List<OrdenBeneficiado>;
      ordenProv.ordenesResumen = result[0] as List<OrdenBeneficiado>;

      compraProv.compras = result[1] as List<CompraBeneficiado>;
      compraProv.comprasResumen = result[1] as List<CompraBeneficiado>;

      ventaProv.setVentas(result[2] as List<VentaBeneficiado>, anuladas);
      ventaProv.ventasResumen = result[2] as List<VentaBeneficiado>;
    }).catchError((e) {
      throw Exception(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyerHoyBenProv>(builder: (_, service, __) {
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
