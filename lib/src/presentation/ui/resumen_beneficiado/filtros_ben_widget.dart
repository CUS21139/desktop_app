import 'package:app_desktop/src/services/filtro_vivo_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../providers/compras_vivo_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '../../providers/ventas_vivo_provider.dart';
import '/src/services/excel_service.dart';
import '/src/services/resumen__service.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/button_excel.dart';
import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/hoy_ayer_widget.dart';
import '/src/presentation/providers/ayer_hoy_provider.dart';
import '/src/presentation/utils/text_style.dart';
import '/src/utils/date_formats.dart';

class FiltrosResumenBeneficiado extends StatefulWidget {
  const FiltrosResumenBeneficiado({super.key});

  @override
  State<FiltrosResumenBeneficiado> createState() => _FiltrosResumenBeneficiadoState();
}

class _FiltrosResumenBeneficiadoState extends State<FiltrosResumenBeneficiado> {
  final scrollCtrl = ScrollController();
  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.15,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text('Filtrar por fecha', style: subtitleDataDBStyle),
          const SizedBox(height: 15),
          TextBox(
            placeholder: 'Fecha',
            controller: fechaCtrl,
            readOnly: true,
            onTap: () async {
              fecha = await CustomDatePicker.showPicker(context);
              if (fecha != null) fechaCtrl.text = date.format(fecha!);
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: filtrar,
            child: const Text('Buscar'),
          ),
          const SizedBox(height: 20),
          const HoyAyerWidget(),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ExcelButton(onPressed: () {
              final ventasProv = Provider.of<VentasVivoProv>(context, listen: false);
              final comprasProv = Provider.of<ComprasVivoProv>(context, listen: false);
              final productoProv = Provider.of<ProductosVivoProv>(context, listen: false);
              Map<String, Map<String, dynamic>> map =
                  TableResumenCtrl.mapResumenVentaCompra(
                productos: productoProv.productos,
                ventas: ventasProv.ventasResumen,
                compras: comprasProv.comprasResumen,
              );
              ExcelService().exportarResumen(map);
            }),
          ),
        ],
      ),
    );
  }

  Future<void> filtrar() async {
    final fechaProv = Provider.of<AyerHoyProv>(context, listen: false);
    DateTime date;
    if (fecha != null) {
      date = fecha!;
    } else if (fechaProv.ayer) {
      date = DateTime.now().subtract(const Duration(days: 1));
    } else {
      date = DateTime.now();
    }
    CustomDialog.loadingDialog(context);
    await FiltroVivoService().filtrarResumen(context, date).then((value) {
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }
}
