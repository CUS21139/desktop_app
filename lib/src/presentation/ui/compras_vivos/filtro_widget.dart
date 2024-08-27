import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../models/producto_vivo.dart';
import '/src/models/proveedor.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '../../components/hoy_ayer_vivo_widget.dart';
import '../../providers/ayer_hoy_vivo_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/providers/proveedores_provider.dart';

import '/src/presentation/utils/text_style.dart';
import '/src/services/filtro_vivo_service.dart';
import '/src/utils/date_formats.dart';

class FiltrosCompras extends StatefulWidget {
  const FiltrosCompras({super.key});

  @override
  State<FiltrosCompras> createState() => _FiltrosComprasState();
}

class _FiltrosComprasState extends State<FiltrosCompras> {
  final filtroServ = FiltroVivoService();

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  ProductoVivo? producto;
  final productoCtrl = TextEditingController();
  Proveedor? proveedor;
  final proveedorCtrl = TextEditingController();

  void cleanFiltrosControllers() {
    setState(() {
      producto = null;
      productoCtrl.clear();
      proveedor = null;
      proveedorCtrl.clear();
      fecha = null;
      fechaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.15,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HoyAyerVivoWidget(),
          const SizedBox(height: 20),
          const Text('Filtros de Busqueda', style: subtitleDataDBStyle),
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
          const SizedBox(height: 15),
          Consumer<ProveedoresProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Proveedor>(
                controller: proveedorCtrl,
                placeholder: 'Proveedor',
                items: service.proveedores
                    .map((e) => AutoSuggestBoxItem<Proveedor>(
                          value: e,
                          label: e.nombre,
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                        ))
                    .toList(),
                onSelected: (item) {
                  setState(() => proveedor = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<ProductosVivoProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<ProductoVivo>(
                controller: productoCtrl,
                placeholder: 'Producto',
                items: service.productos
                    .map((e) => AutoSuggestBoxItem<ProductoVivo>(
                          value: e,
                          label: e.nombre,
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                        ))
                    .toList(),
                onSelected: (item) {
                  setState(() => producto = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 50),
          Center(
            child: FilledButton(
              onPressed: filtrar,
              child: const Text('Filtrar'),
            ),
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
      fechaProv.ayer = false;
      fechaProv.hoy = false;
    } else if (fechaProv.ayer) {
      date = DateTime.now().subtract(const Duration(days: 1));
    } else {
      date = DateTime.now();
    }
    CustomDialog.loadingDialog(context);
    await filtroServ
        .filtrarCompras(
      context,
      date,
      proveedor: proveedor,
      producto: producto,
    )
        .then((value) {
      cleanFiltrosControllers();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }
}
