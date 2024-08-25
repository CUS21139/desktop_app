import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/pesador.dart';
import '../../../models/producto_vivo.dart';
import '/src/models/zona.dart';

import '/src/presentation/components/custom_datepicker.dart';
import '/src/presentation/components/custom_dialogs.dart';
import '/src/presentation/components/hoy_ayer_widget.dart';
import '/src/presentation/providers/ayer_hoy_provider.dart';

import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/providers/usuarios_provider.dart';
import '../../providers/ventas_vivo_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import '/src/presentation/utils/text_style.dart';

import '../../../services/filtro_vivo_service.dart';
import '../../../services/ventas_vivo_service.dart';
import '/src/utils/date_formats.dart';

class FiltrosVentasVivo extends StatefulWidget {
  const FiltrosVentasVivo({super.key});

  @override
  State<FiltrosVentasVivo> createState() => _FiltrosVentasVivoState();
}

class _FiltrosVentasVivoState extends State<FiltrosVentasVivo> {
  final filtroServ = FiltroVivoService();

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

  final nroVentaCtrl = TextEditingController();

  Zona? zona;
  final zonaCtrl = TextEditingController();
  Pesador? pesador;
  final pesadorCtrl = TextEditingController();
  Cliente? cliente;
  final clienteCtrl = TextEditingController();
  Camal? camal;
  final camalCtrl = TextEditingController();
  ProductoVivo? producto;
  final productoCtrl = TextEditingController();

  void cleanFiltrosControllers() {
    setState(() {
      zona = null;
      zonaCtrl.clear();
      pesador = null;
      pesadorCtrl.clear();
      cliente = null;
      clienteCtrl.clear();
      camal = null;
      camalCtrl.clear();
      producto = null;
      productoCtrl.clear();
      fecha = null;
      fechaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.15,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buscar por Nro Venta', style: subtitleDataDBStyle),
          const SizedBox(height: 15),
          TextBox(
            placeholder: 'Nro Venta',
            controller: nroVentaCtrl,
          ),
          const SizedBox(height: 20),
          Center(
            child: FilledButton(
              onPressed: () => buscarID(int.parse(nroVentaCtrl.text)),
              child: const Text('Buscar'),
            ),
          ),
          const SizedBox(height: 30),
          const Text('Filtros de Busqueda', style: subtitleDataDBStyle),
          const HoyAyerWidget(),
          Consumer<AyerHoyProv>(builder: (_, service, __) {
            return Checkbox(
              content: const Text('Ver Anuladas'),
              checked: service.anuladas,
              onChanged: (v) {
                service.anuladas = v!;
                if (v) {
                  verAnuladas();
                } else {
                  refresh();
                }
              },
            );
          }),
          const SizedBox(height: 30),
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
          Consumer<ZonasProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Zona>(
                controller: zonaCtrl,
                placeholder: 'Zona',
                items: service.zonas
                    .map((e) => AutoSuggestBoxItem<Zona>(
                          value: e,
                          label: e.nombre,
                        ))
                    .toList(),
                onSelected: (item) {
                  setState(() => zona = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<PesadoresProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Pesador>(
                controller: pesadorCtrl,
                placeholder: 'Pesador',
                items: service.pesadores
                    .map((e) => AutoSuggestBoxItem<Pesador>(
                          value: e,
                          label: e.nombre,
                        ))
                    .toList(),
                onSelected: (item) {
                  setState(() => pesador = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<ClientesProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Cliente>(
                controller: clienteCtrl,
                placeholder: 'Cliente',
                items: service.clientes
                    .map(
                      (e) => AutoSuggestBoxItem<Cliente>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onSelected: (item) {
                  setState(() => cliente = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 15),
          Consumer<CamalesProv>(
            builder: (_, service, __) {
              return AutoSuggestBox<Camal>(
                controller: camalCtrl,
                placeholder: 'Camal',
                items: service.camales
                    .map((e) => AutoSuggestBoxItem<Camal>(
                        value: e,
                        label: e.nombre,
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => camal = item.value);
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
                        child: Text(e.nombre, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onSelected: (item) {
                  setState(() => producto = item.value);
                },
              );
            },
          ),
          const SizedBox(height: 20),
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
        .filtrarVentas(
      context,
      date,
      camal: camal,
      cliente: cliente,
      pesador: pesador,
      producto: producto,
      zona: zona,
    )
        .then((value) {
      cleanFiltrosControllers();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  Future<void> buscarID(int id) async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    CustomDialog.loadingDialog(context);
    await VentasVivoService().getVenta(id, token).then((value) {
      ventaProv.setVentas(value, true);
      ventaProv.ventaInitState();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  Future<void> verAnuladas() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ayerHoyProv = Provider.of<AyerHoyProv>(context, listen: false);

    final now = ayerHoyProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await VentasVivoService().getVentas(token, ini, fin).then((value) {
      ventaProv.setVentas(value, true);
      ventaProv.ventaInitState();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }

  void refresh() async {
    final token = Provider.of<UsuariosProv>(context, listen: false).token;
    final ventaProv = Provider.of<VentasVivoProv>(context, listen: false);
    final ayerHoyProv = Provider.of<AyerHoyProv>(context, listen: false);
    final now = ayerHoyProv.ayer
        ? DateTime.now().subtract(const Duration(days: 1))
        : DateTime.now();
    final ini = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final fin = DateTime(now.year, now.month, now.day, 23, 59, 59);

    CustomDialog.loadingDialog(context);
    await VentasVivoService().getVentas(token, ini, fin).then((value) {
      ventaProv.setVentas(value, false);
      ventaProv.ventaInitState();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }
}
