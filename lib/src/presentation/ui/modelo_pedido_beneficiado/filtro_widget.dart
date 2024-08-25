import 'package:app_desktop/src/services/filtro_vivo_service.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/src/presentation/components/custom_dialogs.dart';

import '/src/presentation/providers/camales_provider.dart';
import '/src/presentation/providers/clientes_provider.dart';
import '/src/presentation/providers/pesadores_provider.dart';
import '../../providers/productos_vivo_provider.dart';
import '/src/presentation/providers/zonas_provider.dart';

import '/src/presentation/utils/text_style.dart';

import '/src/models/camal.dart';
import '/src/models/cliente.dart';
import '/src/models/pesador.dart';
import '../../../models/producto_vivo.dart';
import '/src/models/zona.dart';

class FiltrosModeloProgramacionBeneficiado extends StatefulWidget {
  const FiltrosModeloProgramacionBeneficiado({super.key});

  @override
  State<FiltrosModeloProgramacionBeneficiado> createState() => _FiltrosModeloProgramacionBeneficiadoState();
}

class _FiltrosModeloProgramacionBeneficiadoState extends State<FiltrosModeloProgramacionBeneficiado> {
  final filtroServ = FiltroVivoService();

  DateTime? fecha;
  final fechaCtrl = TextEditingController();

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
    fecha = null;
    fechaCtrl.clear();
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
          const Text('Filtros de Busqueda', style: subtitleDataDBStyle),
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
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
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
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
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
                    .map((e) => AutoSuggestBoxItem<Cliente>(
                          value: e,
                          label: e.nombre,
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                        ))
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
                          child: Text(e.nombre, overflow: TextOverflow.ellipsis)
                        ))
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
    
    CustomDialog.loadingDialog(context);
    await filtroServ.filtrarOrdenesModelo(
      context,
      camal: camal,
      cliente: cliente,
      pesador: pesador,
      producto: producto,
      zona: zona,
    ).then((value) {
      cleanFiltrosControllers();
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.errorDialog(context, e.toString());
    });
  }
}
